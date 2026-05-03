class SeatEventType {
  static const String seatSelected = 'SEAT_SELECTED';
  static const String seatDeselected = 'SEAT_DESELECTED';
  static const String seatBooked = 'SEAT_BOOKED';
  static const String seatReleased = 'SEAT_RELEASED';
  static const String seatExpired = 'SEAT_SELECTION_EXPIRED';
  static const String stateSyncResponse = 'STATE_SYNC_RESPONSE';
  static const String stateSyncRequest = 'STATE_SYNC_REQUEST';
}

class SeatStatus {
  static const String available = 'AVAILABLE';
  static const String pending = 'PENDING';
  static const String booked = 'BOOKED';
}

class SeatAvailabilityEvent {
  final String type;
  final int? scheduleId;
  final int? seatId;
  final String? seatNumber;
  final int? bookingId;
  final String? status;
  final String? userId;
  final DateTime? timestamp;
  final List<dynamic>? seats;

  const SeatAvailabilityEvent({
    required this.type,
    this.scheduleId,
    this.seatId,
    this.seatNumber,
    this.bookingId,
    this.status,
    this.userId,
    this.timestamp,
    this.seats,
  });

  factory SeatAvailabilityEvent.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    if (type == null) throw const FormatException('Missing required field: type');
    return SeatAvailabilityEvent(
      type: type,
      scheduleId: json['scheduleId'] as int?,
      seatId: json['seatId'] as int?,
      seatNumber: json['seatNumber'] as String?,
      bookingId: json['bookingId'] as int?,
      status: json['status'] as String?,
      userId: json['userId']?.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
      seats: json['seats'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    if (scheduleId != null) 'scheduleId': scheduleId,
    if (seatId != null) 'seatId': seatId,
    if (seatNumber != null) 'seatNumber': seatNumber,
    if (bookingId != null) 'bookingId': bookingId,
    if (status != null) 'status': status,
    if (userId != null) 'userId': userId,
    if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    if (seats != null) 'seats': seats,
  };

  bool isSelectedByUser(String currentUserId) => userId == currentUserId;
  bool isAvailable() => status == SeatStatus.available;
  bool isPending() => status == SeatStatus.pending;
  bool isBooked() => status == SeatStatus.booked;
}
