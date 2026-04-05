import webpush from 'web-push';

const publicKey = process.env.VAPID_PUBLIC_KEY || '';
const privateKey = process.env.VAPID_PRIVATE_KEY || '';

let vapidReady = false;
let vapidConfigError = '';

function ensureVapidConfigured() {
  if (vapidReady) return;
  if (!publicKey || !privateKey) {
    vapidConfigError = 'VAPID keys are not configured on server';
    return;
  }
  try {
    webpush.setVapidDetails(
      'mailto:developer@example.com',
      publicKey,
      privateKey
    );
    vapidReady = true;
  } catch (error: any) {
    vapidConfigError = `Invalid VAPID config: ${error?.message || 'unknown error'}`;
  }
}

export default async function handler(req: any, res: any) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { title, body, subscriptions } = req.body;

  if (!subscriptions || !Array.isArray(subscriptions)) {
    return res.status(400).json({ error: 'Missing subscriptions array' });
  }

  ensureVapidConfigured();
  if (!vapidReady) {
    return res.status(500).json({
      error: vapidConfigError || 'VAPID configuration error',
    });
  }

  try {
    const results = await Promise.allSettled(
      subscriptions.map(async (sub) => {
        return webpush.sendNotification(
          sub,
          JSON.stringify({ title, body })
        );
      })
    );

    const successes = results.filter(r => r.status === 'fulfilled').length;
    
    const failures = results.length - successes;
    return res.status(200).json({
      ok: true,
      message: `Sent ${successes}/${subscriptions.length} notifications`,
      successes,
      failures,
      results: results.map(r => r.status)
    });
  } catch (error) {
    console.error('Push Error:', error);
    return res.status(500).json({ error: 'Failed to send pushes' });
  }
}
