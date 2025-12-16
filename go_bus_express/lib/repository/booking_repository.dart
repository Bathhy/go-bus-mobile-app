import 'package:go_bus_express/data/booking/booking_api.dart';
import 'package:go_bus_express/data/payment/payment_api.dart';
import 'package:go_bus_express/models/body/booking_body.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/booking/booking_model.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:shared_package/network/x_result.dart';

abstract class BookingRepository {
  Future<XResult<BookingModel?>> createBooking({required BookingBody body});

  Future<XResult<GenerateQrModel>> generateQr({required PaymentBody body});
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingApi _bookingApi;
  final PaymentBakongApi _paymentApi;

  BookingRepositoryImpl(this._bookingApi, this._paymentApi);

  @override
  Future<XResult<BookingModel?>> createBooking({required BookingBody body}) {
    return xResultHandler(() async {
      final res = await _bookingApi.createBooking(body: body);
      return res.data;
    });
  }

  @override
  Future<XResult<GenerateQrModel>> generateQr({required PaymentBody body}) {
    return xResultHandler(() async {
      final res = await _paymentApi.generateQr(body: body);
      return res;
    });
  }
}
