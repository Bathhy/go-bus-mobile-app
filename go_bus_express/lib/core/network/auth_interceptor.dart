// import 'package:dio/dio.dart';
// import 'package:go_bus_express/core/storage/base_share_preference.dart';
//
// class AuthInterceptor extends Interceptor with BaseSharePreference {
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
//
//     // Get token from SharedPreferences
//     final token = readString(PreferencesKey.token);
//
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//
//     return handler.next(options);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     // Handle 401 Unauthorized - token expired
//     if (err.response?.statusCode == 401) {
//       // Clear token and redirect to login
//       logoutBox();
//     }
//     return handler.next(err);
//   }
// }
