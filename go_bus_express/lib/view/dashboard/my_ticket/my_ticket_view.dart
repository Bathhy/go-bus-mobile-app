import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/models/refund/refund_request.dart';
import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/ticket/ticket_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';

class MyTicketView extends StatefulWidget {
  const MyTicketView({super.key});

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TicketController _ticketController;
  late AnimationController _skeletonAnimationController;

  String _translate(String key, {String? fallback}) {
    try {
      if (Get.locale == null) return fallback ?? key;
      final translated = key.tr;
      return translated != key ? translated : (fallback ?? key);
    } catch (e) {
      debugPrint('Translation error for key "$key": $e');
      return fallback ?? key;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _skeletonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _ticketController = Get.put(getIt<TicketController>());

    _skeletonAnimationController.repeat();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final isUpcoming = _tabController.index == 0;
        _ticketController.filterTickets(isUpcoming: isUpcoming);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ticketController.onInit();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _skeletonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final isUpcoming = _tabController.index == 0;
    await _ticketController.filterTickets(isUpcoming: isUpcoming);
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
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _translate('Ticket', fallback: 'Ticket'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                        labelColor: goBusPrimary,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: goBusPrimary,
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 4.0,
                            color: goBusPrimary,
                          ),
                          insets: const EdgeInsets.symmetric(horizontal: 0),
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(text: 'upcoming'.tr),
                          Tab(text: 'past'.tr),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<TicketController>(
                        init: _ticketController,
                        builder: (controller) {
                          final currentTickets = controller.getCurrentTickets();

                          print(
                            '🎫 Current tickets in UI: ${currentTickets.length}, type: ${controller.state.type}',
                          );

                          if (controller.state.tickets.isEmpty &&
                              controller.state.isLoading) {
                            return _buildSkeletonLoading();
                          }

                          return TabBarView(
                            controller: _tabController,
                            children: [
                              _buildCurrentTicketTab(
                                controller,
                                'no_upcoming_trips'.tr,
                                'upcoming_trips_description'.tr,
                                isUpcoming: true,
                              ),
                              _buildCurrentTicketTab(
                                controller,
                                'no_past_trips'.tr,
                                'past_trips_description'.tr,
                                isUpcoming: false,
                              ),
                            ],
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

  Widget _buildCurrentTicketTab(
    TicketController controller,
    String emptyTitle,
    String emptySubtitle, {
    required bool isUpcoming,
  }) {
    final expectedType = isUpcoming ? "INCOMING" : "PASS";
    final currentType = controller.state.type;
    final tickets = controller.getCurrentTickets();
    final user = controller.state.user;
    final isLoading = controller.state.isLoading;

    print(
      '🔍 Tab check - Expected: $expectedType, Current: $currentType, Tickets: ${tickets.length}, Loading: $isLoading',
    );

    if (isLoading || currentType != expectedType) {
      print(
        '⏳ Loading or waiting for $expectedType data, current type is $currentType',
      );
      return _buildSkeletonLoading();
    }

    return RefreshIndicator(
      backgroundColor: white,
      onRefresh: _handleRefresh,
      color: goBusPrimary,
      child: tickets.isNotEmpty
          ? _buildTicketList(tickets, user, isUpcoming: isUpcoming)
          : _buildEmptyState(emptyTitle, emptySubtitle),
    );
  }

  Widget _buildTicketList(
    List<TicketItem> tickets,
    User user, {
    required bool isUpcoming,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return _buildTicketCard(tickets[index], user, isUpcoming: isUpcoming);
      },
    );
  }

  void _showRefundLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'processing_refund'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'please_wait'.tr,
                style: const TextStyle(fontSize: 13, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRefundRequestDialog(int bookingId) async {
    final reasonController = TextEditingController();
    RefundMethod selectedMethod = RefundMethod.manual;

    final result = await showDialog<({String reason, RefundMethod method})>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          Widget methodOption(RefundMethod method, String label, IconData icon) {
            final isSelected = selectedMethod == method;
            return Expanded(
              child: GestureDetector(
                onTap: () => setDialogState(() => selectedMethod = method),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orange.shade50
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.orange.shade600
                          : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        size: 24,
                        color: isSelected
                            ? Colors.orange.shade700
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.orange.shade700
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AppSvgImage(
                      path: AppImages.icRefund,
                      height: 50,
                      width: 50,
                      color: Colors.orange.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'confirm_refund_title'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'refund_reason'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    minLines: 2,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'refund_reason_hint'.tr,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'refund_method'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      methodOption(
                        RefundMethod.manual,
                        'refund_method_manual'.tr,
                        Icons.account_balance_outlined,
                      ),
                      const SizedBox(width: 12),
                      methodOption(
                        RefundMethod.wallet,
                        'refund_method_wallet'.tr,
                        Icons.account_balance_wallet_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final reason = reasonController.text.trim();
                            if (reason.isEmpty) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('refund_reason_required'.tr),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            Navigator.of(ctx).pop(
                              (reason: reason, method: selectedMethod),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'submit'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

    WidgetsBinding.instance.addPostFrameCallback((_) => reasonController.dispose());

    if (result != null && mounted) {
      _showRefundLoadingDialog();
      final success = await _ticketController.requestRefund(
        bookingId: bookingId,
        reason: result.reason,
        method: result.method.key,
      );
      if (!mounted) return;
      Navigator.of(context).pop(); // dismiss loading dialog
      if (success) {
        await _ticketController.filterTickets(isUpcoming: true);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'refund_success'.tr : 'refund_failed'.tr,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildTicketCard(
    TicketItem ticket,
    User user, {
    required bool isUpcoming,
  }) {
    final booking = ticket.bookingDetailResponse;
    final routeText = _getRouteText(ticket);
    final bookingId = booking?.id?.toString() ?? 'N/A';
    final issueDate = _formatDate(ticket.issuedAt);
    final busInfo = _getBusInfo(ticket);
    final seatCount = booking?.seats?.length ?? 0;

    return GestureDetector(
      onTap: () {
        if (ticket.id != null) {
          Get.toNamed(
            AppRoutes.detailTicket,
            arguments: {
              "ticketId": ticket.id!,
              "passengerName": booking?.user?.fullName ?? user.fullName,
              "email": booking?.user?.email ?? user.email,
            },
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: goBusPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.directions_bus,
                      color: goBusPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      routeText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.receipt_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '#$bookingId',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      issueDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.airport_shuttle_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    busInfo,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.event_seat_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$seatCount ${'seat'.tr}${seatCount != 1 ? '' : ''}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (ticket.id != null) {
                          AppRoutes.goToTicketDetail(
                            ticketId: ticket.id!,
                            passengerName:
                                booking?.user?.fullName ?? user.fullName,
                            email: booking?.user?.email ?? user.email,
                          );
                        }
                      },
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: Text('see_details'.tr),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (isUpcoming) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildRefundSection(
                        booking?.refundStatus,
                        booking?.id,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefundSection(String? refundStatus, int? bookingId) {
    // null → user hasn't requested a refund yet → show the button
    if (refundStatus == null) {
      return OutlinedButton.icon(
        onPressed: () {
          if (bookingId != null) _showRefundRequestDialog(bookingId);
        },
        icon: AppSvgImage(
          path: AppImages.icRefund,
          height: 16,
          width: 16,
          color: Colors.red,
        ),
        label: Text('request_refund'.tr),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      );
    }

    final config = _refundStatusConfig(refundStatus);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(config.icon, size: 16, color: config.textColor),
          const SizedBox(width: 6),
          Text(
            config.label.tr,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  ({
    Color bgColor,
    Color borderColor,
    Color textColor,
    IconData icon,
    String label,
  }) _refundStatusConfig(String refundStatus) {
    switch (refundStatus) {
      case 'PENDING':
        return (
          bgColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade200,
          textColor: Colors.orange.shade700,
          icon: Icons.hourglass_top_rounded,
          label: 'refund_pending',
        );
      case 'APPROVED':
        return (
          bgColor: Colors.blue.shade50,
          borderColor: Colors.blue.shade200,
          textColor: Colors.blue.shade700,
          icon: Icons.check_circle_outline_rounded,
          label: 'refund_approved',
        );
      case 'COMPLETED':
        return (
          bgColor: Colors.green.shade50,
          borderColor: Colors.green.shade200,
          textColor: Colors.green.shade700,
          icon: Icons.task_alt_rounded,
          label: 'refund_completed',
        );
      case 'REJECTED':
        return (
          bgColor: Colors.red.shade50,
          borderColor: Colors.red.shade200,
          textColor: Colors.red.shade700,
          icon: Icons.cancel_outlined,
          label: 'refund_rejected',
        );
      default:
        return (
          bgColor: Colors.grey.shade50,
          borderColor: Colors.grey.shade200,
          textColor: Colors.grey.shade700,
          icon: Icons.info_outline,
          label: refundStatus,
        );
    }
  }

  String _getRouteText(TicketItem ticket) {
    final schedule = ticket.bookingDetailResponse?.schedule;
    final origin = schedule?.origin ?? '';
    final destination = schedule?.destination ?? '';

    if (origin.isNotEmpty && destination.isNotEmpty) {
      return '$origin - $destination';
    }
    return 'route_not_available'.tr;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getBusInfo(TicketItem ticket) {
    final schedule = ticket.bookingDetailResponse?.schedule;
    final busNumber = schedule?.busNumber ?? '';
    if (busNumber.isNotEmpty) return busNumber;
    return 'bus_info_not_available'.tr;
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_trip.png',
                      width: 240,
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.luggage_outlined,
                          size: 80,
                          color: goBusPrimary,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoading() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildSkeletonCard();
        },
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
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
                _buildShimmerContainer(width: 40, height: 40, borderRadius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildShimmerContainer(
                    width: double.infinity,
                    height: 20,
                    borderRadius: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildShimmerContainer(width: 16, height: 16, borderRadius: 2),
                const SizedBox(width: 8),
                _buildShimmerContainer(width: 80, height: 14, borderRadius: 4),
                const SizedBox(width: 20),
                _buildShimmerContainer(width: 16, height: 16, borderRadius: 2),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildShimmerContainer(
                    width: double.infinity,
                    height: 14,
                    borderRadius: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildShimmerContainer(width: 16, height: 16, borderRadius: 2),
                const SizedBox(width: 8),
                _buildShimmerContainer(width: 100, height: 14, borderRadius: 4),
                const SizedBox(width: 20),
                _buildShimmerContainer(width: 16, height: 16, borderRadius: 2),
                const SizedBox(width: 8),
                _buildShimmerContainer(width: 60, height: 14, borderRadius: 4),
              ],
            ),
            const SizedBox(height: 16),
            _buildShimmerContainer(
              width: double.infinity,
              height: 40,
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    required double borderRadius,
  }) {
    return AnimatedBuilder(
      animation: _skeletonAnimationController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0, -0.3),
              end: Alignment(1.0, 0.3),
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
              stops: [
                0.0,
                0.5 + (_skeletonAnimationController.value * 0.5),
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}
