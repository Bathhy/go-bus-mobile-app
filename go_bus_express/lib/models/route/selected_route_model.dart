class SelectedRouteModel {
  final int id;
  final String origin;
  final String destination;

  const SelectedRouteModel({
    required this.id,
    required this.origin,
    required this.destination,
  });

  factory SelectedRouteModel.fromDetailRoute(
    int id,
    String origin,
    String destination,
  ) {
    return SelectedRouteModel(
      id: id,
      origin: origin,
      destination: destination,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'origin': origin,
        'destination': destination,
      };

  factory SelectedRouteModel.fromJson(Map<String, dynamic> json) {
    return SelectedRouteModel(
      id: json['id'],
      origin: json['origin'],
      destination: json['destination'],
    );
  }
}
