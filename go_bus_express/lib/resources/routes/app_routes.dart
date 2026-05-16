import 'package:get/get.dart';
import 'package:go_bus_express/view/auth/sign_in_view.dart';
import 'package:go_bus_express/view/auth/sign_up_view.dart';
import 'package:go_bus_express/view/booking/booking_history_view.dart';
import 'package:go_bus_express/view/dashboard/dashboard_view.dart';
import 'package:go_bus_express/view/dashboard/my_ticket/my_ticket_view.dart';
import 'package:go_bus_express/view/dashboard/my_ticket/ticket_detail_view.dart';
import 'package:go_bus_express/view/splash/splash_view.dart';
import 'package:go_bus_express/view/edit_profile/edit_profile_view.dart';
import 'package:go_bus_express/view/ticket/choose_payment/choose_payment_view.dart';
import 'package:go_bus_express/view/ticket/khqr_payment/khqr_payment_view.dart';
import 'package:go_bus_express/view/ticket/payment_success/payment_success_view.dart';
import 'package:go_bus_express/view/ticket/select_route/select_route_view.dart';
import 'package:go_bus_express/view/ticket/select_seat/select_seat_view.dart';
import 'package:go_bus_express/view/wallet/payment_wallet_selection.dart';
import 'package:go_bus_express/view/wallet/pin/confirm_pin_view.dart';
import 'package:go_bus_express/view/wallet/pin/create_pin_view.dart';
import 'package:go_bus_express/view/wallet/pin/enter_pin_view.dart';
import 'package:go_bus_express/view/wallet/wallet_view.dart';
import 'package:go_bus_express/view/wallet/khqr/wallet_khqr_view.dart';
import 'package:go_bus_express/view/refund/my_refund_view.dart';
import 'package:go_bus_express/view/refund/refund_detail_view.dart';
import 'package:go_bus_express/view/wallet/top_up_wallet_view.dart';
import 'package:go_bus_express/view/wallet/withdraw_wallet_view.dart';

class AppRoutes {
  static const String selectSeat = "/selectSeat";
  static const String selectRoute = "/selectRoute";
  static const String choosePayment = "/choosePayment";
  static const String makePayment = "/makePayment";
  static const String paymentSuccess = "/paymentSuccess";
  static const String mainNavigation = "/mainNavigation";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String bookingHistory = "/bookingHistory";
  static const String animation = '/animation';
  static const String editProfile = "/editProfile";
  static const String ticket = "/ticket";
  static const String detailTicket = "/detailTicket";
  static const String wallet = "/wallet";
  static const String walletCreatePin = "/wallet/create-pin";
  static const String walletConfirmPin = "/wallet/confirm-pin";
  static const String walletEnterPin = "/wallet/enter-pin";
  static const String topUpWallet = "/top-up-wallet";
  static const String paymentWalletSelection = "/payment-wallet-selection";
  static const String withdrawWallet = "/withdraw-wallet";
  static const String walletTopUpKhqr = "/wallet/top-up/khqr";
  static const String myRefund = "/my-refund";
  static const String refundDetail = "/refund-detail";

  static void goToSeatRoute(int? scheduleId, int? busId) => Get.toNamed(
    arguments: {"scheduleId": scheduleId, "busId": busId},
    selectSeat,
  );

  static void goToEditProfile(String? fullName, String? email, String? phone) =>
      Get.toNamed(
        arguments: {"fullName": fullName, "email": email, "phone": phone},
        editProfile,
      );

  static void goToTicketDetail({
    required int ticketId,
    String? passengerName,
    String? email,
  }) => Get.toNamed(
    detailTicket,
    arguments: {
      "ticketId": ticketId,
      "passengerName": passengerName,
      "email": email,
    },
  );

  static final routes = [
    GetPage(name: choosePayment, page: () => const ChoosePaymentView()),
    GetPage(name: selectRoute, page: () => const SelectRouteView()),
    GetPage(name: selectSeat, page: () => const SelectSeatView()),
    GetPage(name: makePayment, page: () => const KHQRPaymentView()),
    GetPage(
      transition: Transition.rightToLeftWithFade,
      name: paymentSuccess,
      page: () => const PaymentSuccessView(),
    ),
    GetPage(name: mainNavigation, page: () => MainNavigation()),
    GetPage(name: signIn, page: () => const SignInView()),
    GetPage(name: signUp, page: () => const SignUpView()),
    GetPage(name: bookingHistory, page: () => const BookingHistoryView()),
    GetPage(name: animation, page: () => SplashView()),
    GetPage(name: editProfile, page: () => const EditProfileView()),
    GetPage(name: animation, page: () => SplashView()),
    GetPage(name: ticket, page: () => const MyTicketView()),
    GetPage(name: detailTicket, page: () => const TicketDetailView()),
    GetPage(name: wallet, page: () => const WalletView()),
    GetPage(name: walletCreatePin, page: () => const CreatePinView()),
    GetPage(name: walletConfirmPin, page: () => const ConfirmPinView()),
    GetPage(name: walletEnterPin, page: () => const EnterPinView()),
    GetPage(name: topUpWallet, page: () => const TopUpWalletView()),
    GetPage(
      name: paymentWalletSelection,
      page: () => const PaymentWalletSelectionView(),
    ),
    GetPage(name: withdrawWallet, page: () => const WithdrawWalletView()),
    GetPage(name: walletTopUpKhqr, page: () => const WalletKhQrView()),
    GetPage(name: myRefund, page: () => const MyRefundView()),
    GetPage(name: refundDetail, page: () => const RefundDetailView()),
  ];
}
