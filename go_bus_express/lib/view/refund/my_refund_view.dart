import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/refund/refund_model.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/refund/refund_controller.dart';
import 'package:shared_package/config/themes.dart';

List<_TabItem> _getTabs() => [
  _TabItem(label: 'all'.tr, status: null),
  _TabItem(label: 'status_pending'.tr, status: 'PENDING'),
  _TabItem(label: 'status_approved'.tr, status: 'APPROVED'),
  _TabItem(label: 'status_rejected'.tr, status: 'REJECTED'),
  _TabItem(label: 'status_completed'.tr, status: 'COMPLETED'),
];

class _TabItem {
  final String label;
  final String? status;
  const _TabItem({required this.label, required this.status});
}

class MyRefundView extends StatefulWidget {
  const MyRefundView({super.key});

  @override
  State<MyRefundView> createState() => _MyRefundViewState();
}

class _MyRefundViewState extends State<MyRefundView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final RefundController _controller;
  late final AnimationController _shimmerController;
  bool _isTabSwitching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getTabs().length, vsync: this);
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _controller = Get.put(getIt<RefundController>());

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _isTabSwitching = true);
        _controller.filterByStatus(_getTabs()[_tabController.index].status).then((_) {
          if (mounted) setState(() => _isTabSwitching = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _shimmerController.dispose();
    if (Get.isRegistered<RefundController>()) {
      Get.delete<RefundController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: goBusPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'my_refunds'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: goBusPrimary,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: goBusPrimary,
                        indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 3.0, color: goBusPrimary),
                          insets: EdgeInsets.zero,
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: _getTabs().map((t) => Tab(text: t.label)).toList(),
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<RefundController>(
                        init: _controller,
                        builder: (controller) {
                          if (controller.state.isLoading || _isTabSwitching) {
                            return _buildShimmerList();
                          }
                          if (controller.state.error != null &&
                              controller.state.refunds.isEmpty) {
                            return _buildErrorState(controller.state.error!);
                          }
                          return _buildRefundList(
                            controller.state.refunds,
                            controller,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundList(
      List<RefundModel> refunds, RefundController controller) {
    if (refunds.isEmpty) return _buildEmptyState();

    return RefreshIndicator(
      color: goBusPrimary,
      backgroundColor: Colors.white,
      onRefresh: () => controller
          .filterByStatus(_getTabs()[_tabController.index].status),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: refunds.length,
        itemBuilder: (_, i) => _buildRefundCard(refunds[i]),
      ),
    );
  }

  Widget _buildRefundCard(RefundModel refund) {
    final origin = refund.route?.origin ?? 'N/A';
    final destination = refund.route?.destination ?? 'N/A';
    final seatCount = refund.booking?.seats?.length ?? 0;
    final createdAt = refund.createdAt;
    final dateStr = createdAt != null
        ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
        : 'N/A';
    final status = refund.status ?? '';
    final amount = refund.amount ?? 0.0;
    final bookingId = refund.booking?.id ?? refund.bookingId;

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.refundDetail,
        arguments: {'refundId': refund.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: goBusPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.currency_exchange,
                      color: goBusPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          origin != 'N/A' && destination != 'N/A'
                              ? '$origin → $destination'
                              : '${'refund'.tr} #${refund.id}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: Colors.grey.shade100),
              const SizedBox(height: 14),
              Row(
                children: [
                  if (seatCount > 0)
                    _buildInfoChip(Icons.event_seat_outlined,
                        '$seatCount ${'seat'.tr}${seatCount != 1 ? 's' : ''}'),
                  if (seatCount > 0) const SizedBox(width: 16),
                  _buildInfoChip(Icons.confirmation_number_outlined,
                      '#${bookingId ?? 'N/A'}'),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'refund_amount'.tr,
                        style: const TextStyle(fontSize: 11, color: Colors.black45),
                      ),
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: goBusPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (refund.reason != null && refund.reason!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: Colors.black38),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        refund.reason!,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final colors = _statusColors(status);
    final translationKey = 'status_${status.toLowerCase()}';
    final label = status.isEmpty
        ? 'N/A'
        : translationKey.tr != translationKey 
            ? translationKey.tr 
            : status[0] + status.substring(1).toLowerCase().replaceAll('_', ' ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.$2,
        ),
      ),
    );
  }

  (Color, Color) _statusColors(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return (Colors.green.shade50, Colors.green.shade700);
      case 'COMPLETED':
        return (Colors.blue.shade50, Colors.blue.shade700);
      case 'REJECTED':
        return (Colors.red.shade50, Colors.red.shade700);
      case 'PENDING':
        return (Colors.orange.shade50, Colors.orange.shade700);
      default:
        return (Colors.grey.shade100, Colors.grey.shade600);
    }
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black45),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: goBusPrimary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.currency_exchange,
                      size: 40, color: goBusPrimary.withOpacity(0.5)),
                ),
                const SizedBox(height: 20),
                Text(
                  'no_refunds_found'.tr,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  'refunds_appear_here'.tr,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'failed_to_load_refunds'.tr,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(error,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _controller.filterByStatus(
                  _getTabs()[_tabController.index].status),
              style: ElevatedButton.styleFrom(
                  backgroundColor: goBusPrimary, foregroundColor: Colors.white),
              child: Text('retry'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _shimmer(42, 42, radius: 21),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmer(double.infinity, 16, radius: 4),
                    const SizedBox(height: 6),
                    _shimmer(100, 12, radius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _shimmer(70, 26, radius: 13),
            ],
          ),
          const SizedBox(height: 14),
          _shimmer(double.infinity, 1, radius: 0),
          const SizedBox(height: 14),
          Row(
            children: [
              _shimmer(80, 14, radius: 4),
              const SizedBox(width: 16),
              _shimmer(80, 14, radius: 4),
              const Spacer(),
              _shimmer(60, 22, radius: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shimmer(double w, double h, {required double radius}) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: const Alignment(-1.0, -0.3),
            end: const Alignment(1.0, 0.3),
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
            stops: [
              0.0,
              0.5 + (_shimmerController.value * 0.5),
              1.0,
            ],
          ),
        ),
      ),
    );
  }
}
