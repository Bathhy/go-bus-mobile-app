import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/view_models/controller/ticket/ticket_detail_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailView extends StatefulWidget {
  const TicketDetailView({super.key});

  @override
  State<TicketDetailView> createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {
  final TicketDetailController _controller = getIt<TicketDetailController>();

  // Helper method for safe translation
  String _translate(String key, {String? fallback}) {
    try {
      if (Get.locale == null) {
        return fallback ?? key;
      }
      final translated = key.tr;
      return translated != key ? translated : (fallback ?? key);
    } catch (e) {
      debugPrint('Translation error for key "$key": $e');
      return fallback ?? key;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      _controller.initializeWithArguments(args);
    });
  }

  @override
  void dispose() {
    if (Get.isRegistered<TicketDetailController>()) {
      Get.delete<TicketDetailController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: GetBuilder<TicketDetailController>(
        init: _controller,
        builder: (controller) {
          if (controller.state.isLoading) {
            return _buildLoadingState();
          }

          if (controller.state.error != null) {
            return _buildErrorState(controller.state.error!);
          }

          return Column(
            children: [
              _buildModernHeader(controller),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Column(
                    children: [
                      _buildMainTicketCard(controller),
                      _buildQRCodeSection(),
                      _buildPassengerSection(controller),
                      _buildSeatsSection(controller),
                      _buildPaymentDetailsSection(controller),
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

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    _translate('ticket_details', fallback: 'Ticket Details'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      _translate('loading_ticket_details', fallback: 'Loading ticket details...'),
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

  Widget _buildErrorState(String error) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    _translate('ticket_details', fallback: 'Ticket Details'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        _translate('failed_to_load_ticket', fallback: 'Failed to load ticket details'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(error, style: const TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          _controller.fetchTicketDetail(ticketId: _controller.state.ticketId);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: goBusPrimary, foregroundColor: Colors.white),
                        child: Text(_translate('retry', fallback: 'Retry')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(TicketDetailController controller) {
    final ticketDetail = controller.state.ticketDetail;
    final booking = ticketDetail?.bookingDetailResponse;
    final schedule = booking?.schedule;
    
    final ticketId = ticketDetail?.id?.toString() ?? controller.state.ticketId.toString();
    final issueDate = ticketDetail?.issuedAt;
    final formattedDate = issueDate != null
        ? '${issueDate.day} ${_getMonthName(issueDate.month)} ${issueDate.year}'
        : 'N/A';

    final origin = schedule?.origin ?? 'Origin';
    final destination = schedule?.destination ?? 'Destination';

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
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    _translate('ticket_details', fallback: 'Ticket details'),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '${_translate('ticket', fallback: 'Ticket')} #$ticketId',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(origin, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(destination, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('${_translate('issued', fallback: 'Issued')} • $formattedDate', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _formatTravelDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return 'N/A';
    // Convert backend format (e.g., REFUND_REQUESTED) to translation key (e.g., status_refund_requested)
    final translationKey = 'status_${status.toLowerCase()}';
    return _translate(translationKey, fallback: status.replaceAll('_', ' ').split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' '));
  }

  Widget _buildMainTicketCard(TicketDetailController controller) {
    final ticketDetail = controller.state.ticketDetail;
    final booking = ticketDetail?.bookingDetailResponse;
    final schedule = booking?.schedule;

    final busType = schedule?.busType ?? 'N/A';
    final busNumber = schedule?.busNumber ?? 'N/A';
    final busInfo = '$busType - $busNumber';
    
    final departureDateTime = schedule?.departureDateTime;
    final travelDate = _formatTravelDate(departureDateTime);
    final bookingId = booking?.id?.toString() ?? 'N/A';
    final paymentStatus = _formatStatus(booking?.paymentStatus ?? '');
    final bookingStatus = _formatStatus(booking?.bookingStatus ?? '');

    final departureTime = departureDateTime != null
        ? '${departureDateTime.hour.toString().padLeft(2, '0')}:${departureDateTime.minute.toString().padLeft(2, '0')}'
        : 'N/A';
    final arrivalDateTime = schedule?.arrivalDateTime;
    final arrivalTime = arrivalDateTime != null
        ? '${arrivalDateTime.hour.toString().padLeft(2, '0')}:${arrivalDateTime.minute.toString().padLeft(2, '0')}'
        : 'N/A';

    final seats = booking?.seats ?? [];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.directions_bus, color: goBusPrimary, size: 20),
                const SizedBox(width: 8),
                Text(busInfo, style: TextStyle(color: goBusPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(travelDate, style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(departureTime, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(schedule?.origin ?? 'Departure', style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(_translate('departure', fallback: 'Departure'), style: const TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: goBusPrimary, shape: BoxShape.circle)),
                      Container(width: 2, height: 30, color: Colors.grey[300]),
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: goBusPrimary, shape: BoxShape.circle)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(arrivalTime, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(schedule?.destination ?? 'Arrival', textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(_translate('arrival', fallback: 'Arrival'), style: const TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildSeatChipsCard(seats)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard(Icons.confirmation_number, '#$bookingId', _translate('booking', fallback: 'Booking'))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusChip(
                    _translate('booking', fallback: 'Booking'),
                    bookingStatus.isEmpty ? 'N/A' : bookingStatus,
                    booking?.bookingStatus,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: goBusPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: goBusPrimary, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, String? rawStatus) {
    Color statusColor = Colors.grey;
    Color backgroundColor = Colors.grey.withOpacity(0.1);
    
    if (rawStatus != null) {
      switch (rawStatus.toLowerCase()) {
        // Booking statuses
        case 'confirmed':
          statusColor = const Color(0xFF10B981); // Green
          backgroundColor = const Color(0xFF10B981).withOpacity(0.1);
          break;
        case 'pending':
          statusColor = const Color(0xFFF59E0B); // Orange
          backgroundColor = const Color(0xFFF59E0B).withOpacity(0.1);
          break;
        case 'cancelled':
          statusColor = const Color(0xFFEF4444); // Red
          backgroundColor = const Color(0xFFEF4444).withOpacity(0.1);
          break;
        case 'failed':
          statusColor = const Color(0xFFDC2626); // Dark Red
          backgroundColor = const Color(0xFFDC2626).withOpacity(0.1);
          break;
        case 'refund_requested':
          statusColor = const Color(0xFF8B5CF6); // Purple
          backgroundColor = const Color(0xFF8B5CF6).withOpacity(0.1);
          break;
        case 'refunded':
          statusColor = const Color(0xFF06B6D4); // Cyan
          backgroundColor = const Color(0xFF06B6D4).withOpacity(0.1);
          break;
        
        // Payment statuses
        case 'paid':
        case 'success':
        case 'completed':
          statusColor = const Color(0xFF10B981); // Green
          backgroundColor = const Color(0xFF10B981).withOpacity(0.1);
          break;
        case 'processing':
          statusColor = const Color(0xFFF59E0B); // Orange
          backgroundColor = const Color(0xFFF59E0B).withOpacity(0.1);
          break;
        case 'unpaid':
          statusColor = const Color(0xFF6B7280); // Gray
          backgroundColor = const Color(0xFF6B7280).withOpacity(0.1);
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return GetBuilder<TicketDetailController>(
      init: _controller,
      builder: (controller) {
        final ticketDetail = controller.state.ticketDetail;
        final booking = ticketDetail?.bookingDetailResponse;
        final ticketId = ticketDetail?.id?.toString() ?? controller.state.ticketId.toString();

        final bookingId = booking?.id?.toString() ?? '1';
        final qrCode = ticketDetail?.qrCode ?? 'TICKET-BOOKING-${bookingId.padLeft(3, '0')}';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: QrImageView(
                  data: qrCode,
                  version: QrVersions.auto,
                  size: 180.0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _translate('show_qr_to_driver', fallback: 'Show this QR code to the driver'),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${_translate('ticket', fallback: 'Ticket')} ID: $ticketId',
                style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPassengerSection(TicketDetailController controller) {
    final booking = controller.state.ticketDetail?.bookingDetailResponse;
    final user = booking?.user;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: goBusPrimary, size: 20),
              const SizedBox(width: 8),
              Text(_translate('passenger', fallback: 'Passenger'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: goBusPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: goBusPrimary, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    (user?.fullName ?? 'U').substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.fullName ?? 'N/A', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(user?.email ?? 'N/A', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          if (user?.phone != null || booking?.phoneNumber != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: Colors.black54, size: 18),
                const SizedBox(width: 8),
                Text(user?.phone ?? booking?.phoneNumber ?? 'N/A', style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsSection(TicketDetailController controller) {
    final ticketDetail = controller.state.ticketDetail;
    final booking = ticketDetail?.bookingDetailResponse;
    final schedule = booking?.schedule;

    final schedulePrice = schedule?.price ?? 0.0;
    final totalAmount = booking?.totalAmount ?? 0.0;
    final discount = schedulePrice > totalAmount ? (schedulePrice - totalAmount) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_outlined, color: goBusPrimary, size: 20),
              const SizedBox(width: 8),
              Text(_translate('payment_details', fallback: 'Payment details'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: goBusPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          _buildPriceRow(_translate('base_fare', fallback: 'Base fare'), schedulePrice, isDiscount: false),
          const SizedBox(height: 12),
          _buildPriceRow(_translate('discount', fallback: 'Discount'), discount, isDiscount: true),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_translate('total_paid', fallback: 'Total paid'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              Text('\$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: goBusPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(
          isDiscount && amount > 0 ? '-\$${amount.toStringAsFixed(2)}' : '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDiscount && amount > 0 ? Colors.green : Colors.black87),
        ),
      ],
    );
  }

  Widget _buildSeatChipsCard(List<dynamic> seats) {
    final seatCount = seats.length;
    final label = seatCount == 1
        ? '1 ${_translate('seat', fallback: 'Seat')}'
        : '$seatCount ${_translate('seats', fallback: 'Seats')}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: goBusPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.event_seat, color: goBusPrimary, size: 24),
          const SizedBox(height: 8),
          seats.isEmpty
              ? Text('N/A', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87))
              : Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: seats.map((seat) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: goBusPrimary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        seat.seatNumber ?? '?',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildSeatsSection(TicketDetailController controller) {
    final seats = controller.state.ticketDetail?.bookingDetailResponse?.seats ?? [];
    if (seats.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_seat, color: goBusPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                '${_translate('seats', fallback: 'Seats')} (${seats.length})',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: goBusPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...seats.asMap().entries.map((entry) {
            final index = entry.key;
            final seat = entry.value;
            return Column(
              children: [
                if (index > 0) ...[
                  Container(height: 1, color: Colors.grey[100]),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: goBusPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          seat.seatNumber ?? '?',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_translate('seat', fallback: 'Seat')} ${seat.seatNumber ?? 'N/A'}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          if (seat.seatType != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              seat.seatType!,
                              style: const TextStyle(fontSize: 12, color: Colors.black45),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (seat.passengerNumber != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${seat.passengerNumber}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }
}
