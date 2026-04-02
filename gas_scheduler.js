/**
 * Web Push スケジューラー for GAS
 *
 * 1. [拡張機能] -> [Apps Script] にこのコードを貼り付ける
 * 2. `VERCEL_SEND_PUSH_URL` を自分のVercelのURLに変更する
 * 3. [デプロイ] -> [新しいデプロイ] -> 実行ユーザー:自分, アクセスできるユーザー:全員 でデプロイ
 * 4. 出力されたURLをVercelの環境変数 `VITE_GAS_URL` にセットする
 * 5. 左メニューの「トリガー(時計マーク)」から `checkAndSendPushes` を「分ベースのタイマー」「1分おき」で設定する
 */

const VERCEL_SEND_PUSH_URL = 'https://sleep-alpha-indol.vercel.app/api/send-push';

function getSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName('Subscriptions');
  if (!sheet) {
    sheet = ss.insertSheet('Subscriptions');
    sheet.appendRow([
      'Endpoint', 
      'SubscriptionJSON', 
      'BedtimeHour', 
      'BedtimeMinute', 
      'WakeHour', 
      'WakeMinute', 
      'BedtimeEnabled', 
      'WakeEnabled',
      'OffsetMinutes',
      'LastUpdate'
    ]);
  }
  return sheet;
}

// Vercel(Flutter)からのPOSTリクエストを受け取る
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    if (data.action === 'subscribe') {
      const sub = data.subscription;
      const settings = data.settings;
      
      const sheet = getSheet();
      const lastRow = sheet.getLastRow();
      
      const endpoint = sub.endpoint;
      const subJsonStr = JSON.stringify(sub);
      const rowData = [
        endpoint,
        subJsonStr,
        settings.bedtimeHour,
        settings.bedtimeMinute,
        settings.wakeHour,
        settings.wakeMinute,
        settings.bedtimeEnabled,
        settings.wakeEnabled,
        settings.offset || 30, // デフォルト30分前
        new Date()
      ];

      // 既存のエンドポイントがあるか第一列(Endpoint列)のみを検索して特定
      let foundIndex = -1;
      if (lastRow >= 2) {
        const endpoints = sheet.getRange(1, 1, lastRow, 1).getValues();
        for (let i = 1; i < endpoints.length; i++) {
          if (endpoints[i][0] === endpoint) {
            foundIndex = i + 1;
            break;
          }
        }
      }

      if (foundIndex > 0) {
        // 見つかった場合はその行だけを更新
        sheet.getRange(foundIndex, 1, 1, rowData.length).setValues([rowData]);
      } else {
        // 見つからない場合は新しく追加
        sheet.appendRow(rowData);
      }

      return ContentService.createTextOutput(JSON.stringify({ status: 'success' }))
        .setMimeType(ContentService.MimeType.JSON);
    }
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ error: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

// 定期実行(Cron)用関数: 毎分回して通知すべきユーザーを探す
function checkAndSendPushes() {
  const startTime = new Date();
  const sheet = getSheet();
  const lastRow = sheet.getLastRow();
  
  // データなし(ヘッダーのみ)の場合は終了
  if (lastRow < 2) return;

  // 必要な列(A-I列)のみを取得し、読み取り負荷とメモリ使用量を軽減
  // Index 0:Endpoint, 1:SubJSON, 2:bHour, 3:bMin, 4:wHour, 5:wMin, 6:bEnabled, 7:wEnabled, 8:Offset
  const range = sheet.getRange(2, 1, lastRow - 1, 9);
  const values = range.getValues();
  
  const now = new Date();
  const currentTotalMinutes = now.getHours() * 60 + now.getMinutes();

  let bedtimeTargets = [];
  let wakeTargets = [];

  for (let i = 0; i < values.length; i++) {
    const row = values[i];
    try {
      const subJsonStr = row[1];
      if (!subJsonStr) continue;

      const bHour = Number(row[2]);
      const bMin = Number(row[3]);
      const wHour = Number(row[4]);
      const wMin = Number(row[5]);
      const bEnabled = row[6] === true || String(row[6]).toLowerCase() === 'true';
      const wEnabled = row[7] === true || String(row[7]).toLowerCase() === 'true';
      const offset = Number(row[8] || 0);

      // 就寝リマインダー判定 (数値計算で比較し、メモリ消費を抑える)
      if (bEnabled) {
        // 設定時間からオフセットを引いた「日の総分量」を計算 (マイナス値考慮)
        const targetBedtimeMinutes = (bHour * 60 + bMin - offset + 1440) % 1440;
        if (currentTotalMinutes === targetBedtimeMinutes) {
          bedtimeTargets.push(JSON.parse(subJsonStr));
        }
      }

      // 起床リマインダー判定
      if (wEnabled) {
        const targetWakeMinutes = (wHour * 60 + wMin) % 1440;
        if (currentTotalMinutes === targetWakeMinutes) {
          wakeTargets.push(JSON.parse(subJsonStr));
        }
      }
    } catch (err) {
      // 特定の行でエラーが起きても全体を止めない
      console.error('Error processing row ' + (i + 2) + ':', err);
    }
  }

  // 通知送信(Vercel叩く)
  if (bedtimeTargets.length > 0) {
    sendToVercel(bedtimeTargets, 'そろそろ就寝の時間です', '今から布団に入りましょう 🌙');
  }
  if (wakeTargets.length > 0) {
    sendToVercel(wakeTargets, 'おはようございます！', '起床ルーティンを始めましょう ☀️');
  }

  const duration = new Date().getTime() - startTime.getTime();
  console.log('Execution finished: ' + values.length + ' rows processed in ' + duration + 'ms. Targets found: ' + (bedtimeTargets.length + wakeTargets.length));
}

function sendToVercel(subscriptions, title, body) {
  const payload = {
    title: title,
    body: body,
    subscriptions: subscriptions
  };

  const options = {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify(payload)
  };

  try {
    UrlFetchApp.fetch(VERCEL_SEND_PUSH_URL, options);
  } catch(e) {
    console.error('Error sending push to Vercel:', e);
  }
}
