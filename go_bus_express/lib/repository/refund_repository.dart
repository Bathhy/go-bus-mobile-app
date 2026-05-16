import 'package:go_bus_express/data/refund/refund_api.dart';
import 'package:go_bus_express/models/refund/refund_model.dart';
import 'package:shared_package/network/x_result.dart';

abstract class RefundRepository {
  Future<XResult<RefundPage?>> getMyRefunds({String? status});
  Future<XResult<RefundModel?>> getRefundDetail({required int id});
  Future<XResult<RefundModel?>> requestRefund({required int bookingId, required double amount});
}

class RefundRepositoryImpl implements RefundRepository {
  final RefundApi _api;

  RefundRepositoryImpl(this._api);

  @override
  Future<XResult<RefundPage?>> getMyRefunds({String? status}) {
    return xResultHandler(() async {
      final res = await _api.getMyRefunds(status: status, page: 0, size: 20);
      return res.data;
    });
  }

  @override
  Future<XResult<RefundModel?>> getRefundDetail({required int id}) {
    return xResultHandler(() async {
      final res = await _api.getRefundDetail(id: id);
      return res.data;
    });
  }

  @override
  Future<XResult<RefundModel?>> requestRefund({required int bookingId, required double amount}) {
    return xResultHandler(() async {
      final res = await _api.requestRefund(
        bookingId: bookingId,
        body: {'amount': amount},
      );
      return res.data;
    });
  }
}
