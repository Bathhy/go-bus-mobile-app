import '../../../../core/base/base_ui_state.dart';

class ChoosePaymentState extends BaseUiState {
  final String direction;
  final String departureDate;
  final String departureTime;
  final List<String> selectedSeats;
  final double unitPrice;
  final double discount;
  final String? selectedPaymentMethod;
  final bool agreedToTerms;
  final String note;

  ChoosePaymentState({
    super.isLoading = false,
    this.direction = '',
    this.departureDate = '',
    this.departureTime = '',
    this.selectedSeats = const [],
    this.unitPrice = 0.0,
    this.discount = 0.0,
    this.selectedPaymentMethod,
    this.agreedToTerms = false,
    this.note = '',
  });

  int get quantity => selectedSeats.length;
  
  double get totalPrice => (unitPrice * quantity) - discount;

  String get seatsDisplay => selectedSeats.join(', ');

  ChoosePaymentState copyWith({
    bool? isLoading,
    String? direction,
    String? departureDate,
    String? departureTime,
    List<String>? selectedSeats,
    double? unitPrice,
    double? discount,
    String? selectedPaymentMethod,
    bool? agreedToTerms,
    String? note,
  }) {
    return ChoosePaymentState(
      isLoading: isLoading ?? this.isLoading,
      direction: direction ?? this.direction,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      note: note ?? this.note,
    );
  }
}
