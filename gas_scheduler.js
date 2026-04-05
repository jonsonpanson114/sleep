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
const RUN_LOCK_WAIT_MS = 5000;
const MAX_SUBS_PER_REQUEST = 100;
const LAST_RUN_MINUTE_KEY = 'last_processed_minute';

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
    if (!e || !e.postData || !e.postData.contents) {
      return ContentService.createTextOutput(JSON.stringify({ error: 'Invalid request body' }))
        .setMimeType(ContentService.MimeType.JSON);
    }

    const data = JSON.parse(e.postData.contents);
    if (data.action === 'subscribe') {
      const sub = data.subscription;
      const settings = data.settings;
      if (!sub || !sub.endpoint) {
        return ContentService.createTextOutput(JSON.stringify({ error: 'Missing subscription endpoint' }))
          .setMimeType(ContentService.MimeType.JSON);
      }
      
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
        const endpoints = sheet.getRange(2, 1, lastRow - 1, 1).getValues();
        for (let i = 0; i < endpoints.length; i++) {
          if (endpoints[i][0] === endpoint) {
            foundIndex = i + 2;
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

    return ContentService.createTextOutput(JSON.stringify({ error: 'Unsupported action' }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ error: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

// 定期実行(Cron)用関数: 毎分回して通知すべきユーザーを探す
function checkAndSendPushes() {
  const lock = LockService.getScriptLock();
  const gotLock = lock.tryLock(RUN_LOCK_WAIT_MS);
  if (!gotLock) {
    console.warn('Skipped run: another execution is still running.');
    return;
  }

  try {
    const startTime = new Date();
    const minuteKey = getMinuteKey(startTime);
    const props = PropertiesService.getScriptProperties();
    const lastMinute = props.getProperty(LAST_RUN_MINUTE_KEY);
    if (lastMinute === minuteKey) {
      console.log('Skipped duplicate run in same minute: ' + minuteKey);
      return;
    }

    const sheet = getSheet();
    const lastRow = sheet.getLastRow();
    if (lastRow < 2) {
      props.setProperty(LAST_RUN_MINUTE_KEY, minuteKey);
      return;
    }

    // 必要な列(A-I列)のみを取得
    // Index 0:Endpoint, 1:SubJSON, 2:bHour, 3:bMin, 4:wHour, 5:wMin, 6:bEnabled, 7:wEnabled, 8:Offset
    const values = sheet.getRange(2, 1, lastRow - 1, 9).getValues();
    const now = new Date();
    const currentTotalMinutes = now.getHours() * 60 + now.getMinutes();

    const bedtimeTargets = [];
    const wakeTargets = [];

    for (let i = 0; i < values.length; i++) {
      const row = values[i];
      try {
        const subJsonStr = row[1];
        if (!subJsonStr || typeof subJsonStr !== 'string' || subJsonStr.length < 20) continue;

        const bHour = Number(row[2]);
        const bMin = Number(row[3]);
        const wHour = Number(row[4]);
        const wMin = Number(row[5]);
        const bEnabled = row[6] === true || String(row[6]).toLowerCase() === 'true';
        const wEnabled = row[7] === true || String(row[7]).toLowerCase() === 'true';
        const offset = Number(row[8] || 0);

        if ([bHour, bMin, wHour, wMin, offset].some(isNaN)) continue;

        let needsBedtime = false;
        let needsWake = false;

        if (bEnabled) {
          const targetBedtimeMinutes = (bHour * 60 + bMin - offset + 1440) % 1440;
          needsBedtime = (currentTotalMinutes === targetBedtimeMinutes);
        }

        if (wEnabled) {
          const targetWakeMinutes = (wHour * 60 + wMin) % 1440;
          needsWake = (currentTotalMinutes === targetWakeMinutes);
        }

        if (!needsBedtime && !needsWake) continue;

        const parsedSub = JSON.parse(subJsonStr);
        if (!parsedSub || !parsedSub.endpoint) continue;

        if (needsBedtime) bedtimeTargets.push(parsedSub);
        if (needsWake) wakeTargets.push(parsedSub);
      } catch (err) {
        // 特定行エラーで全体停止しない
        console.error('Error processing row ' + (i + 2) + ': ' + (err && err.message ? err.message : err));
      }
    }

    // 通知送信(Vercel叩く)
    if (bedtimeTargets.length > 0) {
      sendToVercel(bedtimeTargets, 'そろそろ就寝の時間です', '今から布団に入りましょう 🌙');
    }
    if (wakeTargets.length > 0) {
      sendToVercel(wakeTargets, 'おはようございます！', '起床ルーティンを始めましょう ☀️');
    }

    props.setProperty(LAST_RUN_MINUTE_KEY, minuteKey);
    const duration = new Date().getTime() - startTime.getTime();
    console.log('Execution finished: ' + values.length + ' rows processed in ' + duration + 'ms. Targets found: ' + (bedtimeTargets.length + wakeTargets.length));
  } catch (err) {
    console.error('checkAndSendPushes fatal: ' + (err && err.message ? err.message : err));
  } finally {
    lock.releaseLock();
  }
}

function sendToVercel(subscriptions, title, body) {
  for (let i = 0; i < subscriptions.length; i += MAX_SUBS_PER_REQUEST) {
    const chunk = subscriptions.slice(i, i + MAX_SUBS_PER_REQUEST);
    const payload = {
      title: title,
      body: body,
      subscriptions: chunk
    };

    const options = {
      method: 'post',
      contentType: 'application/json',
      payload: JSON.stringify(payload),
      muteHttpExceptions: true
    };

    try {
      const response = UrlFetchApp.fetch(VERCEL_SEND_PUSH_URL, options);
      const code = response.getResponseCode();
      if (code < 200 || code >= 300) {
        console.error('Vercel send-push returned HTTP ' + code + ': ' + response.getContentText());
      }
    } catch (e) {
      console.error('Error sending push to Vercel: ' + (e && e.message ? e.message : e));
    }
  }
}

function getMinuteKey(dateObj) {
  const tz = Session.getScriptTimeZone() || 'Asia/Tokyo';
  return Utilities.formatDate(dateObj, tz, 'yyyy-MM-dd HH:mm');
}

// トリガーの重複作成を防ぎつつ、必要なら1分おきの実行を設定
function installTriggerIfNeeded() {
  try {
    const handlerName = 'checkAndSendPushes';
    const triggers = ScriptApp.getProjectTriggers();
    
    // すでに同じハンドラーのトリガーがあるか確認
    let exists = false;
    for (let i = 0; i < triggers.length; i++) {
      if (triggers[i].getHandlerFunction() === handlerName) {
        exists = true;
        break;
      }
    }

    if (exists) {
      console.log('Trigger for ' + handlerName + ' already exists. No action taken.');
      return;
    }

    // 新規作成
    ScriptApp.newTrigger(handlerName)
      .timeBased()
      .everyMinutes(1)
      .create();
      
    console.log('Successfully installed 1-minute trigger for ' + handlerName);
  } catch (err) {
    // Google側の一時的なサーバーエラーなどで落ちても、メール通知を飛ばさないようにログ出力に留める
    console.error('Trigger management error (likely Google server issue): ' + (err && err.message ? err.message : err));
  }
}

// 互換性のためのエイリアス（手動でリセットしたい時用）
function resetAndInstallCheckTrigger() {
  try {
    const triggers = ScriptApp.getProjectTriggers();
    for (let i = 0; i < triggers.length; i++) {
      if (triggers[i].getHandlerFunction() === 'checkAndSendPushes') {
        ScriptApp.deleteTrigger(triggers[i]);
      }
    }
  } catch (e) {
    console.warn('Could not delete existing triggers: ' + e.message);
  }
  installTriggerIfNeeded();
}
