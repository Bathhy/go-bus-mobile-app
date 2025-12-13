import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:shared_package/design_system/x_widget/user_profile_card.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/booking_card.dart';
import 'widgets/fast_booking_section.dart';
import 'widgets/promotions_section.dart';
import 'widgets/need_help_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = getIt<HomeController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppBar(),
              const SizedBox(height: 16),
              Obx(() {
                if (homeController.state.profileModel != null) {
                  return UserProfileCard(
                    name: homeController.state.profileModel!.fullName ?? "NA",
                    email: homeController.state.profileModel!.email ?? "NA",
                    onTap: () {
                      // Handle profile tap
                    },
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 16),
              const BookingCard(),
              const SizedBox(height: 16),
              const FastBookingSection(),
              const SizedBox(height: 16),
              const PromotionsSection(),
              const SizedBox(height: 16),
              const NeedHelpSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
