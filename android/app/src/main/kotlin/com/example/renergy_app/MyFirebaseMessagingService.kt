package com.example.renergy_app

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        Log.d("MyFcmService", "New token: $token")
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d("MyFcmService", "Message received: ${remoteMessage.messageId}")
    }
}