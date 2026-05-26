import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/wallet/wallet_transaction_model.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final WalletController _walletController = getIt<WalletController>();

  late final ScrollController _scrollController;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _walletController.fetchWalletMe(includeTransactions: true);
    });
  }

  /// Triggers next-page fetch when the user scrolls within 250 px of the end.
  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 250) {
      final s = _walletController.state;
      if (!s.isTransactionLoading && s.hasMorePages) {
        _walletController.fetchTransactions();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBgColor,
      appBar: AppBar(
        backgroundColor: goBusPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Wallet'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildTransactionHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Balance card ───────────────────────────────────────────────────────────

  Widget _buildBalanceCard() {
    return Obx(() {
      final wallet = _walletController.state.wallet;
      final balance = wallet?.balance ?? 0.0;
      final currency = wallet?.currency ?? 'USD';
      return Container(
        margin: EdgeInsets.all(XPadding.extralarge),
        padding: EdgeInsets.all(XPadding.extralarge + XPadding.medium),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [goBusPrimary, goBusPrimary.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: goBusPrimary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${balance.toStringAsFixed(2)} $currency',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ── Quick actions ──────────────────────────────────────────────────────────

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.add_circle_outline,
              label: 'Top Up'.tr,
              color: goBusPrimary,
              onTap: () => Get.toNamed(AppRoutes.topUpWallet),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: XPadding.large),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Transaction history ────────────────────────────────────────────────────

  Widget _buildTransactionHistory() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
            child: XTextLarge(
              label: 'Recent Transactions'.tr,
              colortext: black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final isLoading = _walletController.state.isTransactionLoading;
              final transactions = _walletController.state.transactions;
              final hasMore = _walletController.state.hasMorePages;
              final error = _walletController.state.transactionError;

              // ── Initial load skeleton ────────────────────────────────
              if (isLoading && transactions.isEmpty) {
                return _buildShimmerList();
              }

              // ── Empty error state ────────────────────────────────────
              if (error != null && transactions.isEmpty) {
                return _buildErrorState(error);
              }

              // ── Empty state ──────────────────────────────────────────
              if (transactions.isEmpty) {
                return _buildEmptyState();
              }

              // ── List with infinite scroll ────────────────────────────
              final showSpinner = isLoading;
              final itemCount =
                  transactions.length + (showSpinner ? 1 : 0);

              return RefreshIndicator(
                onRefresh: () =>
                    _walletController.fetchTransactions(reset: true),
                color: goBusPrimary,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    XPadding.extralarge,
                    0,
                    XPadding.extralarge,
                    XPadding.extralarge,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index < transactions.length) {
                      return _buildTransactionItem(transactions[index]);
                    }
                    // ── Pagination spinner ───────────────────────────────
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Shimmer skeleton ───────────────────────────────────────────────────────

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
        itemCount: 6,
        itemBuilder: (_, __) => _buildShimmerItem(),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(XPadding.large),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: XPadding.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 120, color: Colors.grey),
                const SizedBox(height: 8),
                Container(height: 12, width: 80, color: Colors.grey),
              ],
            ),
          ),
          Container(height: 14, width: 60, color: Colors.grey),
        ],
      ),
    );
  }

  // ── Empty / error states ───────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Transactions Yet'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transaction history will appear here'.tr,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Failed to load transactions'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => _walletController.fetchTransactions(reset: true),
            icon: const Icon(Icons.refresh),
            label: Text('Retry'.tr),
            style: TextButton.styleFrom(foregroundColor: goBusPrimary),
          ),
        ],
      ),
    );
  }

  // ── Transaction row ────────────────────────────────────────────────────────

  Widget _buildTransactionItem(WalletTransactionModel tx) {
    final typeConfig = _getTypeConfig(tx.type);
    final statusConfig = _getStatusConfig(tx.status);
    final isCredit = tx.isCredit;
    final amount = tx.amount ?? 0.0;
    final description =
        (tx.description != null && tx.description!.isNotEmpty)
            ? tx.description!
            : typeConfig.label;
    final dateStr = _formatDate(tx.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Type icon bubble ──────────────────────────────────────
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: typeConfig.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(typeConfig.icon, color: typeConfig.color, size: 24),
            ),
            const SizedBox(width: 12),

            // ── Middle: label + status chip + description + date ──────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type label + status badge on the same row
                  Row(
                    children: [
                      Text(
                        typeConfig.label.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(statusConfig),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Description (subdued)
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Date
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),

            // ── Right: amount + balance after ─────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCredit
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
                if (tx.balanceAfter != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      'Bal \$${tx.balanceAfter!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Small pill badge for transaction status.
  Widget _buildStatusChip(_TransactionStatusConfig cfg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cfg.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: cfg.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            cfg.label.tr,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: cfg.color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Config helpers ─────────────────────────────────────────────────────────

  /// Maps backend TransactionType enum → icon, accent color, display label.
  _TransactionTypeConfig _getTypeConfig(String? type) {
    switch (type) {
      case 'TOP_UP':
        return _TransactionTypeConfig(
          Icons.account_balance_wallet_rounded,
          const Color(0xFF3B82F6), // blue
          'Top Up',
        );
      case 'PAYMENT':
        return _TransactionTypeConfig(
          Icons.directions_bus_rounded,
          const Color(0xFFF97316), // orange
          'Payment',
        );
      case 'REFUND':
        return _TransactionTypeConfig(
          Icons.replay_rounded,
          const Color(0xFF10B981), // teal-green
          'Refund',
        );
      case 'WITHDRAWAL':
        return _TransactionTypeConfig(
          Icons.outbox_rounded,
          const Color(0xFFEF4444), // red
          'Withdrawal',
        );
      case 'BONUS':
        return _TransactionTypeConfig(
          Icons.card_giftcard_rounded,
          const Color(0xFF8B5CF6), // purple
          'Bonus',
        );
      default:
        return _TransactionTypeConfig(
          Icons.swap_horiz_rounded,
          Colors.grey,
          'Transaction',
        );
    }
  }

  /// Maps backend TransactionStatus enum → dot color, display label.
  _TransactionStatusConfig _getStatusConfig(String? status) {
    switch (status) {
      case 'COMPLETED':
        return _TransactionStatusConfig(const Color(0xFF10B981), 'Completed');
      case 'PENDING':
        return _TransactionStatusConfig(const Color(0xFFF59E0B), 'Pending');
      case 'FAILED':
        return _TransactionStatusConfig(const Color(0xFFEF4444), 'Failed');
      case 'CANCELLED':
        return _TransactionStatusConfig(Colors.grey, 'Cancelled');
      default:
        return _TransactionStatusConfig(Colors.grey, status ?? '-');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(dt.toLocal());
    } catch (_) {
      return dateStr;
    }
  }
}

// ── Config value objects ───────────────────────────────────────────────────

class _TransactionTypeConfig {
  final IconData icon;
  final Color color;
  final String label;
  const _TransactionTypeConfig(this.icon, this.color, this.label);
}

class _TransactionStatusConfig {
  final Color color;
  final String label;
  const _TransactionStatusConfig(this.color, this.label);
}
