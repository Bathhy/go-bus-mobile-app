import 'package:go_bus_express/data/wallet/wallet_payment_api.dart';
import 'package:go_bus_express/models/body/wallet_pay_body.dart';
import 'package:shared_package/network/x_result.dart';

abstract class WalletPaymentRepository {
  Future<XResult<void>> payWithWallet({
    required String sessionToken,
    required int id,
    String? description,
  });
}

class WalletPaymentRepositoryImpl implements WalletPaymentRepository {
  final WalletPaymentApi _api;

  WalletPaymentRepositoryImpl(this._api);

  @override
  Future<XResult<void>> payWithWallet({
    required String sessionToken,
    required int id,
    String? description,
  }) {
    return xResultHandler(() async {
      await _api.payWithWallet(
        sessionToken: sessionToken,
        id: id,
        body: WalletPayBody(description: description),
      );
    });
  }
}
