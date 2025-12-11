import 'package:go_bus_express/models/route/seat_layout_model.dart';

import '../../../../core/base/base_ui_state.dart';

class SelectSeatState extends BaseUiState {
  final SeatLayoutModel? model;
  final List<String> selectedSeats;

  SelectSeatState({
    super.isLoading = false,
    this.model = const SeatLayoutModel(),
    this.selectedSeats = const [],
  });

  SelectSeatState copyWith({
    bool? isLoading,
    SeatLayoutModel? model,
    List<String>? selectedSeats,
  }) {
    return SelectSeatState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      selectedSeats: selectedSeats ?? this.selectedSeats,
    );
  }
}
