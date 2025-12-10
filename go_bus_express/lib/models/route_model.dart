class RouteModel {
  final int id;
  final String origin;
  final String destination;
  final int distanceKm;
  final int durationMinutes;
  final Location? location;

  RouteModel({
    required this.id,
    required this.origin,
    required this.destination,
    required this.distanceKm,
    required this.durationMinutes,
    this.location,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      origin: json['origin'],
      destination: json['destination'],
      distanceKm: json['distanceKm'],
      durationMinutes: json['durationMinutes'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}
