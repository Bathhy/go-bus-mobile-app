import 'package:flutter/material.dart';

class TicketDetailView extends StatefulWidget {
  const TicketDetailView({super.key});

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
                'Phnom Penh - Kompong Cham',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '8033-65978-3',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const Text(
                '(#) 12 Sep 2025 [09:15 AM]',
                style: TextStyle(
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

  Widget _buildTicketCard() {
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
          _buildInfoRow('ប្រភេទសេវា', 'Luxury Coaster (16)'),
          _buildDivider(),
          _buildInfoRow('ថ្ងៃធ្វើដំណើរ', '2025-12-20'),
          _buildDivider(),
          _buildInfoRow('លេខកូដកក់', 'CAMR-UHELQHXIRWXM'),
          _buildDivider(),
          _buildInfoRow('លេខអាសនៈ', '0987654321'),
          _buildDivider(),
          _buildInfoRow('ទូទាត់', 'ABA'),
          _buildDivider(),
          _buildLocationSection(
            'ទីតាំងឡើងដំបូង',
            'Channa Pich VIP (09:15 AM)',
            'Chvicha Oue E (St 78), Phnom Penh, Cambodia',
          ),
          _buildDivider(),
          _buildLocationSection(
            'ទីតាំងចុះ',
            'Kompong Cham VIP (09:15 AM)',
            'Kompong Cham',
          ),
          _buildDivider(),
          _buildInfoRow('ឈ្មោះ', 'Thong Vathana'),
          _buildDivider(),
          _buildInfoRow('ភេទ', 'Male'),
          _buildDivider(),
          _buildInfoRow('លេខទូរស័ព្ទ', '012 345 678'),
          _buildDivider(),
          _buildInfoRow('សញ្ជាតិ', 'Cambodia'),
          _buildDivider(),
          _buildInfoRow('អាយុ', '21'),
          _buildDivider(),
          _buildInfoRow('លេខកៅអី', '11'),
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
                  'មើលផែនទី',
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
                'តម្លៃ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$ 18.00',
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
                'ការបញ្ចុះតម្លៃ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$ 6.50',
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
                'សរុបចុងក្រោយ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$ 17.50',
                style: TextStyle(
                  color: Color(0xFF5B7FFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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