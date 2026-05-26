import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';
import 'package:go_bus_express/models/body/wallet_topup_khqr_body.dart';
import 'package:go_bus_express/models/wallet/wallet_model.dart';
import 'package:go_bus_express/models/wallet/wallet_pin_body.dart';
import 'package:go_bus_express/models/wallet/wallet_topup_khqr_model.dart';
import 'package:go_bus_express/models/wallet/wallet_transaction_model.dart';
import 'package:shared_package/network/base_response.dart';

part 'wallet_api.g.dart';

@RestApi()
abstract class WalletApi {
  factory WalletApi(Dio dio, {String baseUrl}) = _WalletApi;

  @POST('/wallets')
  Future<BaseResponse<WalletModel>> createWallet(@Body() WalletPinBody body);

  @POST('/wallets/login')
  Future<BaseResponse<WalletModel>> loginWallet(@Body() WalletPinBody body);

  @GET('/wallets/me')
  Future<BaseResponse<WalletModel>> getWalletMe(
    @Header('X-Wallet-Session') String sessionToken,
  );

  @GET('/wallets/my-balance')
  Future<BaseResponse<WalletModel>> getWalletInfo();

  @GET('/wallets/me/transactions')
  Future<WalletTransactionPage> getTransactions(
    @Header('X-Wallet-Session') String sessionToken, {
    @Query('page') int page = 1,
    @Query('size') int size = 15,
  });

  @POST('/topups/bakong/generate-khqr')
  Future<BaseResponse<WalletTopUpKhqrModel>> generateTopUpKhqr(
    @Header('X-Wallet-Session') String sessionToken,
    @Body() WalletTopUpKhqrBody body,
  );
}
