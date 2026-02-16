import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { create, getNumericDate } from "https://deno.land/x/djwt@v2.9/mod.ts";

serve(async (req) => {
  try {
    console.log("send_chat_push invoked");

    const { chat_id, sender_id, text } = await req.json();
    if (!chat_id || !sender_id) {
      return new Response("Invalid payload", { status: 400 });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    //  DIRECT JSON SECRET (NO BASE64, NO IMPORTKEY)
    const serviceAccount = JSON.parse(
      Deno.env.get("FCM_SERVICE_ACCOUNT")!
    );

    const jwt = await create(
      { alg: "RS256", typ: "JWT" },
      {
        iss: serviceAccount.client_email,
        scope: "https://www.googleapis.com/auth/firebase.messaging",
        aud: "https://oauth2.googleapis.com/token",
        iat: getNumericDate(0),
        exp: getNumericDate(60 * 60),
      },
      serviceAccount.private_key   //  PEM STRING DIRECT
    );

    const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
        assertion: jwt,
      }),
    });

    const tokenJson = await tokenRes.json();
    if (!tokenRes.ok) {
      console.error("OAuth error:", tokenJson);
      return new Response("OAuth error", { status: 500 });
    }

    const access_token = tokenJson.access_token;

    // Get chat participants
    const chat = (await fetch(
      `${supabaseUrl}/rest/v1/chats?id=eq.${chat_id}&select=a_id,b_id`,
      {
        headers: {
          apikey: serviceRoleKey,
          Authorization: `Bearer ${serviceRoleKey}`,
        },
      }
    ).then(r => r.json()))[0];

    const receiverId =
      chat.a_id === sender_id ? chat.b_id : chat.a_id;

    if (receiverId === sender_id)
      return new Response("skip self");

    // Get FCM token
    const fcmToken = (await fetch(
      `${supabaseUrl}/rest/v1/profiles?id=eq.${receiverId}&select=fcm_token`,
      {
        headers: {
          apikey: serviceRoleKey,
          Authorization: `Bearer ${serviceRoleKey}`,
        },
      }
    ).then(r => r.json()))[0]?.fcm_token;

    if (!fcmToken)
      return new Response("No FCM token");

    // Send push
    const pushRes = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${access_token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          message: {
            token: fcmToken,
            notification: {
              title: "New message",
              body: text ?? "New message",
            },
          },
        }),
      }
    );

    console.log("FCM response:", await pushRes.text());
    return new Response("OK");

  } catch (e) {
    console.error("FINAL ERROR:", e);
    return new Response("Internal error", { status: 500 });
  }
});
