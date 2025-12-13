import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/route_model.dart';

class RouteService {
  final Dio _dio = Dio();

  Future<List<RouteModel>> getRoutes() async {
    try {
      final baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.1.10:3000';
      final response = await _dio.get('$baseUrl/route');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => RouteModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load routes');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }
}
