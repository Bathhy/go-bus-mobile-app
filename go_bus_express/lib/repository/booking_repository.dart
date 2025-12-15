import 'package:go_bus_express/data/booking/booking_api.dart';
import 'package:go_bus_express/models/body/booking_body.dart';
import 'package:go_bus_express/models/booking/booking_model.dart';
import 'package:shared_package/network/x_result.dart';

abstract class BookingRepository {
  Future<XResult<BookingModel?>> createBooking({required BookingBody body});
}

class BookingRepositoryImpl implements BookingRepository {
  final BookingApi _bookingApi;

  BookingRepositoryImpl(this._bookingApi);

  @override
  Future<XResult<BookingModel?>> createBooking({required BookingBody body}) {
    return xResultHandler(() async {
      final res = await _bookingApi.createBooking(body: body);
      return res.data;
    });
  }
}
