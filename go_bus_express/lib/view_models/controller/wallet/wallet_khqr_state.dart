import 'package:go_bus_express/core/base/base_ui_state.dart';

class WalletKhQrState extends BaseUiState {
  final String qrData;
  final String md5;
  final double amount;
  final bool isGenerating;
  final bool isPaid;

  const WalletKhQrState({
    super.isLoading = false,
    this.qrData = '',
    this.md5 = '',
    this.amount = 0.0,
    this.isGenerating = false,
    this.isPaid = false,
  });

  WalletKhQrState copyWith({
    bool? isLoading,
    String? qrData,
    String? md5,
    double? amount,
    bool? isGenerating,
    bool? isPaid,
  }) {
    return WalletKhQrState(
      isLoading: isLoading ?? this.isLoading,
      qrData: qrData ?? this.qrData,
      md5: md5 ?? this.md5,
      amount: amount ?? this.amount,
      isGenerating: isGenerating ?? this.isGenerating,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
