import 'package:go_bus_express/data/wallet/wallet_api.dart';
import 'package:go_bus_express/models/body/verify_payment_body.dart';
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
  });
  Future<XResult<BaseResponse<VerifyPaymentModel>>> checkTopUpTransaction({
    required String sessionToken,
    required String md5,
  });
}

class WalletRepositoryImpl implements WalletRepository {
  final WalletApi _api;

  WalletRepositoryImpl(this._api);

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
      final response = await _api.getTransactions(
        sessionToken,
        page: page,
        size: size,
      );
      return response.data;
    });
  }

  @override
  Future<XResult<WalletTopUpKhqrModel?>> generateTopUpKhqr({
    required String sessionToken,
    required double amount,
  }) {
    return xResultHandler(() async {
      final response = await _api.generateTopUpKhqr(sessionToken, {
        'amount': amount,
      });
      return response.data;
    });
  }

  @override
  Future<XResult<BaseResponse<VerifyPaymentModel>>> checkTopUpTransaction({
    required String sessionToken,
    required String md5,
  }) {
    return xResultHandler(() async {
      return await _api.checkTopUpTransaction(
        sessionToken,
        VerifyPaymentBody(md5: md5),
      );
    });
  }
}
