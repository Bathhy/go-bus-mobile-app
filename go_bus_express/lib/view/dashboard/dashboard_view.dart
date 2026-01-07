import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/view/dashboard/home/home_view.dart';
import 'package:go_bus_express/view/dashboard/profile/profile_view.dart';
import 'package:go_bus_express/view/dashboard/my_ticket/my_ticket_view.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final homeController = getIt<HomeController>();
  final profileController = getIt<ProfileController>();
  int _selectedIndex = 0;

  final List<Widget> _pages = const [HomePage(), MyTicketView(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refetch();
    });
  }

  void _refetch() {
    homeController.fetchProfile();
    homeController.loadCachedRoutes();

    profileController.loadCachedProfile();
    profileController.loadCurrentLanguage();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _refreshCurrentTab(index);
  }

  void _refreshCurrentTab(int index) {
    switch (index) {
      case 0:
        // Home tab - refresh HomeController
        try {
          homeController.fetchProfile();
          homeController.loadCachedRoutes();
        } catch (e) {
          // Controller not found
        }
        break;
      case 1:
        // Ticket tab - add refresh logic if needed
        break;
      case 2:
        try {
          profileController.loadCachedProfile();
          profileController.loadCurrentLanguage();
        } catch (e) {
          // Controller not found
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
