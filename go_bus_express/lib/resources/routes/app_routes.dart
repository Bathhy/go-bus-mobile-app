import 'package:get/get.dart';
import 'package:go_bus_express/view/ticket/choose_payment/choose_payment_view.dart';
import 'package:go_bus_express/view/ticket/khqr_payment/khqr_payment_view.dart';
import 'package:go_bus_express/view/ticket/select_route/select_route_view.dart';
import 'package:go_bus_express/view/ticket/select_seat/select_seat_view.dart';

class AppRoutes {
  static const String selectSeat = "/selectSeat";
  static const String selectRoute = "/selectRoute";
  static const String choosePayment = "/choosePayment";
  static const String makePayment = "/makePayment";

  // static void goToDetailCategoryRoute(
  //         int? categoryId, String? uniName, String? uniDescription) =>
  //     Get.toNamed(arguments: {
  //       "categoryId": categoryId,
  //       "uniname": uniName,
  //       "unidescription": uniDescription
  //     }, detailtopmajorroute);

  static final routes = [
    GetPage(name: choosePayment, page: () => const ChoosePaymentView()),
    GetPage(name: selectRoute, page: () => const SelectRouteView()),
    GetPage(name: selectSeat, page: () => const SelectSeatView()),
    GetPage(name: makePayment, page: () => const KHQRPaymentView()),
  ];
}
