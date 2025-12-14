import 'package:go_bus_express/models/route/seat_layout_model.dart';

import '../../../../core/base/base_ui_state.dart';

class SelectSeatState extends BaseUiState {
  final SeatLayoutModel? model;
  final List<String> selectedSeats;
  final String origin;
  final String destination;
  final String? departureDate;
  final String departureTime;
  final double unitPrice;

  SelectSeatState({
    super.isLoading = false,
    this.model = const SeatLayoutModel(),
    this.selectedSeats = const [],
    this.origin = '',
    this.destination = '',
    this.departureDate,
    this.departureTime = '',
    this.unitPrice = 0.0,
  });

  SelectSeatState copyWith({
    bool? isLoading,
    SeatLayoutModel? model,
    List<String>? selectedSeats,
    String? origin,
    String? destination,
    String? departureDate,
    String? departureTime,
    double? unitPrice,
  }) {
    return SelectSeatState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
