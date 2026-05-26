import 'package:dio/dio.dart';
import 'package:go_bus_express/data/wallet/wallet_api.dart';
import 'package:go_bus_express/models/body/wallet_topup_khqr_body.dart';
import 'package:go_bus_express/models/payment/verify_payment_model.dart';
import 'package:go_bus_express/models/wallet/wallet_model.dart';
import 'package:go_bus_express/models/wallet/wallet_pin_body.dart';
import 'package:go_bus_express/models/wallet/wallet_topup_khqr_model.dart';
import 'package:go_bus_express/models/wallet/wallet_transaction_model.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:shared_package/network/x_result.dart';

abstract class WalletRepository {
  Future<XResult<WalletModel?>> createWallet({required String pinCode});
  Future<XResult<WalletModel?>> loginWallet({required String pinCode});
  Future<XResult<WalletModel?>> getWalletMe({required String sessionToken});
  Future<XResult<WalletModel?>> getWalletInfo();
  Future<XResult<WalletTransactionPage?>> getTransactions({
    required String sessionToken,
    int page = 1,
    int size = 15,
  });
  Future<XResult<WalletTopUpKhqrModel?>> generateTopUpKhqr({
    required String sessionToken,
    required double amount,
    required String hash,
  });

  /// [cancelToken] allows the caller to abort the long-poll request
  /// (backend holds connection open ~5 min while polling Bakong).
  /// Pass a [CancelToken] and call [CancelToken.cancel()] to drop the
  /// connection immediately — e.g. when the user navigates away.
  Future<XResult<BaseResponse<VerifyPaymentModel>>> checkTopUpTransaction({
    required String sessionToken,
    required String hash,
    CancelToken? cancelToken,
  });
}

class WalletRepositoryImpl implements WalletRepository {
  final WalletApi _api;

  /// Raw Dio wired to [PaymentDioService] (6-min receiveTimeout).
  /// Used directly — not through Retrofit — so [CancelToken] can be
  /// attached to [checkTopUpTransaction] to kill the long-poll on demand.
  final Dio _paymentDio;

  WalletRepositoryImpl(this._api, this._paymentDio);

  @override
  Future<XResult<WalletModel?>> createWallet({required String pinCode}) {
    return xResultHandler(() async {
      final response = await _api.createWallet(WalletPinBody(pinCode: pinCode));
      return response.data;
    });
  }

  @override
  Future<XResult<WalletModel?>> loginWallet({required String pinCode}) {
    return xResultHandler(() async {
      final response = await _api.loginWallet(WalletPinBody(pinCode: pinCode));
      return response.data;
    });
  }

  @override
  Future<XResult<WalletModel?>> getWalletMe({required String sessionToken}) {
    return xResultHandler(() async {
      final response = await _api.getWalletMe(sessionToken);
      return response.data;
    });
  }

  @override
  Future<XResult<WalletModel?>> getWalletInfo() {
    return xResultHandler(() async {
      final response = await _api.getWalletInfo();
      return response.data;
    });
  }

  @override
  Future<XResult<WalletTransactionPage?>> getTransactions({
    required String sessionToken,
    int page = 1,
    int size = 15,
  }) {
    return xResultHandler(() async {
      // /wallets/me/transactions returns the page object directly —
      // no BaseResponse wrapper — so we return the result as-is.
      return await _api.getTransactions(
        sessionToken,
        page: page,
        size: size,
      );
    });
  }

  @override
  Future<XResult<WalletTopUpKhqrModel?>> generateTopUpKhqr({
    required String sessionToken,
    required double amount,
    required String hash,
  }) {
    return xResultHandler(() async {
      final response = await _api.generateTopUpKhqr(
        sessionToken,
        WalletTopUpKhqrBody(amount: amount, hash: hash),
      );
      return response.data;
    });
  }

  @override
  Future<XResult<BaseResponse<VerifyPaymentModel>>> checkTopUpTransaction({
    required String sessionToken,
    required String hash,
    CancelToken? cancelToken,
  }) {
    return xResultHandler(() async {
      final response = await _paymentDio.post(
        '/topups/bakong/checking-transaction',
        data: {'hash': hash},
        options: Options(headers: {'X-Wallet-Session': sessionToken}),
        cancelToken: cancelToken,
      );
      return BaseResponse<VerifyPaymentModel>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => VerifyPaymentModel.fromJson(json as Map<String, dynamic>),
      );
    });
  }
}
