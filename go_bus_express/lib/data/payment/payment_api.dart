import 'package:dio/dio.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:retrofit/http.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
import '../../models/booking/booking_model.dart';

part 'payment_api.g.dart';

@RestApi()
abstract class PaymentBakongApi {
  factory PaymentBakongApi(Dio dio, {String baseUrl}) = _PaymentBakongApi;

  @POST('/bakong/generateQR')
  Future<GenerateQrModel> generateQr({
    @Body() required PaymentBody body,
  });
}
