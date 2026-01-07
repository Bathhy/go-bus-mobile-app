import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/payment/pending_payment_model.dart';

class HiveManagerRepository {
  static const String _pendingPaymentBox = 'pending_payment';
  static const String _pendingPaymentKey = 'current_payment';

  Box<PendingPaymentModel>? _box;

  Future<void> init() async {
    try {
      _box = await Hive.openBox<PendingPaymentModel>(_pendingPaymentBox);
      log('✅ Hive PendingPayment box opened');
    } catch (e) {
      log('❌ Error opening Hive box: $e');
    }
  }

  Future<void> savePendingPayment(PendingPaymentModel payment) async {
    try {
      await _box?.put(_pendingPaymentKey, payment);
      log('✅ Pending payment saved: BookingID ${payment.bookingId}');
    } catch (e) {
      log('❌ Error saving pending payment: $e');
    }
  }

  PendingPaymentModel? getPendingPayment() {
    try {
      final payment = _box?.get(_pendingPaymentKey);
      if (payment != null) {
        log('✅ Pending payment found: BookingID ${payment.bookingId}');
      }
      return payment;
    } catch (e) {
      log('❌ Error getting pending payment: $e');
      return null;
    }
  }

  Future<void> clearPendingPayment() async {
    try {
      await _box?.delete(_pendingPaymentKey);
      log('✅ Pending payment cleared');
    } catch (e) {
      log('❌ Error clearing pending payment: $e');
    }
  }

  bool hasPendingPayment() {
    final payment = getPendingPayment();
    if (payment == null) return false;
    return true;
  }

  Future<void> close() async {
    await _box?.close();
  }
}
