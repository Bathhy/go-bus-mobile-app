import 'package:go_bus_express/data/booking/booking_api.dart';
import 'package:go_bus_express/data/payment/payment_api.dart';
import 'package:go_bus_express/models/body/booking_body.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/body/verify_payment_body.dart';
import 'package:go_bus_express/models/booking/booking_model.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:go_bus_express/models/payment/verify_payment_model.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:shared_package/network/x_result.dart';

abstract class BookingRepository {
  Future<XResult<BookingModel?>> createBooking({required BookingBody body});

  Future<XResult<BaseResponse<GenerateQrModel>>> generateQr({
    required PaymentBody body,
  });

  Future<XResult<BaseResponse<VerifyPaymentModel>>> verifyMd5({
    required VerifyPaymentBody body,
    required String bookingId,
  });

  Future<XResult<void>> cancelBooking({required int bookingId});
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingApi _bookingApi;
  final PaymentBakongApi _paymentApi;

  BookingRepositoryImpl(this._bookingApi, this._paymentApi);

  @override
  Future<XResult<BookingModel?>> createBooking({required BookingBody body}) {
    return xResultHandler(() async {
      final res = await _bookingApi.createBooking(body: body);
      // If the response has a nested booking, return it; otherwise return data directly
      return res.data?.booking ?? res.data;
    });
  }

  @override
  Future<XResult<BaseResponse<GenerateQrModel>>> generateQr({
    required PaymentBody body,
  }) {
    return xResultHandler(() async {
      try {
        final res = await _paymentApi
            .generateQr(body: body)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                throw Exception(
                  'QR generation request timed out after 30 seconds',
                );
              },
            );
        return res;
      } catch (e) {
        print('❌ Error in generateQr repository: $e');
        rethrow;
      }
    });
  }

  @override
  Future<XResult<BaseResponse<VerifyPaymentModel>>> verifyMd5({
    required VerifyPaymentBody body,
    required String bookingId,
  }) {
    return xResultHandler(() async {
      final res = await _paymentApi.verifyMd5(body: body, bookingId: bookingId);
      return res;
    });
  }

  @override
  Future<XResult<void>> cancelBooking({required int bookingId}) {
    return xResultHandler(() async {
      final res = await _bookingApi.cancelBooking(id: bookingId);
      return res.data;
    });
  }
}
