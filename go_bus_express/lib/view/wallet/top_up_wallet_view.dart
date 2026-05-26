import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';

class TopUpWalletView extends StatefulWidget {
  const TopUpWalletView({super.key});

  @override
  State<TopUpWalletView> createState() => _TopUpWalletViewState();
}

class _TopUpWalletViewState extends State<TopUpWalletView>
    with SingleTickerProviderStateMixin {
  final _walletController = getIt<WalletController>();
  final _amountController = TextEditingController();
  double? _selectedAmount = 20;
  final _quickAmounts = [10.0, 20.0, 50.0, 100.0];

  // ── Shimmer animation ──────────────────────────────────────────────────────
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnim;

  bool get _isButtonEnabled {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount > 0;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _amountController.text = '20.00';

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _amountController.addListener(_onAmountChanged);
    // Initial amount is 20 → start shimmer right away
    if (_isButtonEnabled) _shimmerController.repeat();
  }

  void _onAmountChanged() {
    if (_isButtonEnabled) {
      if (!_shimmerController.isAnimating) _shimmerController.repeat();
    } else {
      if (_shimmerController.isAnimating) {
        _shimmerController.stop();
        _shimmerController.value = 0;
      }
    }
    setState(() {});
  }

  void _onConfirmPressed() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    Get.toNamed(
      AppRoutes.walletTopUpKhqr,
      arguments: {'amount': amount},
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shimerBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: XAppBar(
          title: 'top_up_wallet'.tr,
          onBackPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(XPadding.extralarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceCard(),
                    SizedBox(height: XPadding.extralarge),

                    // ── Amount ─────────────────────────────────────────
                    Text(
                      'enter_amount'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E2228),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAmountInput(),
                    const SizedBox(height: 12),
                    _buildQuickAmountRow(),
                    SizedBox(height: XPadding.extralarge),

                    // ── Payment Method ─────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'select_payment_method'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E2228),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: goBusPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'one_option_available'.tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: goBusPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentMethodCard(),
                    const SizedBox(height: 14),
                    _buildInfoCard(),
                  ],
                ),
              ),
            ),

            // ── Confirm Button ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                XPadding.extralarge,
                12,
                XPadding.extralarge,
                XPadding.extralarge,
              ),
              child: _buildConfirmButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────────────────────────────

  Widget _buildBalanceCard() {
    return Obx(() {
      final balance = _walletController.state.wallet?.balance ?? 0.0;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E8EE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: goBusPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: goBusPrimary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total_balance'.tr,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: Color(0xFF8D94A0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: goBusPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E8EE)),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        onChanged: (value) {
          final parsed = double.tryParse(value);
          setState(() {
            _selectedAmount = parsed != null
                ? _quickAmounts.where((a) => a == parsed).firstOrNull
                : null;
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixText: '\$  ',
          prefixStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: goBusPrimary,
          ),
          hintText: '0.00',
          hintStyle: const TextStyle(color: Color(0xFFBCC0C8)),
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: goBusPrimary,
        ),
      ),
    );
  }

  Widget _buildQuickAmountRow() {
    return Row(
      children: _quickAmounts.asMap().entries.map((entry) {
        final index = entry.key;
        final amount = entry.value;
        final isSelected = _selectedAmount == amount;
        final isLast = index == _quickAmounts.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedAmount = amount;
                _amountController.text = amount.toStringAsFixed(0);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? goBusPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? goBusPrimary : const Color(0xFFE5E8EE),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: goBusPrimary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF4A5160),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: goBusPrimary, width: 2),
        boxShadow: [
          BoxShadow(
            color: goBusPrimary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              AppImages.imgBakong,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bakong'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF151A21),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'bakong_payment_subtitle'.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8D94A0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: goBusPrimary,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0E4F7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: goBusPrimary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info_outline, color: goBusPrimary, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'bakong_info_message'.tr,
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Color(0xFF4F5662),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Confirm button with shimmer sweep ──────────────────────────────────────

  Widget _buildConfirmButton() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, _) {
        final enabled = _isButtonEnabled;

        // Pulsing glow: sine wave on top of a base opacity
        final glowOpacity = enabled
            ? 0.22 + 0.10 * math.sin(_shimmerController.value * 2 * math.pi)
            : 0.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: goBusPrimary.withOpacity(glowOpacity),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // ── Base button ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        enabled ? goBusPrimary : const Color(0xFFCDD0D6),
                    disabledBackgroundColor: const Color(0xFFCDD0D6),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color(0xFF9DA3AD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: enabled ? _onConfirmPressed : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'confirm_payment'.tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 22),
                    ],
                  ),
                ),
              ),

              // ── Shimmer sweep overlay (enabled only) ─────────────────
              if (enabled)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: IgnorePointer(child: _buildShimmerSweep()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Paints a translucent white gradient strip that slides left → right.
  Widget _buildShimmerSweep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final stripWidth = totalWidth * 0.44;

        // _shimmerAnim.value: -1.0 → 2.0  →  map to pixel offset
        final progress = (_shimmerAnim.value + 1.0) / 3.0; // 0.0 → 1.0
        final left = progress * (totalWidth + stripWidth) - stripWidth;

        return Stack(
          children: [
            Positioned(
              left: left,
              top: 0,
              bottom: 0,
              width: stripWidth,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.30),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
