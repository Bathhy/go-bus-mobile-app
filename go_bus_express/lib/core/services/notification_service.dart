import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_bus_express/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class FirebaseServiceComet {
  late final FirebaseMessaging _fm;
  late NotificationSettings _settings;

  String? conversationId;

  // Singleton to prevent multiple instances
  static FirebaseServiceComet? _instance;

  factory FirebaseServiceComet() =>
      _instance ??= FirebaseServiceComet._internal();

  FirebaseServiceComet._internal();

  Future<void> init([BuildContext? context]) async {
    try {
      _fm = FirebaseMessaging.instance;

      await requestPermissions();
      await _initializeFCMToken();
      await _setupMessageHandlers(context);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('FirebaseServiceComet.init error: $e\n$st');
      }
    }
  }

  Future<void> _initializeFCMToken() async {
    final token = await _fm.getToken();
    if (kDebugMode) debugPrint("[FCM] Token: $token");

    if (token != null) {
      // Register token with your push notification service
    }

    _fm.onTokenRefresh.listen((token) async {
      if (kDebugMode) debugPrint('[FCM] Token refreshed: $token');
    });
  }

  Future<void> _setupMessageHandlers(BuildContext? context) async {
    // Only handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[FCM] Foreground message: ${message.messageId}');
    });

    // Handle app opened from notification (background to foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      debugPrint('[FCM] App opened from notification: ${message.messageId}');
    });
  }

  Future<void> requestPermissions() async {
    try {
      _settings = await _fm.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint('[FCM] Permissions: ${_settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error requesting permissions: $e');
      rethrow;
    }
  }

  String _randomId() => DateTime.now().microsecondsSinceEpoch.toString();

  // Utility methods
  Future<void> deleteToken() async {
    try {
      await _fm.deleteToken();
      if (kDebugMode) debugPrint('[FCM] Token deleted');
    } catch (e) {
      if (kDebugMode) debugPrint('deleteToken error: $e');
    }
  }

  Future<String?> getCurrentToken() async {
    try {
      return await _fm.getToken();
    } catch (e) {
      if (kDebugMode) debugPrint('getCurrentToken error: $e');
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fm.subscribeToTopic(topic);
      if (kDebugMode) debugPrint('[FCM] Subscribed to topic: $topic');
    } catch (e) {
      if (kDebugMode) debugPrint('Subscribe to topic error: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fm.unsubscribeFromTopic(topic);
      if (kDebugMode) debugPrint('[FCM] Unsubscribed from topic: $topic');
    } catch (e) {
      if (kDebugMode) debugPrint('Unsubscribe from topic error: $e');
    }
  }
}
