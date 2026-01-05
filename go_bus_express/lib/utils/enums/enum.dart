enum PaymentStatusEnum {
  pending("PENDING"),
  paid("PAID"),
  failed("FAILED");

  final String status;

  const PaymentStatusEnum(this.status);
}

enum SeatStatusEnum {
  unavailable("BOOKED"),
  available("AVAILABLE");

  final String status;

  const SeatStatusEnum(this.status);
}

enum BakongPaymentStatusEnum {
  unpaid("UNPAID"),
  paid("PAID");

  final String status;

  const BakongPaymentStatusEnum(this.status);
}
