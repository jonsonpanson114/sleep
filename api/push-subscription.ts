const gasUrl = process.env.GAS_URL || process.env.VITE_GAS_URL || '';

export default async function handler(req: any, res: any) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { subscription, settings } = req.body ?? {};

  if (!gasUrl) {
    console.error('GAS_URL (or VITE_GAS_URL) is not set');
    return res.status(500).json({ error: 'GAS URL configuration missing' });
  }

  if (!subscription || typeof subscription !== 'object') {
    return res.status(400).json({ error: 'Missing or invalid subscription' });
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
