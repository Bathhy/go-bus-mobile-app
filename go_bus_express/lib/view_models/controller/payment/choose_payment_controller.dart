import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/body/booking_body.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/booking/booking_model.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:go_bus_express/repository/booking_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/payment/choose_payment_state.dart';
import 'package:intl/intl.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../resources/routes/app_routes.dart';

class ChoosePaymentController extends BaseController<ChoosePaymentState> {
  ChoosePaymentController(this._bookingRepository, this._localRepository)
    : super(ChoosePaymentState());

  final BookingRepository _bookingRepository;
  final LocalRepository _localRepository;

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
    final selectedSeatIds =
        (args['selectedSeatIds'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList() ??
        [];
    final unitPrice = (args['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final discount = (args['discount'] as num?)?.toDouble() ?? 0.0;
    final scheduleId = args['scheduleId'] as int?;

    // Format direction
    final direction = '$origin - $destination';

    updateState(
      (state) => state.copyWith(
        direction: direction,
        departureDate: departureDate,
        departureTime: departureTime,
        selectedSeats: selectedSeats,
        selectedSeatIds: selectedSeatIds,
        unitPrice: unitPrice,
        discount: discount,
        scheduleId: scheduleId,
      ),
    );

    log(
      '✅ Payment initialized: $direction, Seats: ${selectedSeats.join(", ")}, IDs: $selectedSeatIds, Total: \$${state.totalPrice}',
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

  void createBooking() async {
    final body = BookingBody(
      passengerNumber: "123123",
      scheduleId: state.scheduleId,
      seatIds: state.selectedSeatIds,
    );

    log('Creating booking with seat IDs: ${state.selectedSeatIds}');
    log('Booking body: ${body.toJson()}');

    final result = await _bookingRepository.createBooking(body: body);

    switch (result) {
      case Success<BookingModel?>():
        log('✅ Booking created successfully');
        final bookingId = result.data?.id;
        log('✅ Booking ID ${bookingId}');
        if (bookingId != null) {
          log('✅ Booking created successfully ${bookingId}');
          _generateQr(state.totalPrice, bookingId);
        }
        break;

      case Error<BookingModel?>():
        _showError(result.error.displayMessage);
        break;
    }
  }

  void _generateQr(double amount, int bookingId) async {
    final body = PaymentBody(amount: 0.01, currency: "USD");
    final result = await _bookingRepository.generateQr(body: body);

    switch (result) {
      case Success<GenerateQrModel>():
        {
          _localRepository.saveMD5(result.data.md5 ?? '');
          log('✅ QR generated successfully');
          Get.toNamed(
            AppRoutes.makePayment,
            arguments: {
              'qrData': result.data.qr ?? '',
              // 'amount': amount,
              'amount': 0.01,
              'currency': 'USD',
              'bookingId': bookingId,
            },
          );
        }
      case Error<GenerateQrModel>():
        log('❌ QR generation error: ${result.error.displayMessage}');
        _showError(result.error.displayMessage);
        break;
    }
  }

  void _showError(String message) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();

    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        titleText: Text(
          'Error'.tr,
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(message, style: TextStyle(color: white)),
      ),
    );
  }
}
