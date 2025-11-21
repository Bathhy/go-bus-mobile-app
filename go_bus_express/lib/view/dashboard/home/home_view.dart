import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:shared_package/design_system/x_widget/user_profile_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePageContent();
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 16),
              _buildUserProfileCard(),
              const SizedBox(height: 16),
              _buildBookingCard(),
              const SizedBox(height: 16),
              _buildFastBookingSection(),
              const SizedBox(height: 16),
              _buildPromotionsSection(),
              const SizedBox(height: 16),
              _buildNeedHelpSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------
  // APP BAR
  // ------------------------
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/go_bus_logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[700]!],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
          Row(
            children: [
              _iconButton(Icons.notifications_none_rounded),
              const SizedBox(width: 10),
              _iconButton(Icons.phone_outlined, color: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, {Color color = const Color(0xFF6B7280)}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  // ------------------------
  // PROFILE
  // ------------------------
  Widget _buildUserProfileCard() {
    return UserProfileCard(
      name: 'សុប្រ័យ ស៊ុន',
      email: 'goldammy24k@gmail.com',
      onTap: () {},
    );
  }

  // ------------------------
  // BOOKING CARD
  // ------------------------
  Widget _buildBookingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue[600]!, Colors.blue[700]!]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildBookingRow('Choose Direction', Icons.flag_outlined),
            const SizedBox(height: 12),
            _buildBookingRow('Cambodia', Icons.add_circle_outline),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildDatePicker('Departure Date', '2029-08-29')),
                const SizedBox(width: 16),
                Expanded(child: _buildDatePicker('Return Date', '2029-08-28')),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.selectRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[700],
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingRow(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildDatePicker(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(date, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  // ------------------------
  // FAST BOOKING CARD
  // ------------------------
  Widget _buildFastBookingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fast Booking',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Book your favorite route instantly',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // ------------------------
  // PROMOTIONS
  // ------------------------
  Widget _buildPromotionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New & Promotions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/160x140"),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // SUPPORT SECTION
  // ------------------------
  Widget _buildNeedHelpSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.headset_mic, color: Color(0xFF2563EB), size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('24/7 Customer Support',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('090 9001131',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone, color: Color(0xFF10B981)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
