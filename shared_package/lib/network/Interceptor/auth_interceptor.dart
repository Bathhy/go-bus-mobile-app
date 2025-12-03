// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthInterceptor extends Interceptor {
//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // Skip adding token for login/register endpoints
//     if (options.path.contains('/login') || 
//         options.path.contains('/register') ||
//         options.path.contains('/signup')) {
//       return handler.next(options);
//     }

//     // Get token from SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }

//     return handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     // Handle 401 Unauthorized - token expired
//     if (err.response?.statusCode == 401) {
//       // Clear token and redirect to login
//       _clearToken();
//     }
//     return handler.next(err);
//   }

//   Future<void> _clearToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//   }
// }
