import 'package:go_bus_express/models/ticket/ticket_detail_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';

class TicketDetailState extends BaseUiState {
  final TicketDetailModel? ticketDetail;
  final String? error;

  TicketDetailState({
    this.ticketDetail,
    this.error,
    super.isLoading = false,
  });

  TicketDetailState copyWith({
    TicketDetailModel? ticketDetail,
    String? error,
    bool? isLoading,
    bool clearError = false,
  }) {
    return TicketDetailState(
      ticketDetail: ticketDetail ?? this.ticketDetail,
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
