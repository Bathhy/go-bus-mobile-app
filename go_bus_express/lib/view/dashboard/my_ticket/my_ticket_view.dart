import 'package:flutter/material.dart';
import 'ticket_detail_view.dart';

class MyTicketView extends StatefulWidget {
  const MyTicketView({super.key});

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B7FFF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFF5B7FFF),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF5B7FFF),
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Past'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTicketList(),
                          _buildEmptyState(
                            'No trip Ticket',
                            'Book your trips and check here for your trips!',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTicketList() {
    final tickets = [
      {
        'route': 'Phnom Penh - Kompong Cham',
        'bookingId': 'BG254097745',
        'date': '2025-10-25 (09:30AM)',
        'busType': 'Luxury Coaster',
        'busNumber': '(16)',
        'seats': '1 Seats',
      },
      {
        'route': 'Phnom Penh - Kompot',
        'bookingId': 'BG254097746',
        'date': '2025-10-07 (07:00AM)',
        'busType': 'Luxury Coaster',
        'busNumber': '(32)',
        'seats': '2 Seats',
      },
      {
        'route': 'Phnom Penh - Takeo',
        'bookingId': 'BG254097747',
        'date': '2025-10-25 (09:30AM)',
        'busType': 'Luxury Coaster',
        'busNumber': '(16)',
        'seats': '1 Seats',
      },
      {
        'route': 'Phnom Penh - Kompong Cham',
        'bookingId': 'BG254097745',
        'date': '2025-10-25 (09:30AM)',
        'busType': 'Luxury Coaster',
        'busNumber': '(16)',
        'seats': '1 Seats',
      },
      {
        'route': 'Phnom Penh - Kompot',
        'bookingId': 'BG254097746',
        'date': '2025-10-07 (07:00AM)',
        'busType': 'Luxury Coaster',
        'busNumber': '(32)',
        'seats': '2 Seats',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return _buildTicketCard(tickets[index]);
      },
    );
  }

  Widget _buildTicketCard(Map<String, String> ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B7FFF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_bus,
                    color: Color(0xFF5B7FFF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ticket['route']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.receipt_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  ticket['bookingId']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ticket['date']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.airport_shuttle_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${ticket['busType']!} ${ticket['busNumber']!}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.event_seat_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  ticket['seats']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Rate a schedule action
                    },
                    icon: const Icon(Icons.schedule, size: 16),
                    label: const Text('Rate a schedule'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00BCD4),
                      side: const BorderSide(color: Color(0xFF00BCD4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TicketDetailView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('See details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_trip.png',
              width: 240,
              height: 180,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.luggage_outlined,
                  size: 80,
                  color: Colors.grey,
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
  //         icon: Icon(Icons.local_shipping_outlined),
  //         label: 'Tracking',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.person_outline),
  //         label: 'Profile',
  //       ),
  //     ],
  //   );
  // }
}