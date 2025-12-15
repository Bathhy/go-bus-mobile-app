import 'package:go_bus_express/models/route/seat_layout_model.dart';

import '../../../../core/base/base_ui_state.dart';

class SelectSeatState extends BaseUiState {
  final SeatLayoutModel? model;
  final List<String> selectedSeats; // Seat numbers for display (e.g., "10", "11")
  final List<int> selectedSeatIds; // Seat IDs for backend API
  final String origin;
  final String destination;
  final String? departureDate;
  final String departureTime;
  final double unitPrice;
  final int scheduleId;

  SelectSeatState({
    super.isLoading = false,
    this.model = const SeatLayoutModel(),
    this.selectedSeats = const [],
    this.selectedSeatIds = const [],
    this.origin = '',
    this.destination = '',
    this.departureDate,
    this.departureTime = '',
    this.unitPrice = 0.0,
    this.scheduleId = 0,
  });

  SelectSeatState copyWith({
    bool? isLoading,
    SeatLayoutModel? model,
    List<String>? selectedSeats,
    List<int>? selectedSeatIds,
    String? origin,
    String? destination,
    String? departureDate,
    String? departureTime,
    double? unitPrice,
    int? scheduleId,
  }) {
    return SelectSeatState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      selectedSeatIds: selectedSeatIds ?? this.selectedSeatIds,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      unitPrice: unitPrice ?? this.unitPrice,
      scheduleId: scheduleId ?? this.scheduleId,
    );
  }
}
