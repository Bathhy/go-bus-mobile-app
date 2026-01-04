import 'package:flutter/material.dart';
import 'package:go_bus_express/models/ticket/ticket_model.dart';

class TicketDetailView extends StatefulWidget {
  final Datum ticket;
  
  const TicketDetailView({super.key, required this.ticket});

  @override
  State<TicketDetailView> createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                children: [
                  _buildTicketCard(),
                  _buildPriceSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    final ticketId = widget.ticket.booking?.id?.toString() ?? 'N/A';
    final issueDate = widget.ticket.issuedAt != null 
        ? '${widget.ticket.issuedAt!.day} ${_getMonthName(widget.ticket.issuedAt!.month)} ${widget.ticket.issuedAt!.year}'
        : 'N/A';
    
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
              const Text(
                'Phnom Penh - Kompong Cham', // You can make this dynamic based on route data
                style: TextStyle(
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
                'Issued: $issueDate',
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

  Widget _buildTicketCard() {
    final booking = widget.ticket.booking;
    final bus = booking?.schedule?.bus;
    final busInfo = '${bus?.busType ?? 'N/A'} (${bus?.busNumber ?? 'N/A'})';
    final issueDate = widget.ticket.issuedAt?.toIso8601String().split('T')[0] ?? 'N/A';
    final bookingId = booking?.id?.toString() ?? 'N/A';
    final seatCount = booking?.seatCount?.toString() ?? '0';
    final paymentStatus = booking?.paymentStatus ?? 'N/A';
    final bookingStatus = booking?.bookingStatus ?? 'N/A';
    
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
          _buildInfoRow('Travel Date', issueDate),
          _buildDivider(),
          _buildInfoRow('Booking Code', bookingId),
          _buildDivider(),
          _buildInfoRow('Seat Count', '$seatCount seat${int.tryParse(seatCount) != 1 ? 's' : ''}'),
          _buildDivider(),
          _buildInfoRow('Payment Status', paymentStatus),
          _buildDivider(),
          _buildInfoRow('Booking Status', bookingStatus),
          _buildDivider(),
          _buildLocationSection(
            'Departure Location',
            'Channa Pich VIP (09:15 AM)', // You can make this dynamic
            'Chvicha Oue E (St 78), Phnom Penh, Cambodia',
          ),
          _buildDivider(),
          _buildLocationSection(
            'Arrival Location',
            'Kompong Cham VIP (09:15 AM)', // You can make this dynamic
            'Kompong Cham',
          ),
          _buildDivider(),
          _buildInfoRow('Passenger Name', 'Thong Vathana'), // You can make this dynamic
          _buildDivider(),
          _buildInfoRow('Gender', 'Male'), // You can make this dynamic
          _buildDivider(),
          _buildInfoRow('Phone Number', '012 345 678'), // You can make this dynamic
          _buildDivider(),
          _buildInfoRow('Nationality', 'Cambodia'), // You can make this dynamic
          _buildDivider(),
          _buildInfoRow('Age', '21'), // You can make this dynamic
        ],
      ),
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
                  color: const Color(0xFF5B7FFF),
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

  Widget _buildPriceSection() {
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
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$ 18.00', // You can make this dynamic based on ticket data
                style: TextStyle(
                  color: Color(0xFF5B7FFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$ 0.00', // You can make this dynamic based on ticket data
                style: TextStyle(
                  color: Color(0xFF5B7FFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$ 18.00', // You can make this dynamic based on ticket data
                style: TextStyle(
                  color: Color(0xFF5B7FFF),
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

  // Widget _buildBottomNav() {
  //   return BottomNavigationBar(
  //     type: BottomNavigationBarType.fixed,
  //     backgroundColor: const Color(0xFF5B7FFF),
  //     selectedItemColor: Colors.white,
  //     unselectedItemColor: Colors.white70,
  //     currentIndex: 1,
  //     selectedFontSize: 12,
  //     unselectedFontSize: 12,
  //     items: const [
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home_outlined),
  //         label: 'Home',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.confirmation_number_outlined),
  //         label: 'Ticket',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.receipt_long_outlined),
  //         label: 'Trips',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.person_outline),
  //         label: 'Profile',
  //       ),
  //     ],
  //   );
  // }
}