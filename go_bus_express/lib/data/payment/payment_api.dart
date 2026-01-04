import 'package:dio/dio.dart';
import 'package:go_bus_express/models/body/payment_body.dart';
import 'package:go_bus_express/models/body/verify_payment_body.dart';
import 'package:go_bus_express/models/payment/generate_qr_model.dart';
import 'package:go_bus_express/models/payment/verify_payment_model.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
part 'payment_api.g.dart';

@RestApi()
abstract class PaymentBakongApi {
  factory PaymentBakongApi(Dio dio, {String baseUrl}) = _PaymentBakongApi;

  @POST('/bakong/generateQR')
  Future<GenerateQrModel> generateQr({@Body() required PaymentBody body});

  @POST('/bakong/verifyMD5')
  Future<VerifyPaymentModel> verifyMd5({@Body() required VerifyPaymentBody body});
}
