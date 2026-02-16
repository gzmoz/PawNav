const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatPush = functions.https.onCall(async (request) => {
  const { fcmToken, text } = request.data;

  if (!fcmToken) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "No FCM token provided"
    );
  }

  const message = {
    token: fcmToken,
    notification: {
      title: "New message",
      body: text || "New message",
    },
    data: {
      type: "chat",
    },
  };

  await admin.messaging().send(message);

  return { success: true };
});
