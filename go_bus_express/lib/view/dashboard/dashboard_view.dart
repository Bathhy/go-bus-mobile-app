import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/view/dashboard/home/home_view.dart';
import 'package:go_bus_express/view/dashboard/profile/profile_view.dart';
import 'package:go_bus_express/view/dashboard/my_ticket/my_ticket_view.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const MyTicketView();
      case 2:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentPage(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: goBusPrimary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: goBusPrimary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: AppSvgImage(
                path: AppImages.icHome,
                width: 25,
                height: 25,
                color: _selectedIndex == 0 ? Colors.white : Colors.white70,
              ),
              label: 'Home'.tr,
            ),
            BottomNavigationBarItem(
              icon: AppSvgImage(
                path: AppImages.icTicket,
                width: 25,
                height: 25,
                color: _selectedIndex == 1 ? Colors.white : Colors.white70,
              ),
              label: 'Ticket'.tr,
            ),
            BottomNavigationBarItem(
              icon: AppSvgImage(
                path: AppImages.icProfile,
                width: 25,
                height: 25,
                color: _selectedIndex == 2 ? Colors.white : Colors.white70,
              ),
              label: 'Profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
