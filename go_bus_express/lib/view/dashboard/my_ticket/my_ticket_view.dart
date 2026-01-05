import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:go_bus_express/view_models/controller/ticket/ticket_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'ticket_detail_view.dart';

class MyTicketView extends StatefulWidget {
  const MyTicketView({super.key});

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TicketController _ticketController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ticketController = getIt<TicketController>();
    
    // Listen to tab changes to trigger API calls
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final isUpcoming = _tabController.index == 0;
        _ticketController.filterTickets(isUpcoming: isUpcoming);
      }
    });
    
    // Ensure the controller is initialized and fetch data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ticketController.onInit();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goBusPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Expanded(
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
                  IconButton(
                    onPressed: () {
                      // Refresh tickets
                      _ticketController.onInit();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ],
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
                        labelColor: goBusPrimary,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: goBusPrimary,
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 4.0,
                            color: goBusPrimary,
                          ),
                          insets: const EdgeInsets.symmetric(horizontal: 0),
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Past'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<TicketController>(
                        init: _ticketController,
                        builder: (controller) {
                          final currentTickets = controller.getCurrentTickets();
                          
                          // Debug: Show total tickets count and current type
                          print('🎫 Current tickets in UI: ${currentTickets.length}, type: ${controller.state.type}');
                          
                          // Show loading if no tickets yet
                          if (controller.state.tickets.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: goBusPrimary,
                                    strokeWidth: 3,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Loading tickets...',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          return TabBarView(
                            controller: _tabController,
                            children: [
                              // Upcoming tickets tab
                              _buildCurrentTicketTab(
                                controller,
                                'No upcoming trips',
                                'Your upcoming trips will appear here.',
                              ),
                              // Past tickets tab  
                              _buildCurrentTicketTab(
                                controller,
                                'No past trips',
                                'Your completed trips will appear here.',
                              ),
                            ],
                          );
                        },
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

  Widget _buildCurrentTicketTab(
    TicketController controller,
    String emptyTitle,
    String emptySubtitle,
  ) {
    final tickets = controller.getCurrentTickets();
    return tickets.isNotEmpty
        ? _buildTicketList(tickets)
        : _buildEmptyState(emptyTitle, emptySubtitle);
  }

  Widget _buildTicketList(List<Datum> tickets) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return _buildTicketCard(tickets[index]);
      },
    );
  }

  Widget _buildTicketCard(Datum ticket) {
    // Extract route information (you might need to adjust this based on your actual data structure)
    final routeText = _getRouteText(ticket);
    final ticketId = ticket.booking?.id?.toString() ?? 'N/A';
    final issueDate = _formatDate(ticket.issuedAt);
    final busInfo = _getBusInfo(ticket);
    final seatCount = ticket.booking?.seatCount?.toString() ?? '0';

    return GestureDetector(
      onTap: () {
        if (ticket.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketDetailView(ticketId: ticket.id!),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
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
                      color: goBusPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.directions_bus,
                      color: goBusPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      routeText,
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
                  const Icon(
                    Icons.receipt_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '#$ticketId',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      issueDate,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.airport_shuttle_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    busInfo,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.event_seat_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$seatCount seat${int.tryParse(seatCount) != 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (ticket.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailView(ticketId: ticket.id!),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('See Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRouteText(Datum ticket) {
    final route = ticket.booking?.schedule?.bus?.route;
    final origin = route?.origin;
    final destination = route?.destination;
    
    if (origin != null && destination != null) {
      return '$origin - $destination';
    }
    
    // Fallback if route data is not available
    return 'Route information not available';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getBusInfo(Datum ticket) {
    final busType = ticket.booking?.schedule?.bus?.busType ?? '';
    final busNumber = ticket.booking?.schedule?.bus?.busNumber ?? '';

    if (busType.isEmpty && busNumber.isEmpty) {
      return 'Bus Info N/A';
    }

    return '$busType $busNumber'.trim();
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
                return Icon(
                  Icons.luggage_outlined,
                  size: 80,
                  color: goBusPrimary,
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
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
