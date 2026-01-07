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
      // Check if Get.locale is available
      if (Get.locale == null) {
        return fallback ?? key;
      }

      final translated = key.tr;
      // If translation returns the same key, it means translation failed
      return translated != key ? translated : (fallback ?? key);
    } catch (e) {
      debugPrint('Translation error for key "$key": $e');
      return fallback ?? key;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controller with route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      _controller.initializeWithArguments(args);
    });
  }

  @override
  void dispose() {
    // Clean up controller if we registered it
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
          // Show loading state
          if (controller.state.isLoading) {
            return _buildLoadingState();
          }

          // Show error state
          if (controller.state.error != null) {
            return _buildErrorState(controller.state.error!);
          }

          // Show ticket details
          return Column(
            children: [
              _buildHeader(controller),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: Column(
                    children: [
                      _buildTicketCard(controller),
                      _buildQRCodeSection(),
                      _buildPriceSection(controller),
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
            // Header with back button
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            // Loading indicator
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: goBusPrimary),
                    const SizedBox(height: 16),
                    Text(
                      _translate(
                        'loading_ticket_details',
                        fallback: 'Loading ticket details...',
                      ),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
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
            // Header with back button
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            // Error state
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _translate(
                          'failed_to_load_ticket',
                          fallback: 'Failed to load ticket details',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          _controller.fetchTicketDetail(
                            ticketId: _controller.state.ticketId,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goBusPrimary,
                          foregroundColor: Colors.white,
                        ),
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

  Widget _buildHeader(TicketDetailController controller) {
    final ticketDetail = controller.state.ticketDetail;
    final ticketId =
        ticketDetail?.id?.toString() ?? controller.state.ticketId.toString();
    final bookingId = ticketDetail?.bookingId?.toString() ?? 'N/A';
    final issueDate = ticketDetail?.issuedAt;
    final formattedDate = issueDate != null
        ? '${issueDate.day} ${_getMonthName(issueDate.month)} ${issueDate.year}'
        : 'N/A';

    final routeInfo = controller.getRouteInfo();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [goBusPrimary, goBusPrimary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
              Text(
                routeInfo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_translate('ticket_number', fallback: 'Ticket #')}$ticketId',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '${_translate('booking_number', fallback: 'Booking #')}$bookingId',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '${_translate('issued', fallback: 'Issued:')} $formattedDate',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }

  String _formatTravelDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatStatus(String status) {
    // Capitalize first letter and format status
    if (status.isEmpty) return 'N/A';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  Widget _buildTicketCard(TicketDetailController controller) {
    final ticketDetail = controller.state.ticketDetail;
    final booking = ticketDetail?.booking;
    final schedule = booking?.schedule;
    final bus = schedule?.bus;
    final route = bus?.route;

    final busInfo = controller.getBusInfo();
    final travelDate = _formatTravelDate(schedule?.departureDate);
    final bookingId = booking?.id?.toString() ?? 'N/A';
    final paymentStatus = _formatStatus(booking?.paymentStatus ?? 'N/A');
    final bookingStatus = _formatStatus(booking?.bookingStatus ?? 'N/A');

    // Get departure and arrival times from schedule
    final departureTime = schedule?.departureTime ?? 'N/A';
    final arrivalTime = schedule?.arrivalTime != null
        ? '${schedule!.arrivalTime!.hour.toString().padLeft(2, '0')}:${schedule.arrivalTime!.minute.toString().padLeft(2, '0')}'
        : 'N/A';

    // Additional information from API
    final distance = route?.distanceKm != null
        ? '${route!.distanceKm} km'
        : 'N/A';
    final duration = route?.durationMinutes != null
        ? '${(route!.durationMinutes! / 60).floor()}h ${route.durationMinutes! % 60}m'
        : 'N/A';
    final totalSeats = bus?.totalSeats?.toString() ?? 'N/A';
    final schedulePrice = schedule?.price?.toString() ?? 'N/A';

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            _translate('service_type', fallback: 'Service Type'),
            busInfo,
          ),
          _buildDivider(),
          _buildInfoRow(
            _translate('travel_date', fallback: 'Travel Date'),
            travelDate,
          ),
          _buildDivider(),
          _buildInfoRow(
            _translate('booking_code', fallback: 'Booking Code'),
            bookingId,
          ),
          _buildDivider(),
          _buildInfoRow(
            _translate('departure_time', fallback: 'Departure Time'),
            departureTime,
          ),
          _buildDivider(),
          _buildInfoRow(
            _translate('arrival_time', fallback: 'Arrival Time'),
            arrivalTime,
          ),
          _buildDivider(),
          _buildInfoRow(_translate('distance', fallback: 'Distance'), distance),
          _buildDivider(),
          _buildInfoRow(_translate('duration', fallback: 'Duration'), duration),
          _buildDivider(),
          _buildInfoRow(
            _translate('total_seats', fallback: 'Total Seats'),
            totalSeats,
          ),
          _buildDivider(),
          _buildInfoRow(
            _translate('schedule_price', fallback: 'Schedule Price'),
            '\$ $schedulePrice',
          ),
          _buildDivider(),
          _buildStatusRow(
            _translate('payment_status', fallback: 'Payment Status'),
            paymentStatus,
            booking?.paymentStatus,
          ),
          _buildDivider(),
          _buildStatusRow(
            _translate('booking_status', fallback: 'Booking Status'),
            bookingStatus,
            booking?.bookingStatus,
          ),
          _buildDivider(),
          _buildLocationSection(
            _translate('departure_location', fallback: 'Departure Location'),
            _getDepartureInfo(controller),
            _getDepartureAddress(controller),
          ),
          _buildDivider(),
          _buildLocationSection(
            _translate('arrival_location', fallback: 'Arrival Location'),
            _getArrivalInfo(controller),
            _getArrivalAddress(controller),
          ),
          _buildDivider(),
          _buildInfoRow(
            _translate('passenger_name', fallback: 'Passenger Name'),
            _controller.getPassengerName(),
          ),
          _buildDivider(),
          _buildInfoRow(
            _translate('email', fallback: 'Email'),
            _controller.getPassengerEmail(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(TicketDetailController controller) {
    final ticketDetail = controller.state.ticketDetail;
    final booking = ticketDetail?.booking;
    final schedule = booking?.schedule;

    final totalAmount = booking?.totalAmount?.toString() ?? '0';
    final schedulePrice = schedule?.price?.toString() ?? '0';

    // Calculate discount (if schedule price is different from total amount)
    final schedulePriceNum = schedule?.price ?? 0;
    final totalAmountNum = booking?.totalAmount ?? 0;
    final discount = schedulePriceNum > totalAmountNum
        ? (schedulePriceNum - totalAmountNum).toString()
        : '0';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _translate('schedule_price', fallback: 'Schedule Price'),
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              Text(
                '\$ $schedulePrice',
                style: TextStyle(
                  color: goBusPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _translate('Discount', fallback: 'Discount'),
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              Text(
                '\$ $discount',
                style: TextStyle(
                  color: discount != '0' ? Colors.green : goBusPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _translate('total_amount', fallback: 'Total Amount'),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$ $totalAmount',
                style: TextStyle(
                  color: goBusPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Updated helper methods to use controller data
  String _getDepartureInfo(TicketDetailController controller) {
    final route = controller.state.ticketDetail?.booking?.schedule?.bus?.route;
    final departureTime =
        controller.state.ticketDetail?.booking?.schedule?.departureTime ??
        'N/A';
    return '${route?.origin ?? 'Departure'} ($departureTime)';
  }

  String _getDepartureAddress(TicketDetailController controller) {
    final route = controller.state.ticketDetail?.booking?.schedule?.bus?.route;
    return route?.origin ??
        _translate(
          'departure_location_not_available',
          fallback: 'Departure location not available',
        );
  }

  String _getArrivalInfo(TicketDetailController controller) {
    final route = controller.state.ticketDetail?.booking?.schedule?.bus?.route;
    final schedule = controller.state.ticketDetail?.booking?.schedule;
    final arrivalTime = schedule?.arrivalTime != null
        ? '${schedule!.arrivalTime!.hour.toString().padLeft(2, '0')}:${schedule.arrivalTime!.minute.toString().padLeft(2, '0')}'
        : 'N/A';
    return '${route?.destination ?? 'Arrival'} ($arrivalTime)';
  }

  String _getArrivalAddress(TicketDetailController controller) {
    final route = controller.state.ticketDetail?.booking?.schedule?.bus?.route;
    return route?.destination ??
        _translate(
          'arrival_location_not_available',
          fallback: 'Arrival location not available',
        );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, String? rawStatus) {
    Color statusColor = Colors.black87;

    // Color code based on status
    if (rawStatus != null) {
      switch (rawStatus.toLowerCase()) {
        case 'paid':
        case 'confirmed':
        case 'completed':
          statusColor = Colors.green;
          break;
        case 'pending':
        case 'processing':
          statusColor = Colors.orange;
          break;
        case 'cancelled':
        case 'failed':
          statusColor = Colors.red;
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(String title, String time, String location) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: goBusPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _translate('view_map', fallback: 'View Map'),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFE0E0E0));
  }

  Widget _buildQRCodeSection() {
    return GetBuilder<TicketDetailController>(
      init: _controller,
      builder: (controller) {
        final ticketDetail = controller.state.ticketDetail;
        final ticketId =
            ticketDetail?.id?.toString() ??
            controller.state.ticketId.toString();

        // Generate QR code based on booking ID pattern until model is regenerated
        final bookingId = ticketDetail?.bookingId?.toString() ?? '1';
        final qrCode = 'TICKET-BOOKING-${bookingId.padLeft(3, '0')}';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                _translate('ticket_qr_code', fallback: 'Ticket QR Code'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // Generate QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: QrImageView(
                  data: qrCode,
                  version: QrVersions.auto,
                  size: 150.0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${_translate('qr_code', fallback: 'QR Code')}: $qrCode',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_translate('ticket_id', fallback: 'Ticket ID')}: $ticketId',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                _translate(
                  'show_qr_to_driver',
                  fallback: 'Show this QR code to the driver',
                ),
                style: TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
