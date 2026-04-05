import 'package:intl/intl.dart';

import '../../../../core/base/base_ui_state.dart';

class ChoosePaymentState extends BaseUiState {
  final String direction;
  final String departureDate;
  final String departureTime;
  final List<String> selectedSeats;
  final List<int> selectedSeatIds;
  final double unitPrice;
  final double discount;
  final bool agreedToTerms;
  final String note;
  final int scheduleId;

  ChoosePaymentState({
    super.isLoading = false,
    this.direction = '',
    this.departureDate = '',
    this.departureTime = '',
    this.selectedSeats = const [],
    this.selectedSeatIds = const [],
    this.unitPrice = 0.0,
    this.discount = 0.0,
    this.agreedToTerms = false,
    this.note = '',
    this.scheduleId = 0,
  });

  int get quantity => selectedSeats.length;

  double get totalPrice => (unitPrice * quantity) - discount;

  String get seatsDisplay => selectedSeats.join(', ');

  String get formattedDepartureDate {
    if (departureDate.isEmpty) return '';
    try {
      final date = DateTime.parse(departureDate);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return departureDate; // Return original if parsing fails
    }
  }

  ChoosePaymentState copyWith({
    bool? isLoading,
    String? direction,
    String? departureDate,
    String? departureTime,
    List<String>? selectedSeats,
    List<int>? selectedSeatIds,
    double? unitPrice,
    double? discount,
    String? selectedPaymentMethod,
    bool? agreedToTerms,
    String? note,
    int? scheduleId,
  }) {
    return ChoosePaymentState(
      isLoading: isLoading ?? this.isLoading,
      direction: direction ?? this.direction,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      selectedSeatIds: selectedSeatIds ?? this.selectedSeatIds,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      note: note ?? this.note,
      scheduleId: scheduleId ?? this.scheduleId,
    );
  }
}
