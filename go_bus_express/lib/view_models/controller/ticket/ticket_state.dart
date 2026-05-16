import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class TicketState extends BaseUiState {
  final String type;
  final List<TicketItem> tickets;
  final User user;
  final bool isRefunding;
  final String? refundError;
  final bool refundSuccess;

  TicketState({
    this.type = "INCOMING",
    this.tickets = const [],
    this.user = const User(),
    super.isLoading = false,
    this.isRefunding = false,
    this.refundError,
    this.refundSuccess = false,
  });

  TicketState copyWith({
    String? type,
    List<TicketItem>? tickets,
    bool? isLoading,
    User? user,
    bool? isRefunding,
    String? refundError,
    bool? refundSuccess,
    bool clearRefundError = false,
  }) {
    return TicketState(
      type: type ?? this.type,
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isRefunding: isRefunding ?? this.isRefunding,
      refundError: clearRefundError ? null : (refundError ?? this.refundError),
      refundSuccess: refundSuccess ?? this.refundSuccess,
    );
  }
}
