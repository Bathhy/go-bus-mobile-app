import 'package:go_bus_express/data/network/network_constant.dart';

/// Converts image path from API response to full URL
/// Example: "uploads\\1769332134032.png" -> "http://192.168.1.228:3000/1769332134032.png"
String getImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return '';

  // Replace backslashes with forward slashes
  final cleanPath = imagePath.replaceAll('\\', '/');

  // Remove leading slash if exists
  var path = cleanPath.startsWith('/') ? cleanPath.substring(1) : cleanPath;

  path = path.replaceAll("uploads/", "");

  final baseUrl = NetworkConstant.baseUrl;

  return '$baseUrl/$path';
}
