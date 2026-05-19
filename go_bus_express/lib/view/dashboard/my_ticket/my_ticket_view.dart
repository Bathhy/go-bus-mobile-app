import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
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

  Future<void> _showRefundConfirmDialog(int bookingId, double amount) async {
    final amountStr = amount.toStringAsFixed(2);
    final message = 'confirm_refund_message'.tr.replaceAll(
      '@amount',
      amountStr,
    );

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvgImage(
                path: AppImages.icRefund,
                height: 50,
                width: 50,
                color: Colors.orange.shade600,
              ),
              const SizedBox(height: 20),
              Text(
                'confirm_refund_title'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
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
                      onPressed: () => Navigator.of(ctx).pop(true),
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
                        'confirm'.tr,
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
      ),
    );

    if (confirmed == true && mounted) {
      _showRefundLoadingDialog();
      final success = await _ticketController.requestRefund(
        bookingId: bookingId,
        amount: amount,
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
                  if (isUpcoming &&
                      _canRequestRefund(booking?.bookingStatus)) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final bid = booking?.id;
                          final amount = booking?.totalAmount ?? 0.0;
                          if (bid != null) {
                            _showRefundConfirmDialog(bid, amount);
                          }
                        },
                        // icon: const Icon(
                        //   Icons.assignment_return_outlined,
                        //   size: 16,
                        // ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                  if (isUpcoming &&
                      !_canRequestRefund(booking?.bookingStatus)) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_top_rounded,
                              size: 16,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'refund_requested'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
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

  bool _canRequestRefund(String? bookingStatus) {
    const nonRefundableStatuses = {
      'REFUND_REQUESTED',
      'REFUNDED',
      'CANCELLED',
      'REJECTED',
    };
    return !nonRefundableStatuses.contains(bookingStatus);
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
