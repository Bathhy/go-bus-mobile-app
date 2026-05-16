import 'package:go_bus_express/data/wallet/wallet_payment_api.dart';
import 'package:shared_package/network/x_result.dart';

abstract class WalletPaymentRepository {
  Future<XResult<void>> payWithWallet({required int id});
}

class WalletPaymentRepositoryImpl implements WalletPaymentRepository {
  final WalletPaymentApi _api;

  WalletPaymentRepositoryImpl(this._api);

  @override
  Future<XResult<void>> payWithWallet({required int id}) {
    return xResultHandler(() async {
      await _api.payWithWallet(id: id);
    });
  }
}
