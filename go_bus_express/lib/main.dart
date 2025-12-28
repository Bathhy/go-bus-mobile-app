import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/core/storage/base_share_preference.dart';
import 'package:go_bus_express/resources/localizations/app_localization.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_bus_express/models/payment/pending_payment_model.dart';

import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/local_notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PendingPaymentModelAdapter());

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
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

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Initialize Firebase Messaging Service
    await FirebaseServiceComet().init(context);

    // Initialize Connectivity Service for real-time monitoring
    Get.put(ConnectivityService());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      initialRoute: AppRoutes.animation,
      translations: AppLocalization(),
      locale: AppLocalization.getInitialLocale(),
      fallbackLocale: const Locale('en'),
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
