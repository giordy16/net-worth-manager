import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmNotification {
  static Future<void> registerFCMToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: $token");

    final db = FirebaseFirestore.instance;
    db
        .collection("fcm_tokens")
        .doc(token)
        .set({"lang": Platform.localeName.split('_').first.toLowerCase()});
  }

  static Future<void> deleteFCMToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: $token");

    final db = FirebaseFirestore.instance;
    db
        .collection("fcm_tokens")
        .doc(token).delete();
  }


}
