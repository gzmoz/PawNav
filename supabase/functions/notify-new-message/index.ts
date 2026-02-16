import { serve } from "https://deno.land/std/http/server.ts";

serve(async (req) => {
  const payload = await req.json();
  const record = payload.record;

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const serviceKey = Deno.env.get("SERVICE_ROLE_KEY")!;
  const fcmKey = Deno.env.get("FCM_SERVER_KEY")!;

  const chatId = record.chat_id;
  const senderId = record.sender_id;
  const messageText = record.text ?? "New message";

  // Chat'teki iki kullanıcıyı al
  const chatRes = await fetch(
    `${supabaseUrl}/rest/v1/chats?id=eq.${chatId}&select=a_id,b_id`,
    {
      headers: {
        apikey: serviceKey,
        Authorization: `Bearer ${serviceKey}`,
      },
    }
  );

  const chat = (await chatRes.json())[0];
  const receiverId = chat.a_id === senderId ? chat.b_id : chat.a_id;

  // Alıcının FCM token’ı
  const profileRes = await fetch(
    `${supabaseUrl}/rest/v1/profiles?id=eq.${receiverId}&select=fcm_token`,
    {
      headers: {
        apikey: serviceKey,
        Authorization: `Bearer ${serviceKey}`,
      },
    }
  );

  const profile = (await profileRes.json())[0];
  const fcmToken = profile?.fcm_token;

  if (!fcmToken) {
    return new Response("No FCM token", { status: 200 });
  }

  // Firebase push
  await fetch("https://fcm.googleapis.com/fcm/send", {
    method: "POST",
    headers: {
      Authorization: `key=${fcmKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      to: fcmToken,
      notification: {
        title: "New message",
        body: messageText,
      },
      data: {
        type: "chat",
        chat_id: chatId,
      },
    }),
  });

  return new Response("Notification sent", { status: 200 });
});
