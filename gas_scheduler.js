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
      const dataRange = sheet.getDataRange();
      const values = dataRange.getValues();
      
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

      // 既存のエンドポイントがあれば更新、なければ追加
      let foundIndex = -1;
      for (let i = 1; i < values.length; i++) {
        if (values[i][0] === endpoint) {
          foundIndex = i + 1;
          break;
        }
      }

      if (foundIndex > 0) {
        sheet.getRange(foundIndex, 1, 1, rowData.length).setValues([rowData]);
      } else {
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
  const sheet = getSheet();
  if (sheet.getLastRow() < 2) return; // データなし

  const values = sheet.getDataRange().getValues();
  const now = new Date();
  
  // GASのタイムゾーン設定(JST)に基づく現在時刻を利用
  const currentHour = now.getHours();
  const currentMinute = now.getMinutes();

  let bedtimeTargets = [];
  let wakeTargets = [];

  for (let i = 1; i < values.length; i++) {
    const row = values[i];
    const subJson = JSON.parse(row[1]);
    const bHour = row[2];
    const bMin = row[3];
    const wHour = row[4];
    const wMin = row[5];
    const bEnabled = row[6];
    const wEnabled = row[7];
    const offset = row[8];

    // 就寝リマインダー判定 (設定時間 - オフセット)
    if (bEnabled === true || String(bEnabled).toLowerCase() === 'true') {
      // オフセット分を引いた時間を計算
      let targetDate = new Date();
      targetDate.setHours(bHour);
      targetDate.setMinutes(bMin);
      targetDate.setMinutes(targetDate.getMinutes() - offset);
      
      if (currentHour === targetDate.getHours() && currentMinute === targetDate.getMinutes()) {
        bedtimeTargets.push(subJson);
      }
    }

    // 起床リマインダー判定
    if (wEnabled === true || String(wEnabled).toLowerCase() === 'true') {
      if (currentHour === wHour && currentMinute === wMin) {
        wakeTargets.push(subJson);
      }
    }
  }

  // 通知送信(Vercel叩く)
  if (bedtimeTargets.length > 0) {
    sendToVercel(bedtimeTargets, 'そろそろ就寝の時間です', '今から布団に入りましょう 🌙');
  }
  if (wakeTargets.length > 0) {
    sendToVercel(wakeTargets, 'おはようございます！', '起床ルーティンを始めましょう ☀️');
  }
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
