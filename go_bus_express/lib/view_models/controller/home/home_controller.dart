import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/repository/hive_manager_repository.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/repository/route_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/home/home_state.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../models/home/all_route_model.dart';
import '../../../models/payment/pending_payment_model.dart';
import '../../../resources/routes/app_routes.dart';

class HomeController extends BaseController<HomeState> {
  final ProfileRepository _repository;
  final LocalRepository _localRepository;
  final RouteRepository _routeRepository;
  final HiveManagerRepository _hiveRepository;
  final BookingRepository _bookingRepository;

  HomeController(
    this._repository,
    this._localRepository,
    this._routeRepository,
    this._hiveRepository,
    this._bookingRepository,
  ) : super(HomeState());

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    loadCachedRoutes();
  }

  Future<void> fetchProfile() async {
    // Set loading
    updateState((state) => state.copyWith(isLoading: true));
    final result = await _repository.fetchProfile();

    switch (result) {
      case Success<ProfileModel?>():
        // Update profile
        updateState(
          (state) =>
              state.copyWith(isLoading: false, profileModel: result.data),
        );

        if (result.data != null) {
          final profileJson = jsonEncode(result.data!.toJson());
          await _localRepository.saveProfile(profileJson);
        }
      case Error<ProfileModel?>():
        // Error
        if (result.error.statusCode == 403) {
          logout();
        }
        updateState((state) => state.copyWith(isLoading: false));
        log('Profile error: ${result.error}');
    }
  }

  void loadCachedRoutes() {
    final cachedRoutesJson = _localRepository.getRoutes();
    if (cachedRoutesJson != null) {
      try {
        final List<dynamic> routesData = jsonDecode(cachedRoutesJson);
        final routes = routesData
            .map((json) => AllRouteModel.fromJson(json))
            .toList();
        updateState((state) => state.copyWith(routes: routes));
        log('📦 Loaded ${routes.length} routes from cache');
      } catch (e) {
        log('❌ Error loading cached routes: $e');
      }
    }
  }

  Future<void> fetchRoutes({bool forceRefresh = false}) async {
    // If routes already exist and not forcing refresh, skip
    if (!forceRefresh && state.routes.isNotEmpty) {
      log('✅ Routes already loaded from cache');
      return;
    }

    updateState((state) => state.copyWith(isLoadingRoutes: true));
    final result = await _routeRepository.fetchRoutes();

    switch (result) {
      case Success<List<AllRouteModel>>():
        updateState(
          (state) =>
              state.copyWith(isLoadingRoutes: false, routes: result.data),
        );

        // Save to cache
        final routesJson = jsonEncode(
          result.data.map((route) => route.toJson()).toList(),
        );
        await _localRepository.saveRoutes(routesJson);

        log('✅ Routes fetched successfully: ${result.data.length} routes');
      // for (var route in result.data) {
      //   log('  📍 Route ${route.id}: ${route.origin} → ${route.destination} (${route.distanceKm}km, ${route.durationMinutes}min)');
      // }
      case Error<List<AllRouteModel>>():
        updateState((state) => state.copyWith(isLoadingRoutes: false));
        log('❌ Routes error: ${result.error}');
    }
  }

  void selectRoute(AllRouteModel route) {
    updateState(
      (state) => state.copyWith(
        selectedRouteId: route.id,
        selectedRouteOrigin: route.origin,
        selectedRouteDestination: route.destination,
      ),
    );
  }

  Map<String, dynamic>? getSearchParams() {
    if (state.selectedRouteId == null ||
        state.departureDate == null ||
        state.returnDate == null) {
      log('❌ Missing required search parameters');
      return null;
    }

    final params = {
      'route_id': state.selectedRouteId,
      'departure_date': state.departureDate!.toIso8601String().split('T')[0],
      'return_date': state.returnDate!.toIso8601String().split('T')[0],
    };

    log('✅ Search params: $params');
    return params;
  }

  void selectCountry(String country) {
    updateState((state) => state.copyWith(selectedCountry: country));
    log('Country selected: $country');
  }

  void selectDepartureDate(DateTime date) {
    updateState((state) => state.copyWith(departureDate: date));
    log('Departure date selected: ${date.toString().split(' ')[0]}');
  }

  void selectReturnDate(DateTime date) {
    updateState((state) => state.copyWith(returnDate: date));
    log('Return date selected: ${date.toString().split(' ')[0]}');
  }

  void logout() {
    _localRepository.logout();
    Get.offAllNamed(AppRoutes.signIn);
  }

  bool hasPendingPayment() {
    return _hiveRepository.hasPendingPayment();
  }

  PendingPaymentModel? getPendingPayment() {
    return _hiveRepository.getPendingPayment();
  }

  void resumePendingPayment(PendingPaymentModel pending) {
    Get.toNamed(
      AppRoutes.makePayment,
      arguments: {
        'qrData': pending.qrData,
        'amount': pending.amount,
        'currency': pending.currency,
        'bookingId': pending.bookingId,
      },
    );
  }

  void cancelPendingPayment(int bookingId) async {
    final result = await _bookingRepository.cancelBooking(bookingId: bookingId);

    switch (result) {
      case Success<void>():
        await _hiveRepository.clearPendingPayment();
        log('✅ Pending payment canceled');
        break;
      case Error<void>():
        log('❌ Failed to cancel pending payment');
        break;
    }
  }
}
