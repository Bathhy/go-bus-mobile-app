import 'dart:developer';

import 'package:go_bus_express/models/refund/refund_model.dart';
import 'package:go_bus_express/repository/refund_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/refund/refund_state.dart';
import 'package:shared_package/network/x_result.dart';

class RefundController extends BaseController<RefundState> {
  final RefundRepository _repository;

  RefundController(this._repository) : super(RefundState());

  @override
  void onInit() {
    log('🚀 RefundController onInit');
    fetchRefunds();
    super.onInit();
  }

  Future<void> fetchRefunds({String? status}) async {
    updateState((s) => s.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _repository.getMyRefunds(status: status);
      switch (result) {
        case Success<RefundPage?>():
          final items = result.data?.content ?? [];
          log('✅ Loaded ${items.length} refunds (status=$status)');
          updateState((s) => s.copyWith(
                refunds: items,
                selectedStatus: status,
                isLoading: false,
              ));
          break;
        case Error<RefundPage?>():
          log('❌ Error: ${result.error.displayMessage}');
          updateState((s) => s.copyWith(
                refunds: [],
                isLoading: false,
                error: result.error.displayMessage,
              ));
          break;
      }
    } catch (e) {
      log('💥 Exception: $e');
      updateState((s) => s.copyWith(
            refunds: [],
            isLoading: false,
            error: 'Failed to load refunds',
          ));
    }
  }

  Future<void> filterByStatus(String? status) async {
    await fetchRefunds(status: status);
  }

  Future<bool> requestRefund({
    required int bookingId,
    required String reason,
    required String method,
  }) async {
    try {
      final result = await _repository.requestRefund(
        bookingId: bookingId,
        reason: reason,
        method: method,
      );
      switch (result) {
        case Success<RefundModel?>():
          log('✅ Refund requested for booking $bookingId');
          return true;
        case Error<RefundModel?>():
          log('❌ Refund request failed: ${result.error.displayMessage}');
          return false;
      }
    } catch (e) {
      log('💥 Refund exception: $e');
      return false;
    }
  }
}

class RefundDetailController extends BaseController<RefundDetailState> {
  final RefundRepository _repository;

  RefundDetailController(this._repository) : super(RefundDetailState());

  Future<void> fetchDetail({required int id}) async {
    log('📡 Fetching refund detail id=$id');
    updateState((s) => s.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _repository.getRefundDetail(id: id);
      switch (result) {
        case Success<RefundModel?>():
          updateState((s) => s.copyWith(refund: result.data, isLoading: false));
          break;
        case Error<RefundModel?>():
          updateState((s) => s.copyWith(
                isLoading: false,
                error: result.error.displayMessage,
              ));
          break;
      }
    } catch (e) {
      updateState((s) =>
          s.copyWith(isLoading: false, error: 'Failed to load refund detail'));
    }
  }
}
