enum PaymentStatusEnum {
  pending("PENDING"),
  paid("PAID"),
  failed("FAILED");

  final String status;

  const PaymentStatusEnum(this.status);
}
