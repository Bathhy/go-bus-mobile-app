import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/storage/local_repository.dart';

/// Interceptor to handle token refresh on 401 errors
class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio dio;
  final LocalRepository localRepository;
  final String baseUrl;

  TokenRefreshInterceptor({
    required this.dio,
    required this.localRepository,
    required this.baseUrl,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is 401 and has TOKEN_EXPIRED error
    if (err.response?.statusCode == 401) {
      final errorData = err.response?.data;
      
      // Check if it's a token expiration error
      if (errorData is Map && errorData['error'] == 'TOKEN_EXPIRED') {
        debugPrint('[TokenRefresh] Access token expired, attempting refresh...');
        
        final refreshToken = localRepository.getRefreshToken();
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            // Create a separate Dio instance for refresh to avoid interceptor loops
            final refreshDio = Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ));
            
            // Attempt to refresh the token
            debugPrint('[TokenRefresh] Calling /auth/refresh with token: ${refreshToken.substring(0, 20)}...');
            final response = await refreshDio.post(
              '/auth/refresh',
              data: {
                'refreshToken': refreshToken,
              },
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );
            
            debugPrint('[TokenRefresh] Refresh response status: ${response.statusCode}');
            
            final responseData = response.data;
            
            if (responseData is Map && 
                responseData['status'] == 200 && 
                responseData['data'] != null) {
              final data = responseData['data'];
              final newAccessToken = data['accessToken'];
              final newRefreshToken = data['refreshToken']; // May be null
              
              if (newAccessToken != null) {
                // Save new access token
                await localRepository.saveToken(newAccessToken);
                
                // If API returns a new refresh token, save it (token rotation)
                // Otherwise, keep using the existing refresh token
                if (newRefreshToken != null) {
                  await localRepository.saveRefreshToken(newRefreshToken);
                  debugPrint('[TokenRefresh] Both tokens refreshed (rotation enabled)');
                } else {
                  debugPrint('[TokenRefresh] Access token refreshed (reusing refresh token)');
                }
                
                // Retry the original request with new token
                final options = err.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                
                try {
                  final retryResponse = await dio.fetch(options);
                  return handler.resolve(retryResponse);
                } catch (e) {
                  debugPrint('[TokenRefresh] Retry failed: $e');
                  return handler.reject(err);
                }
              }
            }
          } catch (refreshError) {
            debugPrint('[TokenRefresh] Refresh failed: $refreshError');
            
            // Log more details about the error
            if (refreshError is DioException) {
              debugPrint('[TokenRefresh] Error response data: ${refreshError.response?.data}');
              debugPrint('[TokenRefresh] Error status code: ${refreshError.response?.statusCode}');
            }
            
            // Refresh failed, logout user
            await _handleLogout();
            return handler.reject(err);
          }
        } else {
          debugPrint('[TokenRefresh] No refresh token available');
          await _handleLogout();
        }
      }
    }
    
    return handler.next(err);
  }

  Future<void> _handleLogout() async {
    debugPrint('[TokenRefresh] Logging out user...');
    await localRepository.logout();
    // You might want to navigate to login screen here
    // This can be done via a navigation service or event bus
  }
}
