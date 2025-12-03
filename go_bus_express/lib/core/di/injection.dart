import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:go_bus_express/core/network/auth_interceptor.dart';
import 'package:go_bus_express/core/storage/storage_service.dart';
import 'package:go_bus_express/data/auth/auth_api.dart';
import 'package:go_bus_express/repository/auth_repository.dart';
import 'package:go_bus_express/view_models/controller/AuthController.dart';
import 'package:shared_package/network/dio_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<LocalRepository>(() => LocalRepository());

  // NetWork
  final dio = DioService().dio;
  dio.interceptors.add(
    AuthInterceptor(),
  );
  getIt.registerLazySingleton(() => dio);
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApi>()),
  );

  // Controllers - Register with both GetIt and GetX
  getIt.registerLazySingleton<AuthController>(() {
    final controller = AuthController(getIt<AuthRepository>(), getIt());
    Get.put(controller); // Register with GetX for reactive features
    return controller;
  });
}
