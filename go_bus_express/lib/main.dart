import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/core/storage/base_share_preference.dart';
import 'package:go_bus_express/resources/localizations/app_localization.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view/dashboard/dashboard_view.dart';

import 'core/services/notification_service.dart';
import 'core/services/local_notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase only on supported platforms
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Firebase Messaging is only supported on mobile and web
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      // Get FCM token for testing
      final token = await messaging.getToken();
      print('🔑 FCM Token: $token');
      print('📋 Copy this token to test notifications!');
      
      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        print('🔄 Token refreshed: $newToken');
      });
    } else {
      print('⚠️ Firebase Messaging not supported on this platform');
    }
  } catch (e) {
    print('⚠️ Firebase initialization failed: $e');
    print('Running without Firebase support');
  }
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize SharedPreferences
  await BaseSharePreference.init();

  // Initialize Local Notifications
  await LocalNotificationService().initialize();

  // Setup GetIt dependency injection
  await setupDependencyInjection();

  // Load saved language
  await AppLocalization.getLanguage();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Global key for navigator
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupFCMListeners();
  }

  void _setupFCMListeners() {
    // Only setup listeners on supported platforms
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || 
                    defaultTargetPlatform == TargetPlatform.iOS)) {
      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('🔔 Foreground Message Received!');
        print('📬 Title: ${message.notification?.title}');
        print('📝 Body: ${message.notification?.body}');
        print('📦 Data: ${message.data}');
        
        // Show a snackbar or dialog
        if (message.notification != null) {
          _showNotificationDialog(
            message.notification!.title ?? 'Notification',
            message.notification!.body ?? '',
          );
        }
      });

      // When app is opened from terminated state
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print('🚀 App opened from terminated state');
          print('📦 Message data: ${message.data}');
          // Navigate to specific screen based on message.data
        }
      });

      // When app is in background and user taps notification
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('🔔 Notification tapped (from background)');
        print('📦 Message data: ${message.data}');
        // Navigate to specific screen based on message.data
      });
    }
  }

  void _showNotificationDialog(String title, String body) {
    // Use navigator key to get context
    final context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Fallback: just print if context not available
      print('📱 Notification: $title - $body');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      initialRoute: AppRoutes.animation,
      // initialRoute: AppRoutes.ticket,
      translations: AppLocalization(),
      locale: AppLocalization.getInitialLocale(),
      fallbackLocale: const Locale('en'),
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔔 Background Message: ${message.notification?.title}');
  print('📦 Data: ${message.data}');
}