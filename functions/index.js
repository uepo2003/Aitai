/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnLiking = functions.firestore
    .document('users/{userId}')
    .onUpdate(async (change, context) => {
        const beforeData = change.before.data();
        const afterData = change.after.data();
        
        // likingIds フィールドの変更をチェック
        const beforeLikingIds = beforeData.likingIds || [];
        const afterLikingIds = afterData.likingIds || [];
        
        // 新しい likingId を見つける
        const newLikingIds = afterLikingIds.filter(id => !beforeLikingIds.includes(id));
        
        if (newLikingIds.length > 0) {
            // FCM トークンを取得 (この部分は具体的な実装に依存します)
            const userToken = await getUserToken(context.params.userId);
            
            // 通知メッセージを構築
            const message = {
                notification: {
                    title: 'New Liking',
                    body: 'You have a new liking!',
                },
                token: userToken,
            };
            
            // 通知を送信
            return admin.messaging().send(message).then((response) => {
                console.log('Successfully sent message:', response);
                return;
            }).catch((error) => {
                console.log('Error sending message:', error);
            });
        } else {
            return null;
        }
    });

async function getUserToken(userId) {
    // ユーザーの FCM トークンを取得するロジック
    // 例: Firestore からユーザーのトークンを取得
}

