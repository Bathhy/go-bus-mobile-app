import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/core/utils/date_ext.dart';
import 'package:go_bus_express/core/utils/social_constant.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/repository/hive_manager_repository.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/repository/route_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/home/home_state.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';
import 'package:shared_package/network/x_result.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> fetchProfile() async {
    final result = await _repository.fetchProfile();

    switch (result) {
      case Success<ProfileModel?>():
        updateState((state) => state.copyWith(profileModel: result.data));
        if (result.data != null) {
          final profileJson = jsonEncode(result.data!.toJson());
          await _localRepository.saveProfile(profileJson);
        }
        // Pre-load wallet balance on home screen if session is still valid
        final isWalletExist = result.data?.isWalletExist ?? false;
        if (isWalletExist && _localRepository.isWalletSessionValid()) {
          try {
            await Get.find<WalletController>().fetchWalletMe();
          } catch (e) {
            log('⚠️ Could not pre-load wallet balance: $e');
          }
        }
      case Error<ProfileModel?>():
        if (result.error.statusCode == 403) {
          logout();
        }
        log('Profile error: ${result.error}');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load cache first for instant display
    loadCachedRoutes();
    // Then fetch fresh data in background
    fetchRoutes(forceRefresh: true);
  }

  void loadCachedRoutes() {
    final cachedRoutesJson = _localRepository.getRoutes();
    if (cachedRoutesJson != null && cachedRoutesJson.isNotEmpty) {
      try {
        final List<dynamic> routesData = jsonDecode(cachedRoutesJson);
        final routes = routesData
            .map((json) => AllRouteModel.fromJson(json))
            .toList();
        updateState((state) => state.copyWith(routes: routes));
        print('📦 Loaded ${routes.length} routes from cache');
      } catch (e) {
        print('❌ Error loading cached routes: $e');
      }
    } else {
      print('📦 No cached routes found');
    }
  }

  Future<void> fetchRoutes({bool forceRefresh = false}) async {
    print('🔄 [fetchRoutes] START - forceRefresh: $forceRefresh');
    print('🔄 [fetchRoutes] Current state.routes.length: ${state.routes.length}');
    
    // If routes already exist and not forcing refresh, skip
    if (!forceRefresh && state.routes.isNotEmpty) {
      print('✅ Routes already loaded - SKIPPING API call');
      return;
    }

    print('🔄 Setting isLoadingRoutes = true');
    updateState((state) => state.copyWith(isLoadingRoutes: true));
    
    print('🔄 Calling _routeRepository.fetchRoutes()...');
    final result = await _routeRepository.fetchRoutes();
    print('🔄 Repository returned result type: ${result.runtimeType}');

    switch (result) {
      case Success<List<AllRouteModel>>():
        print('✅ SUCCESS - API returned ${result.data.length} routes');
        print('✅ Routes data: ${result.data.map((r) => r.origin).toList()}');
        
        updateState(
          (state) {
            print('🔍 BEFORE copyWith - state.routes.length: ${state.routes.length}');
            final newState = state.copyWith(isLoadingRoutes: false, routes: result.data);
            print('🔍 AFTER copyWith - newState.routes.length: ${newState.routes.length}');
            return newState;
          },
        );

        print('🔍 AFTER updateState - this.state.routes.length: ${state.routes.length}');
        print('🔍 Routes in state: ${state.routes.map((r) => r.origin).toList()}');

        // Save to cache
        final routesJson = jsonEncode(
          result.data.map((route) => route.toJson()).toList(),
        );
        await _localRepository.saveRoutes(routesJson);

        print('✅ Routes saved to cache successfully');
      case Error<List<AllRouteModel>>():
        print('❌ ERROR - Routes fetch failed: ${result.error}');
        updateState((state) => state.copyWith(isLoadingRoutes: false));
    }
    
    print('🔄 [fetchRoutes] END');
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
    if (state.selectedRouteId == null || state.departureDate == null) {
      log('❌ Missing required search parameters');
      return null;
    }

    // Format date as simple date string (e.g., 2026-04-28)
    // Backend expects LocalDate format: yyyy-MM-dd
    final departureDateStr = state.departureDate!.toLocalDateString();

    final params = {
      'route_id': state.selectedRouteId,
      'departure_date': departureDateStr,
    };

    // Add return_date only if it's provided
    if (state.returnDate != null) {
      params['return_date'] = state.returnDate!.toLocalDateString();
    }

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
        'createdAt': pending.createdAt,
      },
    );
  }

  void cancelPendingPayment(int bookingId) async {
    updateState((state) => state.copyWith(isLoading: true));
    final result = await _bookingRepository.cancelBooking(bookingId: bookingId);

    switch (result) {
      case Success<void>():
        updateState((state) => state.copyWith(isLoading: false));
        await _hiveRepository.clearPendingPayment();
        log('✅ Pending payment canceled');
        break;
      case Error<void>():
        updateState((state) => state.copyWith(isLoading: false));
        log('❌ Failed to cancel pending payment');
        break;
    }
  }

  void openTelegram() async {
    try {
      final Uri uri = Uri.parse(AppConfig.baseTelegramUrl);

      // Check if can launch
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Try web fallback
        final webUri = Uri.parse(AppConfig.baseTelegramUrl);
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        } else {
          log('❌ Could not launch Telegram');
        }
      }
    } catch (e) {
      log('❌ Error opening Telegram: $e');
      // Only show snackbar if context is available
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Could not open Telegram. Please make sure Telegram is installed.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void callPhone() async {
    try {
      final Uri uri = Uri.parse('tel:${AppConfig.basePhNumber}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        log('❌ Could not make phone call');
      }
    } catch (e) {
      log('❌ Error launching phone call: $e');
      // Only show snackbar if context is available
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone call.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> pullRefresh() async {
    await Future.wait([fetchProfile(), fetchRoutes(forceRefresh: true)]);
  }

  void refreshProfile() {
    fetchProfile();
    log('Profile refreshed from cache');
  }
}
