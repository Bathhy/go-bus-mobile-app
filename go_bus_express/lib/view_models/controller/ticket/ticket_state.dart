import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class TicketState extends BaseUiState {
  final String type;
  final List<TicketModel> tickets;
  final User user;

  TicketState({
    this.type = "coming",
    this.tickets = const [],
    this.user = const User(),
    super.isLoading = false,
  });

  TicketState copyWith({
    String? type,
    List<TicketModel>? tickets,
    bool? isLoading,
    User? user,
  }) {
    return TicketState(
      type: type ?? this.type,
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}
