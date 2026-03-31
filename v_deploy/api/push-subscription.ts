import webpush from 'web-push';

const publicKey = process.env.VAPID_PUBLIC_KEY || '';
const privateKey = process.env.VAPID_PRIVATE_KEY || '';
const gasUrl = process.env.VITE_GAS_URL || '';

if (publicKey && privateKey) {
  webpush.setVapidDetails(
    'mailto:developer@example.com',
    publicKey,
    privateKey
  );
}

export default async function handler(req: any, res: any) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { subscription, settings } = req.body;

  if (!gasUrl) {
    console.error('VITE_GAS_URL is not set');
    return res.status(500).json({ error: 'GAS URL configuration missing' });
  }

  try {
    // GASのウェブアプリURLに対してPOSTリクエストを送信
    const response = await fetch(gasUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        action: 'subscribe',
        subscription: subscription, // オブジェクトで渡す
        settings: settings || {}
      }),
    });

    const text = await response.text();
    console.log('GAS Response:', text);

    return res.status(200).json({ ok: true });
  } catch (error) {
    console.error('Error sending to GAS:', error);
    return res.status(500).json({ error: 'Failed to sync subscription' });
  }
}
