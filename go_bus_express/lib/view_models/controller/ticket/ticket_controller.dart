import 'dart:developer';

import 'package:go_bus_express/models/refund/refund_model.dart';
import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:go_bus_express/repository/refund_repository.dart';
import 'package:go_bus_express/repository/ticket_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/ticket/ticket_state.dart';
import 'package:shared_package/network/x_result.dart';

class TicketController extends BaseController<TicketState> {
  final TicketRepository _ticketRepository;
  final RefundRepository _refundRepository;

  TicketController(this._ticketRepository, this._refundRepository)
      : super(TicketState());

  @override
  void onInit() {
    log('TicketController onInit called');
    _fetchTickets();
    super.onInit();
  }

  void _fetchTickets() async {
    updateState((state) => state.copyWith(isLoading: true));
    await _fetchTicketsWithType(state.type);
  }

  Future<void> filterTickets({required bool isUpcoming}) async {
    final newType = isUpcoming ? "INCOMING" : "PASS";
    log('Filtering tickets - type: $newType');
    updateState((state) => state.copyWith(type: newType, isLoading: true));
    await _fetchTicketsWithType(newType);
  }

  Future<void> _fetchTicketsWithType(String type) async {
    log('Fetching tickets with type: $type');
    try {
      final result = await _ticketRepository.getTicket(type: type);
      switch (result) {
        case Success<TicketModel?>():
          final items = result.data?.content ?? [];
          log('Total ticket items: ${items.length}');
          final user = items.isNotEmpty
              ? items.first.bookingDetailResponse?.user ?? const User()
              : const User();
          updateState((state) => state.copyWith(
                tickets: items,
                user: user,
                isLoading: false,
              ));
          break;
        case Error<TicketModel?>():
          log('Error fetching tickets: ${result.error.displayMessage}');
          updateState((state) => state.copyWith(tickets: [], isLoading: false));
          break;
      }
    } catch (e) {
      log('Exception in _fetchTicketsWithType: $e');
      updateState((state) => state.copyWith(tickets: [], isLoading: false));
    }
  }

  List<TicketItem> getCurrentTickets() {
    log('getCurrentTickets: ${state.tickets.length} items for type: ${state.type}');
    return state.tickets;
  }

  Future<bool> requestRefund({
    required int bookingId,
    required String reason,
    required String method,
  }) async {
    log('Requesting refund for booking $bookingId, reason=$reason, method=$method');
    updateState((s) => s.copyWith(isRefunding: true, clearRefundError: true, refundSuccess: false));
    try {
      final result = await _refundRepository.requestRefund(
        bookingId: bookingId,
        reason: reason,
        method: method,
      );
      switch (result) {
        case Success<RefundModel?>():
          log('Refund requested for booking $bookingId');
          updateState((s) => s.copyWith(isRefunding: false, refundSuccess: true));
          return true;
        case Error<RefundModel?>():
          final msg = result.error.displayMessage;
          log('Refund request failed: $msg');
          updateState((s) => s.copyWith(isRefunding: false, refundError: msg));
          return false;
      }
    } catch (e) {
      log('Refund exception: $e');
      updateState((s) => s.copyWith(isRefunding: false, refundError: e.toString()));
      return false;
    }
  }
}
