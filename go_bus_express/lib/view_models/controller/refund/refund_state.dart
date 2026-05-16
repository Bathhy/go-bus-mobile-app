import 'package:go_bus_express/models/refund/refund_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class RefundState extends BaseUiState {
  final List<RefundModel> refunds;
  final String? selectedStatus;
  final String? error;

  RefundState({
    this.refunds = const [],
    this.selectedStatus,
    this.error,
    super.isLoading = false,
  });

  RefundState copyWith({
    List<RefundModel>? refunds,
    String? selectedStatus,
    String? error,
    bool? isLoading,
    bool clearError = false,
    bool clearStatus = false,
  }) {
    return RefundState(
      refunds: refunds ?? this.refunds,
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RefundDetailState extends BaseUiState {
  final RefundModel? refund;
  final String? error;

  RefundDetailState({this.refund, this.error, super.isLoading = false});

  RefundDetailState copyWith({
    RefundModel? refund,
    String? error,
    bool? isLoading,
    bool clearError = false,
  }) {
    return RefundDetailState(
      refund: refund ?? this.refund,
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
