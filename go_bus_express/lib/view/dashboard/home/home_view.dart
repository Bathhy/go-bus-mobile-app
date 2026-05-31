import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/payment/pending_payment_model.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';
import '../../../core/utils/image_helper.dart';
import '../../../resources/app_images.dart';
import '../../widget/x_dialog.dart';
import '../../widget/x_loading_dialog.dart';
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
  final WalletController _walletController = getIt<WalletController>();
  Worker? _stateWorker;
  late final ScrollController _scrollController;
  bool _isCollapsed = false;

  static const double _expandedHeight = 140;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPendingPayment();
    });
    _stateWorker = ever(homeController.obs, (state) {
      if (state.isLoading) {
        XAppLoadingDialog.showAppDialog();
      } else {
        XAppLoadingDialog.hideAppDialog();
      }
    });
  }

  void _onScroll() {
    final collapsed = _scrollController.hasClients &&
        _scrollController.offset > (_expandedHeight - kToolbarHeight - 8);
    if (collapsed != _isCollapsed) {
      setState(() => _isCollapsed = collapsed);
    }
  }

  void _checkAndShowPendingPayment() {
    if (homeController.hasPendingPayment()) {
      final pending = homeController.getPendingPayment();
      if (pending != null) {
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
              Text(
                'Pending Payment'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
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
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          homeController.resumePendingPayment(pending);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goBusPrimary,
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
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _stateWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: () => homeController.pullRefresh(),
        color: goBusPrimary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Modern Gradient App Bar
            SliverAppBar(
              expandedHeight: _expandedHeight,
              floating: false,
              pinned: true,
              backgroundColor: goBusPrimary,
              elevation: 0,
              titleSpacing: 0,
              title: _isCollapsed ? _buildCollapsedTitle() : null,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [goBusPrimary, goBusPrimary.withOpacity(0.8)],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello! 👋',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Obx(() {
                                      final name =
                                          homeController
                                              .state
                                              .profileModel
                                              ?.fullName ??
                                          'Guest';
                                      return Text(
                                        name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  _buildIconButton(
                                    Icons.telegram,
                                    () => homeController.openTelegram(),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildIconButton(
                                    Icons.phone,
                                    () => homeController.callPhone(),
                                  ),
                                  const SizedBox(width: 12),
                                  // Profile Picture
                                  Obx(() {
                                    final imageUrl = homeController.state.profileImageUrl ?? '';
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.white,
                                        backgroundImage: imageUrl.isNotEmpty
                                            ? NetworkImage(imageUrl)
                                            : null,
                                        child: imageUrl.isEmpty
                                            ? Icon(
                                                Icons.person,
                                                color: goBusPrimary,
                                                size: 24,
                                              )
                                            : null,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Quick Stats Card
                  _buildQuickStatsCard(),

                  const SizedBox(height: 20),

                  // Top Up Wallet Section
                  // TopUpWalletSection(
                  //   onAddMoney: (amount) => homeController.handleTopUpWallet(amount),
                  // ),
                  const SizedBox(height: 20),

                  // Booking Card
                  const BookingCard(),

                  const SizedBox(height: 24),

                  // Promotions Section
                  const PromotionsSection(),

                  const SizedBox(height: 24),

                  // Need Help Section
                  NeedHelpSection(
                    onTap: () => homeController.callPhone(),
                    onTapTelegram: () => homeController.openTelegram(),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
            SliverPadding(padding: EdgeInsetsGeometry.only(bottom: 55))
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final name = homeController.state.profileModel?.fullName ?? 'Guest';
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: XPadding.medium),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ),
          _buildIconButton(Icons.telegram, () => homeController.openTelegram()),
          const SizedBox(width: 8),
          _buildIconButton(Icons.phone, () => homeController.callPhone()),
          const SizedBox(width: 12),
          Obx(() {
            final imageUrl = homeController.state.profileImageUrl ?? '';
            return CircleAvatar(
              radius: 17,
              backgroundColor: Colors.white,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, color: goBusPrimary, size: 18)
                  : null,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Expanded(
            //   child: _buildStatItem(
            //     icon: Icons.confirmation_number_outlined,
            //     label: 'Total Trips'.tr,
            //     value: '0',
            //     color: const Color(0xFF4CAF50),
            //   ),
            // ),
            // Container(width: 1, height: 40, color: Colors.grey.shade200),
            Expanded(
              child: Obx(() {
                final wallet = _walletController.state.wallet;
                final isLoading = _walletController.state.isLoading;
                final balance = wallet?.balance;
                final valueText = isLoading
                    ? '...'
                    : balance != null
                        ? '\$${balance.toStringAsFixed(2)}'
                        : '--';
                return GestureDetector(
                  onTap: () {
                    final isWalletExist =
                        homeController.state.profileModel?.isWalletExist ??
                            false;
                    _walletController.navigateToWallet(
                      isWalletExist: isWalletExist,
                    );
                  },
                  child: _buildStatItem(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet'.tr,
                    value: valueText,
                    color: const Color(0xFF2196F3),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }


  Widget _buildActionCard({
    required String icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: AppSvgImage(
                path: icon,
                width: 28,
                height: 28,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
