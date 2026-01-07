import 'dart:developer';

import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:go_bus_express/repository/ticket_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/ticket/ticket_state.dart';
import 'package:shared_package/network/x_result.dart';

class TicketController extends BaseController<TicketState> {
  final TicketRepository _ticketRepository;

  TicketController(this._ticketRepository) : super(TicketState());

  @override
  void onInit() {
    log('🚀 TicketController onInit called');
    _fetchTickets();
    super.onInit();
  }

  void _fetchTickets() async {
    // Set loading state before fetching
    updateState((state) => state.copyWith(isLoading: true));
    await _fetchTicketsWithType(state.type);
  }

  // Helper method to get all ticket data items
  List<Datum> getAllTicketData() {
    final allData = state.tickets
        .expand((ticketModel) => ticketModel.data ?? <Datum>[])
        .toList();
    log('🎫 getAllTicketData: ${allData.length} items');
    return allData;
  }

  // Method to filter tickets by calling API with appropriate type
  Future<void> filterTickets({required bool isUpcoming}) async {
    final newType = isUpcoming ? "coming" : "pass";

    log('🔄 Filtering tickets with API call - type: $newType');

    // Update state with new type and set loading
    updateState((state) => state.copyWith(type: newType, isLoading: true));

    // Fetch tickets with new type
    await _fetchTicketsWithType(newType);
  }

  Future<void> _fetchTicketsWithType(String type) async {
    log('📡 Fetching tickets with type: $type');

    try {
      final result = await _ticketRepository.getTicket(type: type);

      switch (result) {
        case Success<TicketModel?>():
          log(
            '✅ Tickets fetched successfully: ${result.data != null ? 1 : 0} ticket model',
          );
          final ticketModel = result.data;
          if (ticketModel != null) {
            final ticketDataItems = ticketModel.data ?? [];
            log('📊 Total ticket data items: ${ticketDataItems.length}');
            updateState((state) => state.copyWith(
              tickets: [ticketModel], 
              isLoading: false,
            ));
          } else {
            log('⚠️ Received null ticket model');
            updateState((state) => state.copyWith(
              tickets: [], 
              isLoading: false,
            ));
          }
          break;
        case Error<TicketModel?>():
          log('❌ Error fetching tickets: ${result.error.displayMessage}');
          // Clear tickets when there's an error to prevent showing stale data
          updateState((state) => state.copyWith(
            tickets: [], 
            isLoading: false,
          ));
          break;
      }
    } catch (e) {
      log('💥 Exception in _fetchTicketsWithType: $e');
      // Clear tickets when there's an exception to prevent showing stale data
      updateState((state) => state.copyWith(
        tickets: [], 
        isLoading: false,
      ));
    }
  }

  // Helper method to get current filtered tickets (now returns current state tickets)
  List<Datum> getCurrentTickets() {
    final allData = state.tickets
        .expand((ticketModel) => ticketModel.data ?? <Datum>[])
        .toList();
    log(
      '🎫 getCurrentTickets: ${allData.length} items for type: ${state.type}',
    );
    return allData;
  }
}
