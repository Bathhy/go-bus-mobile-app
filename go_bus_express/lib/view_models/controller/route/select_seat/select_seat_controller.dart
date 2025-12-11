import 'dart:developer';

import 'package:get/get.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/route/select_seat/select_seat_state.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../../repository/route_repository.dart';

class SelectSeatController extends BaseController<SelectSeatState> {
  final RouteRepository _repository;

  SelectSeatController(this._repository) : super(SelectSeatState());

  @override
  void onInit() {
    super.onInit();
    fetchBusSeat();
  }

  final busId = Get.arguments['busId'];

  Future<void> fetchBusSeat() async {
    // Set loading
    updateState((state) => state.copyWith(isLoading: true));
    final result = await _repository.fetchBusSeat(6, busId);
    switch (result) {
      case Success<SeatLayoutModel?>():
        {
          log("Bus layout and seat info loaded successfully");
          updateState(
            (state) => state.copyWith(isLoading: false, model: result.data),
          );
        }
      case Error<SeatLayoutModel?>():
        {
          log("Error loading bus seat: ${result.error.displayMessage}");
          updateState((state) => state.copyWith(isLoading: false));
        }
    }
  }

  bool isSeatBooked(String seatNumber) {
    final seat = state.model?.seats?.firstWhere(
      (s) => s.seatNumber == seatNumber,
      orElse: () => Seat(),
    );
    return seat?.status == 'BOOKED';
  }

  bool isSeatAvailable(String seatNumber) {
    final seat = state.model?.seats?.firstWhere(
      (s) => s.seatNumber == seatNumber,
      orElse: () => Seat(),
    );
    return seat?.status == 'AVAILABLE';
  }

  void toggleSeat(String seatNumber) {
    final currentSeats = List<String>.from(state.selectedSeats);
    
    if (currentSeats.contains(seatNumber)) {
      // Deselect if already selected
      currentSeats.remove(seatNumber);
    } else {
      // Select the seat
      currentSeats.add(seatNumber);
    }
    
    updateState((state) => state.copyWith(selectedSeats: currentSeats));
  }

  bool isSeatSelected(String seatNumber) {
    return state.selectedSeats.contains(seatNumber);
  }
}
