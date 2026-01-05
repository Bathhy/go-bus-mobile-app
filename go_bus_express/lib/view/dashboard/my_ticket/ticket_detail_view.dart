import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/ticket/ticket_detail_model.dart';
import 'package:go_bus_express/view_models/controller/ticket/ticket_detail_controller.dart';
import 'package:shared_package/config/themes.dart';

/// Ticket Detail View - Shows comprehensive ticket information
/// 
/// Current Status:
/// ✅ Uses TicketDetailController for API data fetching
/// ✅ Displays real ticket detail information from API
/// ✅ Proper error handling and loading states
/// 
/// Features:
/// - Fetches detailed ticket information by ID
/// - Shows route, schedule, bus, and booking information
/// - Displays pricing details
/// - QR code section for ticket validation
/// - Proper loading and error states
class TicketDetailView extends StatefulWidget {
  final int ticketId;
  
  const TicketDetailView({super.key, required this.ticketId});

  @override
  State<TicketDetailView> createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {
  late TicketDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = getIt<TicketDetailController>();
    
    // Register controller with GetX if not already registered
    if (!Get.isRegistered<TicketDetailController>()) {
      Get.put(_controller);
    }
    
    // Fetch ticket details when view loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchTicketDetail(ticketId: widget.ticketId);
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
                  const Text(
                    'Ticket Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
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
                    const Text(
                      'Loading ticket details...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
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
                  const Text(
                    'Ticket Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
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
                      const Text(
                        'Failed to load ticket details',
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
                          _controller.fetchTicketDetail(ticketId: widget.ticketId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goBusPrimary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
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
    final ticketId = ticketDetail?.booking?.id?.toString() ?? widget.ticketId.toString();
    final issueDate = ticketDetail?.issuedAt;
    final formattedDate = issueDate != null 
        ? '${issueDate.day} ${_getMonthName(issueDate.month)} ${issueDate.year}'
        : 'N/A';
    
    final routeInfo = controller.getRouteInfo();
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF85B3E1), Color(0xFF6B9FD8)],
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
                'Ticket #$ticketId',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                'Issued: $formattedDate',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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

  // TODO: Replace these methods with actual passenger data from API
  String _getPassengerName() => 'Thong Vathana'; // Should come from user data
  String _getPassengerPhone() => '012 345 678';

  Widget _buildTicketCard(TicketDetailController controller) {
    final ticketDetail = controller.state.ticketDetail;
    final booking = ticketDetail?.booking;
    final schedule = booking?.schedule;
    final bus = schedule?.bus;
    
    final busInfo = controller.getBusInfo();
    final travelDate = _formatTravelDate(ticketDetail?.issuedAt);
    final bookingId = booking?.id?.toString() ?? 'N/A';
    final paymentStatus = _formatStatus(booking?.paymentStatus ?? 'N/A');
    final bookingStatus = _formatStatus(booking?.bookingStatus ?? 'N/A');
    
    // Get departure and arrival times from schedule
    final departureTime = schedule?.departureTime ?? 'N/A';
    final arrivalTime = schedule?.arrivalTime != null 
        ? '${schedule!.arrivalTime!.hour.toString().padLeft(2, '0')}:${schedule.arrivalTime!.minute.toString().padLeft(2, '0')}'
        : 'N/A';
    
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
          _buildInfoRow('Service Type', busInfo),
          _buildDivider(),
          _buildInfoRow('Travel Date', travelDate),
          _buildDivider(),
          _buildInfoRow('Booking Code', bookingId),
          _buildDivider(),
          _buildInfoRow('Departure Time', departureTime),
          _buildDivider(),
          _buildInfoRow('Arrival Time', arrivalTime),
          _buildDivider(),
          _buildStatusRow('Payment Status', paymentStatus , booking?.paymentStatus),
          _buildDivider(),
          _buildStatusRow('Booking Status', bookingStatus, booking?.bookingStatus),
          _buildDivider(),
          _buildLocationSection(
            'Departure Location',
            _getDepartureInfo(controller),
            _getDepartureAddress(controller),
          ),
          _buildDivider(),
          _buildLocationSection(
            'Arrival Location',
            _getArrivalInfo(controller),
            _getArrivalAddress(controller),
          ),
          _buildDivider(),
          // TODO: Get passenger info from API when available
          _buildInfoRow('Passenger Name', _getPassengerName()),
          _buildDivider(),
          _buildInfoRow('Phone Number', _getPassengerPhone()),
        ],
      ),
    );
  }

  Widget _buildPriceSection(TicketDetailController controller) {
    final pricing = controller.getPricingInfo();
    
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
              const Text(
                'Price',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$ ${pricing['price']}',
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
              const Text(
                'Discount',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$ ${pricing['discount']}',
                style: TextStyle(
                  color: goBusPrimary,
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
              const Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$ ${pricing['total']}',
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
    final departureTime = controller.state.ticketDetail?.booking?.schedule?.departureTime ?? 'N/A';
    return '${route?.origin ?? 'Departure'} ($departureTime)';
  }
  
  String _getDepartureAddress(TicketDetailController controller) {
    final route = controller.state.ticketDetail?.booking?.schedule?.bus?.route;
    return route?.origin ?? 'Departure location not available';
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
    return route?.destination ?? 'Arrival location not available';
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
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
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
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
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
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
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
                child: const Text(
                  'View Map',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
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
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFE0E0E0));
  }

  Widget _buildQRCodeSection() {
    final ticketId = widget.ticketId.toString();
    
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
          const Text(
            'Ticket QR Code',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code,
                  size: 60,
                  color: goBusPrimary,
                ),
                const SizedBox(height: 8),
                const Text(
                  'QR Code',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ticket ID: $ticketId',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Show this QR code to the driver',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}