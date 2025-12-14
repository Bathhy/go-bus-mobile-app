import 'dart:developer';
import 'package:get/get.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/choose_payment_state.dart';
import 'package:intl/intl.dart';

class ChoosePaymentController extends BaseController<ChoosePaymentState> {
  ChoosePaymentController() : super(ChoosePaymentState());

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      log('❌ No arguments passed to ChoosePaymentController');
      return;
    }

    // Extract data from arguments
    final origin = args['origin'] as String? ?? '';
    final destination = args['destination'] as String? ?? '';
    final departureDate = args['departureDate'] as String?;
    final departureTime = args['departureTime'] as String? ?? '';
    final selectedSeats = args['selectedSeats'] as List<String>? ?? [];
    final unitPrice = (args['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final discount = (args['discount'] as num?)?.toDouble() ?? 0.0;

    // Format direction
      final direction = '$origin - $destination';

    updateState(
      (state) => state.copyWith(
        direction: direction,
        departureDate: departureDate,
        departureTime: departureTime,
        selectedSeats: selectedSeats,
        unitPrice: unitPrice,
        discount: discount,
      ),
    );

    log(
      '✅ Payment initialized: $direction, Seats: ${selectedSeats.length}, Total: \$${state.totalPrice}',
    );
  }

  void selectPaymentMethod(String method) {
    updateState((state) => state.copyWith(selectedPaymentMethod: method));
  }

  void toggleTermsAgreement() {
    updateState((state) => state.copyWith(agreedToTerms: !state.agreedToTerms));
  }

  void updateNote(String note) {
    updateState((state) => state.copyWith(note: note));
  }

  bool canProceedToPayment() {
    return state.agreedToTerms &&
        state.selectedPaymentMethod != null &&
        state.selectedSeats.isNotEmpty;
  }
}
