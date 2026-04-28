# Token Refresh Fix - 401 Auto Refresh

## Problem
The 401 status code was not triggering automatic token refresh when calling profile or other API endpoints. The interceptor was too strict in checking for the exact error format `{"error": "TOKEN_EXPIRED"}`.

## Root Cause
The `TokenRefreshInterceptor` was only handling 401 errors if the response data contained exactly `errorData['error'] == 'TOKEN_EXPIRED'`. If the API returned a different format or no data, the interceptor would skip the token refresh logic.

## Solution Applied

### 1. Updated Token Refresh Logic
Modified `lib/data/network/Interceptor/token_refresh_interceptor.dart` to:

- **Handle all 401 errors** - Not just those with specific error format
- **Check multiple error formats**:
  - `{"error": "TOKEN_EXPIRED"}` 
  - `{"status": 401, "error": "TOKEN_EXPIRED", "message": "..."}`
  - Any 401 with null/empty error data
- **Skip auth endpoints** - Don't attempt refresh for `/auth/login`, `/auth/register`, `/auth/refresh`
- **Better logging** - Added request path and error data logging for debugging

### 2. Key Changes

```dart
// Before: Only handled specific error format
if (errorData is Map && errorData['error'] == 'TOKEN_EXPIRED') {
  // refresh logic
}

// After: Handles all 401 errors
// Skip auth endpoints first
if (requestPath.contains('/auth/login') || 
    requestPath.contains('/auth/register') ||
    requestPath.contains('/auth/refresh')) {
  return handler.next(err);
}

// Handle any 401 as token expired
final isTokenExpired = errorData is Map && 
    (errorData['error'] == 'TOKEN_EXPIRED' || 
     errorData['status'] == 401);

if (isTokenExpired || errorData == null) {
  // refresh logic
}
```

## How It Works Now

1. **API call fails with 401** → Any endpoint (profile, bookings, etc.)
2. **TokenRefreshInterceptor catches it** → Checks if it's an auth endpoint (skip if yes)
3. **Attempts token refresh** → Calls `/auth/refresh` with refresh token
4. **On success**:
   - Saves new access token (and refresh token if provided)
   - Retries the original failed request automatically
   - Returns the successful response
5. **On failure**:
   - Logs out the user
   - Clears all tokens
   - User needs to login again

## Testing

To verify the fix works:

1. **Simulate token expiration**:
   - Wait for access token to expire naturally, OR
   - Manually modify the stored token to an invalid value

2. **Make an API call**:
   ```dart
   // Example: Get profile
   final result = await profileRepository.getProfile();
   ```

3. **Expected behavior**:
   - First request fails with 401
   - Interceptor automatically calls `/auth/refresh`
   - Original request retries with new token
   - Profile data is returned successfully
   - User doesn't see any error

4. **Check logs** (in debug mode):
   ```
   [TokenRefresh] 401 Unauthorized detected
   [TokenRefresh] Request path: /api/profile
   [TokenRefresh] Access token expired, attempting refresh...
   [TokenRefresh] Calling /auth/refresh with token: ...
   [TokenRefresh] Refresh response status: 200
   [TokenRefresh] Access token refreshed (reusing refresh token)
   ```

## Additional Notes

- The interceptor is added to Dio in `lib/data/network/dio_service.dart`
- Interceptor order matters: `ConnectivityInterceptor` → `XInterceptor` → `TokenRefreshInterceptor`
- The refresh endpoint should return: `{"status": 200, "data": {"accessToken": "...", "refreshToken": "..."}}`
- If refresh token is also expired, user will be logged out automatically

## Files Modified

- `lib/data/network/Interceptor/token_refresh_interceptor.dart`
