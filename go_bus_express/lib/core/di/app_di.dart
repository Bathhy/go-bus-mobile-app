import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:go_bus_express/core/network/auth_interceptor.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/data/app_api/go_bus_api.dart';
import 'package:go_bus_express/data/auth/auth_api.dart';
import 'package:go_bus_express/data/booking/booking_api.dart';
import 'package:go_bus_express/data/payment/payment_api.dart';
import 'package:go_bus_express/repository/auth_repository.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/repository/hive_manager_repository.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/repository/route_repository.dart';
import 'package:go_bus_express/view_models/controller/auth/AuthController.dart';
import 'package:go_bus_express/view_models/controller/editProfile/edit_profile_controller.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/choose_payment_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/kh_qr/kh_qr_controller.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_controller.dart';
import 'package:go_bus_express/view_models/controller/route/select_route/select_route_controller.dart';
import 'package:go_bus_express/view_models/controller/route/select_seat/select_seat_controller.dart';
import 'package:go_bus_express/view_models/controller/splash/SplashController.dart';

import '../../data/network/dio_service.dart';
import '../../data/network/payment_dio_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<LocalRepository>(() => LocalRepository());

  // Initialize and register HiveManagerRepository
  final hiveManager = HiveManagerRepository();
  await hiveManager.init();
  getIt.registerLazySingleton<HiveManagerRepository>(() => hiveManager);

  // Network - Main API Service
  final dioService = DioService(getIt<LocalRepository>());
  final dio = dioService.dio;
  getIt.registerLazySingleton(() => dio);
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<Dio>()));
  getIt.registerLazySingleton<GoBusApi>(() => GoBusApi(getIt<Dio>()));
  getIt.registerLazySingleton<BookingApi>(() => BookingApi(getIt<Dio>()));

  // Network - Payment API Service
  final paymentDioService = PaymentDioService(getIt());
  final paymentDio = paymentDioService.dio;
  getIt.registerLazySingleton<PaymentBakongApi>(
    () => PaymentBakongApi(paymentDio),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApi>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<GoBusApi>()),
  );
  getIt.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(getIt<GoBusApi>()),
  );
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(getIt(), getIt()),
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
  getIt.registerFactory<HomeController>(() {
    final controller = Get.put(
      HomeController(getIt(), getIt(), getIt(), getIt(), getIt()),
    );
    return controller;
  });
  Get.put(HomeController(getIt(), getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory<ProfileController>(() {
    final controller = Get.put(ProfileController(getIt()));
    return controller;
  });
  getIt.registerFactory<SelectRouteController>(() {
    final controller = SelectRouteController(getIt());
    Get.put(controller);
    return controller;
  });
  getIt.registerFactory<SelectSeatController>(() {
    final controller = SelectSeatController(getIt());
    Get.put(controller);
    return controller;
  });
  getIt.registerFactory<ChoosePaymentController>(() {
    final controller = ChoosePaymentController(getIt(), getIt(), getIt());
    Get.put(controller);
    return controller;
  });
  getIt.registerFactory<KhQrController>(() {
    final controller = KhQrController(getIt(), getIt(), getIt());
    Get.put(controller);
    return controller;
  });

  getIt.registerFactory<EditProfileController>(() {
    final controller = EditProfileController(getIt(), getIt());
    Get.put(controller);
    return controller;
  });
}

void resetSingletonControllers() {
  // Unregister old singletons
  if (getIt.isRegistered<HomeController>()) {
    getIt.unregister<HomeController>();
  }
  if (getIt.isRegistered<ProfileController>()) {
    getIt.unregister<ProfileController>();
  }

  // Re-register fresh singletons
  getIt.registerLazySingleton<HomeController>(() {
    final controller = HomeController(
      getIt<ProfileRepository>(),
      getIt<LocalRepository>(),
      getIt<RouteRepository>(),
      getIt<HiveManagerRepository>(),
      getIt<BookingRepository>(),
    );
    Get.put(controller);
    controller.onInit();
    return controller;
  });

  getIt.registerLazySingleton<ProfileController>(() {
    final controller = ProfileController(getIt<LocalRepository>());
    Get.put(controller);
    controller.onInit();
    controller.onReady();
    return controller;
  });
}
