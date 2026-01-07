import 'dart:developer';

import 'package:go_bus_express/models/ticket/ticket_detail_model.dart';
import 'package:go_bus_express/repository/ticket_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/ticket/ticket_detail_state.dart';
import 'package:shared_package/network/x_result.dart';

class TicketDetailController extends BaseController<TicketDetailState> {
  final TicketRepository _ticketDetailRepository;

  TicketDetailController(this._ticketDetailRepository)
    : super(TicketDetailState());

  @override
  void onInit() {
    log('🚀 TicketDetailController onInit called');
    super.onInit();
  }

  // Method to initialize with route arguments
  void initializeWithArguments(Map<String, dynamic>? args) {
    if (args == null) {
      log('⚠️ No arguments provided to TicketDetailController');
      return;
    }

    final ticketId = args['ticketId'] as int? ?? 0;
    final passengerName = args['passengerName'] as String?;
    final passengerEmail = args['email'] as String?;

    log('📋 Initializing with arguments: ticketId=$ticketId, passengerName=$passengerName, email=$passengerEmail');

    updateState((state) => state.copyWith(
      ticketId: ticketId,
      passengerName: passengerName,
      passengerEmail: passengerEmail,
    ));

    // Fetch ticket details
    fetchTicketDetail(ticketId: ticketId);
  }

  // Method to fetch ticket detail by ID
  Future<void> fetchTicketDetail({required int ticketId}) async {
    log('📡 Fetching ticket detail with ID: $ticketId');

    // Set loading state and clear any previous errors
    updateState((state) => state.copyWith(isLoading: true, clearError: true));

    try {
      final result = await _ticketDetailRepository.getTicketDetail(
        id: ticketId,
      );

      switch (result) {
        case Success<TicketDetailModel?>():
          log('✅ Ticket detail fetched successfully');
          final ticketDetail = result.data;
          if (ticketDetail != null) {
            log('📊 Ticket detail loaded: ID ${ticketDetail.id}');
            updateState(
              (state) =>
                  state.copyWith(ticketDetail: ticketDetail, isLoading: false),
            );
          } else {
            log('⚠️ Received null ticket detail');
            updateState(
              (state) => state.copyWith(ticketDetail: null, isLoading: false),
            );
          }
          break;
        case Error<TicketDetailModel?>():
          log('❌ Error fetching ticket detail: ${result.error.displayMessage}');
          updateState(
            (state) => state.copyWith(
              isLoading: false,
              error: result.error.displayMessage,
            ),
          );
          break;
      }
    } catch (e) {
      log('💥 Exception in fetchTicketDetail: $e');
      updateState(
        (state) => state.copyWith(
          isLoading: false,
          error: 'Failed to load ticket details',
        ),
      );
    }
  }

  // Helper method to get route information
  String getRouteInfo() {
    final route = state.ticketDetail?.booking?.schedule?.bus?.route;
    if (route?.origin != null && route?.destination != null) {
      return '${route!.origin} - ${route.destination}';
    }
    return 'Route information not available';
  }

  // Helper method to get bus information
  String getBusInfo() {
    final bus = state.ticketDetail?.booking?.schedule?.bus;
    if (bus?.busType != null && bus?.busNumber != null) {
      return '${bus!.busType} (${bus.busNumber})';
    }
    return 'Bus information not available';
  }

  // Helper method to get pricing information
  Map<String, String> getPricingInfo() {
    final totalAmount = state.ticketDetail?.booking?.totalAmount;
    final price = totalAmount?.toString() ?? '0';

    return {
      'price': price,
      'discount': '0', // TODO: Add discount field to model if available
      'total': price,
    };
  }

  // Helper method to clear error state
  void clearError() {
    updateState((state) => state.copyWith(clearError: true));
  }

  // Helper method to get passenger name
  String getPassengerName() {
    return state.passengerName ?? 'N/A';
  }

  // Helper method to get passenger email
  String getPassengerEmail() {
    return state.passengerEmail ?? 'N/A';
  }
}
