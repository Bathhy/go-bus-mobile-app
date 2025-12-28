import 'package:hive/hive.dart';

part 'pending_payment_model.g.dart';

@HiveType(typeId: 0)
class PendingPaymentModel extends HiveObject {
  @HiveField(0)
  final int bookingId;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String currency;

  @HiveField(3)
  final String qrData;

  @HiveField(4)
  final String md5;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String direction;

  @HiveField(7)
  final List<String> selectedSeats;

  PendingPaymentModel({
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.qrData,
    required this.md5,
    required this.createdAt,
    required this.direction,
    required this.selectedSeats,
  });

  bool isExpired() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inMinutes >= 3; // 3 minutes expiry
  }
}
