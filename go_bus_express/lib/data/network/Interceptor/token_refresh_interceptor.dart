import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../core/storage/local_repository.dart';
import '../../../resources/routes/app_routes.dart';

/// Interceptor to handle token refresh on 401 errors
class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio dio;
  final LocalRepository localRepository;
  final String baseUrl;
  
  // Flag to prevent multiple simultaneous logout navigations
  bool _isLoggingOut = false;

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
    // Check if error is 401 - Unauthorized
    if (err.response?.statusCode == 401) {
      final requestPath = err.requestOptions.path;
      
      // Skip token refresh for auth endpoints (login, register, refresh)
      if (requestPath.contains('/auth/login') || 
          requestPath.contains('/auth/register') ||
          requestPath.contains('/auth/refresh')) {
        debugPrint('[TokenRefresh] Skipping refresh for auth endpoint: $requestPath');
        return handler.next(err);
      }
      
      final errorData = err.response?.data;
      
      debugPrint('[TokenRefresh] 401 Unauthorized detected');
      debugPrint('[TokenRefresh] Request path: $requestPath');
      debugPrint('[TokenRefresh] Error data: $errorData');
      
      // Check if it's a token expiration error
      // Handle both possible error formats:
      // 1. {"status": 401, "error": "TOKEN_EXPIRED", "message": "..."}
      // 2. Any other 401 error (treat as token expired)
      final isTokenExpired = errorData is Map && 
          (errorData['error'] == 'TOKEN_EXPIRED' || 
           errorData['status'] == 401);
      
      if (isTokenExpired || errorData == null) {
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
    // Prevent multiple simultaneous logout attempts
    if (_isLoggingOut) {
      debugPrint('[TokenRefresh] Logout already in progress, skipping...');
      return;
    }
    
    _isLoggingOut = true;
    debugPrint('[TokenRefresh] Logging out user...');
    
    try {
      // Clear all stored tokens and user data
      await localRepository.logout();
      
      // Navigate to login screen and clear navigation stack
      debugPrint('[TokenRefresh] Navigating to login screen...');
      
      // Schedule navigation for next frame to avoid navigation during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != AppRoutes.signIn) {
          Get.offAllNamed(AppRoutes.signIn);
          
          // Show a snackbar to inform user
          Get.snackbar(
            'Session Expired',
            'Your session has expired. Please login again.',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
            colorText: Get.theme.colorScheme.error,
          );
        }
        
        // Reset flag after navigation
        Future.delayed(const Duration(seconds: 1), () {
          _isLoggingOut = false;
        });
      });
    } catch (e) {
      debugPrint('[TokenRefresh] Error during logout: $e');
      _isLoggingOut = false;
    }
  }
}
