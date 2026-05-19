import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
import 'package:shared_package/network/base_response.dart';

part 'wallet_payment_api.g.dart';

@RestApi()
abstract class WalletPaymentApi {
  factory WalletPaymentApi(Dio dio, {String baseUrl}) = _WalletPaymentApi;

  @POST('/payments/{id}/wallet')
  Future<BaseResponse<void>> payWithWallet({
    @Header('X-Wallet-Session') required String sessionToken,
    @Path('id') required int id,
  });
}
