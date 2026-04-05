import 'package:dio/dio.dart';
import 'package:go_bus_express/models/body/booking_body.dart';
import 'package:go_bus_express/models/booking/booking_model.dart';
import 'package:retrofit/http.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';

part 'booking_api.g.dart';

@RestApi()
abstract class BookingApi {
  factory BookingApi(Dio dio, {String baseUrl}) = _BookingApi;

  @POST('/bookings')
  Future<BaseResponse<BookingModel>> createBooking({
    @Body() required BookingBody body,
  });

  @PATCH('/bookings/{id}/cancel')
  Future<BaseResponse<void>> cancelBooking({
    @Path('id') required int id,
  });
}
