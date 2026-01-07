import 'dart:developer';

import 'package:get/get.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';
import 'package:go_bus_express/utils/enums/enum.dart';
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
    _initializeFromArguments();
  }

  // MARK - Init Value from Route Argument

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      log('No arguments passed to SelectSeatController');
      return;
    }

    // Extract all arguments
    final busId = args['busId'] as int?;
    final scheduleId = args['scheduleId'] as int?;
    final origin = args['origin'] as String? ?? '';
    final destination = args['destination'] as String? ?? '';
    final departureDate = args['departureDate'] as String?;
    final departureTime = args['departureTime'] as String? ?? '';
    final unitPrice = (args['unitPrice'] as num?)?.toDouble() ?? 0.0;

    // Update state with route information
    updateState(
      (state) => state.copyWith(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
        departureTime: departureTime,
        unitPrice: unitPrice,
        scheduleId: scheduleId,
      ),
    );
    fetchBusSeat(busId ?? 0);
  }

  // MARK - Fetch Seat

  Future<void> fetchBusSeat(int busId) async {
    updateState((state) => state.copyWith(isLoading: true));

    final result = await _repository.fetchBusSeat(state.scheduleId, busId);
    switch (result) {
      case Success<SeatLayoutModel?>():
        {
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

  // MARK - Function Check Seat Unavailable
  bool isSeatBooked(String seatNumber) {
    // If seat array is null or empty, no seats are booked
    if (state.model?.seat == null || state.model!.seat!.isEmpty) {
      return false;
    }

    final seat = state.model?.seat?.firstWhere(
      (s) => s.seatNumber == seatNumber,
      orElse: () => Seat(),
    );
    return seat?.status == SeatStatusEnum.unavailable.status;
  }

  //  MARK - Function Check Seat Available
  bool isSeatAvailable(String seatNumber) {
    // If seat array is null or empty, all seats are available by default
    if (state.model?.seat == null || state.model!.seat!.isEmpty) {
      log(' Seat array is empty, all seats available');
      return true;
    }

    final seat = state.model?.seat?.firstWhere(
      (s) => s.seatNumber == seatNumber,
      orElse: () => Seat(),
    );

    // If seat not found in array, it's available
    // If seat found, check its status
    final isAvailable =
        seat?.status == SeatStatusEnum.available.status || seat?.id == null;
    return isAvailable;
  }

  void toggleSeat(String seatNumber) {
    final currentSeats = List<String>.from(state.selectedSeats);
    final currentSeatIds = List<int>.from(state.selectedSeatIds);

    // Find the seat object to get its ID
    final seat = state.model?.seat?.firstWhere(
      (s) => s.seatNumber == seatNumber,
      orElse: () => Seat(),
    );

    if (currentSeats.contains(seatNumber)) {
      // Deselect if already selected
      currentSeats.remove(seatNumber);
      if (seat?.id != null) {
        currentSeatIds.remove(seat!.id);
      }
    } else {
      // Select the seat
      currentSeats.add(seatNumber);
      if (seat?.id != null) {
        currentSeatIds.add(seat!.id!);
      }
    }

    updateState(
      (state) => state.copyWith(
        selectedSeats: currentSeats,
        selectedSeatIds: currentSeatIds,
      ),
    );
  }

  bool isSeatSelected(String seatNumber) =>
      state.selectedSeats.contains(seatNumber);
}
