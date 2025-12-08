import 'package:get/get.dart';
import 'package:go_bus_express/view/auth/sign_in_view.dart';
import 'package:go_bus_express/view/auth/sign_up_view.dart';
import 'package:go_bus_express/view/booking/booking_history_view.dart';
import 'package:go_bus_express/view/dashboard/dashboard_view.dart';
import 'package:go_bus_express/view/splash/splash_view.dart';
import 'package:go_bus_express/view/edit_profile/edit_profile_view.dart';
import 'package:go_bus_express/view/ticket/choose_payment/choose_payment_view.dart';
import 'package:go_bus_express/view/ticket/khqr_payment/khqr_payment_view.dart';
import 'package:go_bus_express/view/ticket/select_route/select_route_view.dart';
import 'package:go_bus_express/view/ticket/select_seat/select_seat_view.dart';

class AppRoutes {
  static const String selectSeat = "/selectSeat";
  static const String selectRoute = "/selectRoute";
  static const String choosePayment = "/choosePayment";
  static const String makePayment = "/makePayment";
  static const String mainNavigation = "/mainNavigation";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String bookingHistory = "/bookingHistory";
  static const String animation = '/animation';
  static const String editProfile = "/editProfile";
  // static void goToDetailCategoryRoute(
  //         int? categoryId, String? uniName, String? uniDescription) =>
  //     Get.toNamed(arguments: {
  //       "categoryId": categoryId,m
  //       "uniname": uniName,
  //       "unidescription": uniDescription
  //     }, detailtopmajorroute);

  static final routes = [
    GetPage(name: choosePayment, page: () => const ChoosePaymentView()),
    GetPage(name: selectRoute, page: () => const SelectRouteView()),
    GetPage(name: selectSeat, page: () => const SelectSeatView()),
    GetPage(name: makePayment, page: () => const KHQRPaymentView()),
    GetPage(name: mainNavigation, page: () => const MainNavigation()),
    GetPage(name: signIn, page: () => const SignInView()),
    GetPage(name: signUp, page: () => const SignUpView()),
    GetPage(name: bookingHistory, page: () => const BookingHistoryView()),
    GetPage(name: animation, page: () => SplashView()),
    GetPage(name: editProfile, page: () => const EditProfileView()),
  ];
}
