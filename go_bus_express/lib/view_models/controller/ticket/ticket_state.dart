import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class TicketState extends BaseUiState {
  final String type;
  final List<TicketModel> tickets;

  TicketState({this.type = "coming", this.tickets = const []});

  TicketState copyWith({String? type, List<TicketModel>? tickets}) {
    return TicketState(
      type: type ?? this.type,
      tickets: tickets ?? this.tickets,
    );
  }
}
