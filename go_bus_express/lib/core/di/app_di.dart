import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:go_bus_express/core/network/auth_interceptor.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/data/app_api/go_bus_api.dart';
import 'package:go_bus_express/data/auth/auth_api.dart';
import 'package:go_bus_express/repository/auth_repository.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view_models/controller/auth/AuthController.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:go_bus_express/view_models/controller/splash/SplashController.dart';
import 'package:shared_package/network/dio_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<LocalRepository>(() => LocalRepository());

  // NetWork
  final dio = DioService().dio;
  dio.interceptors.add(AuthInterceptor());
  getIt.registerLazySingleton(() => dio);
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<Dio>()));
  getIt.registerLazySingleton<GoBusApi>(() => GoBusApi(getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApi>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<GoBusApi>()),
  );

  // Controller
  getIt.registerFactory<SplashController>(() {
    final controller = SplashController(getIt());
    Get.put(controller);
    return controller;
  });
  getIt.registerFactory<AuthController>(() {
    final controller = AuthController(getIt<AuthRepository>(), getIt());
    Get.put(controller);
    return controller;
  });
  getIt.registerLazySingleton<HomeController>(() {
    final controller = HomeController(getIt<ProfileRepository>());
    Get.put(controller);
    return controller;
  });
}
