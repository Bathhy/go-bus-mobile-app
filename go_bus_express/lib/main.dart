import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/core/storage/base_share_preference.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view/dashboard/dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize SharedPreferences
  await BaseSharePreference.init();

  // Setup GetIt dependency injection
  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
<<<<<<< HEAD
<<<<<<< HEAD
      initialRoute: AppRoutes.animation,
=======
      initialRoute: AppRoutes.signIn,
>>>>>>> 4d7444b (update sign in and sign up pages)
=======
      initialRoute: AppRoutes.animation,
>>>>>>> 706acd1 (done)
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
