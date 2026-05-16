import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/refund/refund_model.dart';
import 'package:go_bus_express/view_models/controller/refund/refund_controller.dart';
import 'package:shared_package/config/themes.dart';

class RefundDetailView extends StatefulWidget {
  const RefundDetailView({super.key});

  @override
  State<RefundDetailView> createState() => _RefundDetailViewState();
}

class _RefundDetailViewState extends State<RefundDetailView> {
  late final RefundDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(getIt<RefundDetailController>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      final id = args?['refundId'] as int?;
      if (id != null) _controller.fetchDetail(id: id);
    });
  }

  @override
  void dispose() {
    if (Get.isRegistered<RefundDetailController>()) {
      Get.delete<RefundDetailController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: GetBuilder<RefundDetailController>(
        init: _controller,
        builder: (controller) {
          if (controller.state.isLoading) return _buildLoading();
          if (controller.state.error != null &&
              controller.state.refund == null) {
            return _buildError(controller.state.error!);
          }

          final refund = controller.state.refund;
          if (refund == null) return _buildLoading();

          return Column(
            children: [
              _buildHeader(refund),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Column(
                    children: [
                      _buildStatusCard(refund),
                      _buildRouteCard(refund),
                      _buildBookingCard(refund),
                      _buildSeatsCard(refund),
                      if (refund.adminNote != null &&
                          refund.adminNote!.isNotEmpty)
                        _buildAdminNoteCard(refund.adminNote!),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(RefundModel refund) {
    final origin = refund.route?.origin ?? 'N/A';
    final destination = refund.route?.destination ?? 'N/A';
    final createdAt = refund.createdAt;
    final dateStr = createdAt != null
        ? '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}'
        : 'N/A';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [goBusPrimary, goBusPrimary.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'refund_details'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '${'refund'.tr} #${refund.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      origin,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      destination,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${'requested'.tr} • $dateStr',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(RefundModel refund) {
    final status = refund.status ?? '';
    final colors = _statusColors(status);
    final label = _formatStatus(status);
    final amount = refund.amount ?? 0.0;
    final processedAt = refund.processedAt;
    final processedStr = processedAt != null
        ? '${processedAt.day}/${processedAt.month}/${processedAt.year}'
        : null;

    return _card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.$1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_statusIcon(status), color: colors.$2, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.$2,
                      ),
                    ),
                    if (processedStr != null)
                      Text(
                        '${'processed_on'.tr} $processedStr',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'amount'.tr,
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: goBusPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (refund.reason != null && refund.reason!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'reason'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    refund.reason!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteCard(RefundModel refund) {
    final schedule = refund.schedule;
    final bus = schedule?.bus;
    final dep = schedule?.departureDateTime;
    final arr = schedule?.arrivalDateTime;

    final depTime = dep != null
        ? '${dep.hour.toString().padLeft(2, '0')}:${dep.minute.toString().padLeft(2, '0')}'
        : 'N/A';
    final arrTime = arr != null
        ? '${arr.hour.toString().padLeft(2, '0')}:${arr.minute.toString().padLeft(2, '0')}'
        : 'N/A';
    final travelDate = dep != null
        ? '${dep.day}/${dep.month}/${dep.year}'
        : 'N/A';

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.directions_bus, 'trip_details'.tr),
          const SizedBox(height: 16),
          if (bus != null)
            Row(
              children: [
                Icon(
                  Icons.airport_shuttle_outlined,
                  color: goBusPrimary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${bus.busType ?? ''} • ${bus.busNumber ?? ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  travelDate,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      depTime,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      refund.route?.origin ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'departure'.tr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: goBusPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 28,
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: goBusPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      arrTime,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      refund.route?.destination ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'arrival'.tr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(RefundModel refund) {
    final booking = refund.booking;
    if (booking == null) return const SizedBox.shrink();

    final bookingStatus = _formatStatus(booking.bookingStatus ?? '');
    final bookingCreated = booking.createdAt;
    final createdStr = bookingCreated != null
        ? '${bookingCreated.day}/${bookingCreated.month}/${bookingCreated.year}'
        : 'N/A';

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.receipt_outlined, 'booking_info'.tr),
          const SizedBox(height: 16),
          _infoRow('booking_id'.tr, '#${booking.id}'),
          const SizedBox(height: 10),
          _infoRow('booked_on'.tr, createdStr),
          const SizedBox(height: 10),
          _infoRow(
            'total_amount'.tr,
            '\$${(booking.totalAmount ?? 0.0).toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statusPill(
                  'booking'.tr,
                  bookingStatus,
                  booking.bookingStatus ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatsCard(RefundModel refund) {
    final seats = refund.booking?.seats ?? [];
    if (seats.isEmpty) return const SizedBox.shrink();

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.event_seat, '${'seats'.tr} (${seats.length})'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: seats.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: goBusPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${'seat'.tr} ${s.seatId ?? '?'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminNoteCard(String note) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.admin_panel_settings_outlined, 'admin_note'.tr),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Text(
              note,
              style: TextStyle(fontSize: 14, color: Colors.blue.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'refund_details'.tr,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: goBusPrimary),
                    const SizedBox(height: 16),
                    Text(
                      'loading_refund_details'.tr,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'failed_to_load_refund_details'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goBusPrimary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('go_back'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? margin}) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: goBusPrimary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: goBusPrimary,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _statusPill(String label, String displayValue, String rawStatus) {
    final colors = _statusColors(rawStatus);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.$2.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: colors.$2, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label • ',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.$2,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return 'N/A';
    final translationKey = 'status_${status.toLowerCase()}';
    final translated = translationKey.tr;
    if (translated != translationKey) return translated;
    return status[0].toUpperCase() +
        status.substring(1).toLowerCase().replaceAll('_', ' ');
  }

  String _monthName(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m - 1];
  }

  (Color, Color) _statusColors(String status) {
    switch (status.toUpperCase()) {
      // Refund statuses
      case 'APPROVED':
        return (
          const Color(0xFF10B981).withOpacity(0.1),
          const Color(0xFF10B981),
        );
      case 'COMPLETED':
        return (
          const Color(0xFF10B981).withOpacity(0.1),
          const Color(0xFF10B981),
        );
      case 'REJECTED':
        return (
          const Color(0xFFEF4444).withOpacity(0.1),
          const Color(0xFFEF4444),
        );
      case 'PENDING':
        return (
          const Color(0xFFF59E0B).withOpacity(0.1),
          const Color(0xFFF59E0B),
        );

      // Booking statuses
      case 'CONFIRMED':
        return (
          const Color(0xFF10B981).withOpacity(0.1),
          const Color(0xFF10B981),
        );
      case 'CANCELLED':
        return (
          const Color(0xFFEF4444).withOpacity(0.1),
          const Color(0xFFEF4444),
        );
      case 'FAILED':
        return (
          const Color(0xFFDC2626).withOpacity(0.1),
          const Color(0xFFDC2626),
        );
      case 'REFUND_REQUESTED':
        return (
          const Color(0xFF8B5CF6).withOpacity(0.1),
          const Color(0xFF8B5CF6),
        );
      case 'REFUNDED':
        return (
          const Color(0xFF06B6D4).withOpacity(0.1),
          const Color(0xFF06B6D4),
        );

      // Payment statuses
      case 'PAID':
      case 'SUCCESS':
        return (
          const Color(0xFF10B981).withOpacity(0.1),
          const Color(0xFF10B981),
        );
      case 'PROCESSING':
        return (
          const Color(0xFFF59E0B).withOpacity(0.1),
          const Color(0xFFF59E0B),
        );
      case 'UNPAID':
        return (
          const Color(0xFF6B7280).withOpacity(0.1),
          const Color(0xFF6B7280),
        );

      default:
        return (
          const Color(0xFF6B7280).withOpacity(0.1),
          const Color(0xFF6B7280),
        );
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle_outline;
      case 'COMPLETED':
        return Icons.task_alt;
      case 'REJECTED':
        return Icons.cancel_outlined;
      case 'PENDING':
        return Icons.hourglass_empty;
      default:
        return Icons.help_outline;
    }
  }
}
