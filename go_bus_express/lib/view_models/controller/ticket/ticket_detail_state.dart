import 'package:go_bus_express/models/ticket/ticket_detail_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class TicketDetailState extends BaseUiState {
  final TicketDetailModel? ticketDetail;
  final String? error;
  final int ticketId;
  final String? passengerName;
  final String? passengerEmail;

  TicketDetailState({
    this.ticketDetail,
    this.error,
    this.ticketId = 0,
    this.passengerName,
    this.passengerEmail,
    super.isLoading = false,
  });

  TicketDetailState copyWith({
    TicketDetailModel? ticketDetail,
    String? error,
    int? ticketId,
    String? passengerName,
    String? passengerEmail,
    bool? isLoading,
    bool clearError = false,
  }) {
    return TicketDetailState(
      ticketDetail: ticketDetail ?? this.ticketDetail,
      error: clearError ? null : (error ?? this.error),
      ticketId: ticketId ?? this.ticketId,
      passengerName: passengerName ?? this.passengerName,
      passengerEmail: passengerEmail ?? this.passengerEmail,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
