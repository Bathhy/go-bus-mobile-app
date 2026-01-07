import '../../../../core/base/base_ui_state.dart';

class KhQrState extends BaseUiState {
  final String qrData;
  final String md5;
  final double amount;
  final String currency;
  final String receiverName;
  final int remainingSeconds;
  final bool isExpired;
  final bool isPaid;
  final String? paymentStatus;
  final String? transactionId;
  final int bookingId;
  final DateTime? createdAt;

  KhQrState({
    super.isLoading = false,
    this.qrData = '',
    this.amount = 0.0,
    this.currency = 'USD',
    this.receiverName = 'Go-Bus Express',
    this.remainingSeconds = 180, // 3 minutes
    this.isExpired = false,
    this.isPaid = false,
    this.paymentStatus,
    this.transactionId,
    this.md5 = '',
    this.bookingId = 0,
    this.createdAt,
  });

  KhQrState copyWith({
    bool? isLoading,
    String? qrData,
    double? amount,
    String? currency,
    String? receiverName,
    int? remainingSeconds,
    bool? isExpired,
    bool? isPaid,
    String? paymentStatus,
    String? transactionId,
    String? md5,
    int? bookingId,
    DateTime? createdAt,
  }) {
    return KhQrState(
      isLoading: isLoading ?? this.isLoading,
      qrData: qrData ?? this.qrData,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      receiverName: receiverName ?? this.receiverName,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isExpired: isExpired ?? this.isExpired,
      isPaid: isPaid ?? this.isPaid,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
      md5: md5 ?? this.md5,
      bookingId: bookingId ?? this.bookingId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
