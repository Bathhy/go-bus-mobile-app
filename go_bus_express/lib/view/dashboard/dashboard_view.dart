import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/app_colors.dart';
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
  int? _tappedIndex;

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
    // homeController.loadCachedRoutes();

    profileController.loadCachedProfile();
    profileController.loadCurrentLanguage();
  }

  void _onItemTapped(int index) {
    setState(() {
      _tappedIndex = index;
    });
    
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _selectedIndex = index;
        _tappedIndex = null;
      });
      _refreshCurrentTab(index);
    });
  }

  void _refreshCurrentTab(int index) {
    switch (index) {
      case 0:
        // Home tab - refresh HomeController
        try {
          homeController.fetchProfile();
          // homeController.loadCachedRoutes();
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
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
        decoration: BoxDecoration(
          color: navBarBgColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: AppImages.icHome,
                  label: 'Home'.tr,
                ),
                _buildNavItem(
                  index: 1,
                  icon: AppImages.icTicket,
                  label: 'Ticket'.tr,
                ),
                _buildNavItem(
                  index: 2,
                  icon: AppImages.icProfile,
                  label: 'Profile'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    final isTapped = _tappedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: isTapped ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? goBusPrimary.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSvgImage(
                  path: icon,
                  width: 22,
                  height: 22,
                  color: isSelected ? goBusPrimary : black,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? goBusPrimary : black,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
