import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _isInitialized = true;
    if (kDebugMode) print('✅ Local Notifications initialized');
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('🔔 Notification tapped: ${response.payload}');
    }
    // Handle notification tap - navigate to specific screen
    // You can use Get.toNamed() here based on payload
  }

  Future<void> showPaymentSuccessNotification({
    required int bookingId,
    required double amount,
    String currency = 'USD',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'payment_success',
      'Payment Notifications',
      channelDescription: 'Notifications for successful payments',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      bookingId, // Use bookingId as notification ID
      '🎉 Payment Successful!',
      'Your booking #$bookingId payment of \$${amount.toStringAsFixed(2)} $currency has been confirmed.',
      details,
      payload: 'payment_success:$bookingId',
    );

    if (kDebugMode) {
      print('✅ Payment success notification shown for booking #$bookingId');
    }
  }

  Future<void> showPaymentPendingNotification({
    required int bookingId,
    required double amount,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'payment_pending',
      'Payment Reminders',
      channelDescription: 'Reminders for pending payments',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      bookingId + 10000, // Different ID for pending notifications
      '⏰ Payment Pending',
      'Complete your payment for booking #$bookingId (\$${amount.toStringAsFixed(2)})',
      details,
      payload: 'payment_pending:$bookingId',
    );
  }

  Future<void> showPaymentExpiredNotification({
    required int bookingId,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'payment_expired',
      'Payment Alerts',
      channelDescription: 'Alerts for expired payments',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      bookingId + 20000, // Different ID for expired notifications
      '⏰ Payment Expired',
      'Your payment session for booking #$bookingId has expired. Please try again.',
      details,
      payload: 'payment_expired:$bookingId',
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
