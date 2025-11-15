import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:shared_package/design_system/xwidget/user_profile_card.dart';

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
<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildAppBar(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserProfileCard(
                    name: 'សុប្រ័យ ស៊ុន',
                    email: 'goldammy24k@gmail.com',
                  ),
                  const SizedBox(height: 24),
                  _buildBookingCard(),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Special Offers'),
                  const SizedBox(height: 12),
                  _buildPromotions(),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Support'),
                  const SizedBox(height: 12),
                  _buildSupportCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
=======
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
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
=======
          Image.asset(
            'assets/images/go_bus_logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[700]!],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GoBus',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Express Travel',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF6B7280),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.phone_outlined,
                  color: Colors.blue[700],
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
  Widget _buildBookingCard() {
=======
  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildUserProfileCard() {
    return UserProfileCard(
      name: 'សុប្រ័យ ស៊ុន',
      email: 'goldammy24k@gmail.com',
      onTap: () {
        // Handle profile tap
      },
    );
  }

  Widget _buildBookingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[600]!, Colors.blue[700]!],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildDirectionRow('Choose Direction', Icons.flag_outlined),
            const SizedBox(height: 12),
            _buildDirectionRow('Cambodia', Icons.add_circle_outline),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker('Departure Date', '2029-08-29'),
                ),
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

  Widget _buildDirectionRow(String text, IconData icon) {
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Book Your Trip',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          _buildSimpleField(
            icon: Icons.radio_button_checked,
            label: 'From',
            value: 'Choose your location',
            iconColor: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 12),
          _buildSimpleField(
            icon: Icons.location_on,
            label: 'To',
            value: 'Cambodia',
            iconColor: const Color(0xFFEF4444),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSimpleField(
                  icon: Icons.calendar_today,
                  label: 'Departure',
                  value: '29 Aug',
                  iconColor: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
              Expanded(
                child: _buildSimpleField(
                  icon: Icons.calendar_today,
                  label: 'Return',
                  value: '28 Aug',
                  iconColor: const Color(0xFF10B981),
                ),
=======
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Search Buses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
  Widget _buildSimpleField({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1.5,
          ),
=======
  Widget _buildDatePicker(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
        ),
        child: Row(
          children: [
<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFD1D5DB),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fast Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Book your favorite route instantly',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
=======
            const Icon(Icons.calendar_today, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(color: Colors.white, fontSize: 14),
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
=======
  Widget _buildPromotionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New & Promotions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
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
                      image: NetworkImage(
                        'https://via.placeholder.com/160x140',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
      ),
    );
  }

  Widget _buildPromotions() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final gradients = [
            [const Color(0xFF667EEA), const Color(0xFF764BA2)],
            [const Color(0xFFF093FB), const Color(0xFFF5576C)],
            [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
          ];
          final discounts = ['30% OFF', '25% OFF', '20% OFF'];
          final titles = ['Summer Special', 'Weekend Deal', 'Early Bird'];
          
          return InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradients[index],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradients[index][0].withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          discounts[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: gradients[index][0],
                          ),
                        ),
                      ),
<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.local_offer,
                          color: Colors.white,
                          size: 18,
                        ),
=======
                      SizedBox(height: 4),
                      Text(
                        'We are always here to help - 090 9001131',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Save on your next trip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
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
            child: const Icon(
              Icons.headset_mic,
              color: Color(0xFF2563EB),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '24/7 Customer Support',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '090 9001131',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.phone, color: Color(0xFF10B981)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD:go_bus_express/lib/view/home_page.dart
=======

  Widget _buildSmallSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
>>>>>>> 5223102 (work on profile UI):go_bus_express/lib/view/dashboard/home/home_view.dart
}
