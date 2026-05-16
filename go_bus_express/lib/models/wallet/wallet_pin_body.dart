class WalletPinBody {
  final String pinCode;

  const WalletPinBody({required this.pinCode});

  Map<String, dynamic> toJson() => {'pinCode': pinCode};
}
