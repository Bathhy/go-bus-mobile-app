import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/payment/pending_payment_model.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:shared_package/design_system/x_widget/user_profile_card.dart';
import '../../widget/x_dialog.dart';
import '../../widget/x_loading_dialog.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/booking_card.dart';
import 'widgets/promotions_section.dart';
import 'widgets/need_help_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final HomeController homeController = getIt<HomeController>();

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPendingPayment();
    });
  }

  void _checkAndShowPendingPayment() {
    if (homeController.hasPendingPayment()) {
      final pending = homeController.getPendingPayment();
      if (pending != null) {
        // Check if payment is already expired
        log("Timer is Expired${pending.isExpired()}");
        if (pending.isExpired()) {
          XDialog.showTimeoutDialog(
            context,
            () => homeController.cancelPendingPayment(pending.bookingId),
          );
        } else {
          _showPendingPaymentDialog(pending);
        }
      }
    }
  }

  void _showPendingPaymentDialog(PendingPaymentModel pending) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Container
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: Colors.orange.shade400,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Pending Payment'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Payment Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You have an incomplete payment:'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Booking ID'.tr, '#${pending.bookingId}'),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Amount'.tr,
                      '\$${pending.amount.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Message
              Text(
                'Would you like to continue or cancel this payment?'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  // Cancel Payment Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          homeController.cancelPendingPayment(
                            pending.bookingId,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade600,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.red.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Continue Payment Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          homeController.resumePendingPayment(pending);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Pay Now'.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => homeController.pullRefresh(),
          color: const Color(0xFF4CAF50),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(
                  onTap: () => homeController.callPhone(),
                  onTapTelegram: () => homeController.openTelegram(),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (homeController.state.profileModel != null) {
                    return UserProfileCard(
                      name: homeController.state.profileModel!.fullName ?? "NA",
                      email: homeController.state.profileModel!.email ?? "NA",
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 16),
                const BookingCard(),
                const SizedBox(height: 16),
                const PromotionsSection(),
                const SizedBox(height: 16),
                NeedHelpSection(
                  onTap: () => homeController.callPhone(),
                  onTapTelegram: () => homeController.openTelegram(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
