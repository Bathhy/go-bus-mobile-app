# Date Format Fix - API 500 Error

## Problem
The API endpoint `/api/schedules/filter/specification` was returning a 500 error:

```
"Method parameter 'fromDate': Failed to convert value of type 'java.lang.String' 
to required type 'java.time.LocalDate'; Failed to convert from type [java.lang.String] 
to type [@org.springframework.web.bind.annotation.RequestParam 
@org.springframework.format.annotation.DateTimeFormat java.time.LocalDate] 
for value [2026-04-27T00:00:00.000]"
```

The backend expects a simple date format (`2026-04-28`) but was receiving ISO 8601 with time (`2026-04-27T00:00:00.000`).

## Root Cause
In `lib/view_models/controller/home/home_controller.dart`, the `getSearchParams()` method was formatting dates using `DateTime.toIso8601String()`, which includes the time component:

```dart
// ❌ BEFORE - Wrong format
final departureDateStr = DateTime(
  state.departureDate!.year,
  state.departureDate!.month,
  state.departureDate!.day,
).toIso8601String(); // Returns: 2026-04-27T00:00:00.000
```

The Java backend expects `LocalDate` format (yyyy-MM-dd) without time.

## Solution Applied

### 1. Created Date Extension Utility
Created `lib/core/utils/date_ext.dart` with reusable date formatting methods:

```dart
extension DateTimeExt on DateTime {
  /// Format date as LocalDate string (yyyy-MM-dd)
  /// Compatible with Java LocalDate
  String toLocalDateString() {
    return '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }

  /// Format date as readable string (EEE, MMM d, yyyy)
  String toReadableDate() {
    return DateFormat('EEE, MMM d, yyyy').format(this);
  }

  /// Format time as HH:mm
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }
}

extension DateStringExt on String {
  /// Parse ISO 8601 string to DateTime
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Parse and format to LocalDate string (yyyy-MM-dd)
  String? toLocalDateString() {
    final dt = toDateTime();
    return dt?.toLocalDateString();
  }

  /// Parse and format to readable date
  String? toReadableDate() {
    final dt = toDateTime();
    return dt?.toReadableDate();
  }

  /// Parse and format to time (HH:mm)
  String? toTimeString() {
    final dt = toDateTime();
    return dt?.toTimeString();
  }
}
```

### 2. Updated Home Controller
Modified `lib/view_models/controller/home/home_controller.dart`:

```dart
// ✅ AFTER - Correct format
import 'package:go_bus_express/core/utils/date_ext.dart';

Map<String, dynamic>? getSearchParams() {
  if (state.selectedRouteId == null || state.departureDate == null) {
    log('❌ Missing required search parameters');
    return null;
  }

  // Format date as simple date string (e.g., 2026-04-28)
  // Backend expects LocalDate format: yyyy-MM-dd
  final departureDateStr = state.departureDate!.toLocalDateString();

  final params = {
    'route_id': state.selectedRouteId,
    'departure_date': departureDateStr, // Now: 2026-04-28
  };

  // Add return_date only if it's provided
  if (state.returnDate != null) {
    params['return_date'] = state.returnDate!.toLocalDateString();
  }

  log('✅ Search params: $params');
  return params;
}
```

### 3. Updated Select Route View
Simplified date formatting in `lib/view/ticket/select_route/select_route_view.dart`:

```dart
// ✅ BEFORE - Manual parsing
String formattedDate = "N/A";
if (controller.state.departureDate.isNotEmpty) {
  try {
    final dt = DateTime.parse(controller.state.departureDate);
    formattedDate = DateFormat('EEE, MMM d, yyyy').format(dt);
  } catch (e) {
    formattedDate = controller.state.departureDate;
  }
}

// ✅ AFTER - Using extension
final formattedDate = controller.state.departureDate.isNotEmpty
    ? controller.state.departureDate.toReadableDate() ?? "N/A"
    : "N/A";
```

## API Request Format

### Before (Wrong)
```
GET /api/schedules/filter/specification?routeId=1&fromDate=2026-04-27T00%3A00%3A00.000
```

### After (Correct)
```
GET /api/schedules/filter/specification?routeId=1&fromDate=2026-04-28
```

## Benefits

1. **Fixed API Error** - Backend now receives dates in the correct format
2. **Reusable Utilities** - Date extension can be used throughout the app
3. **Cleaner Code** - Less boilerplate for date formatting
4. **Type Safety** - Extension methods provide null-safe date parsing
5. **Consistency** - All date formatting follows the same pattern

## Files Modified

1. `lib/core/utils/date_ext.dart` - Created new date extension utility
2. `lib/view_models/controller/home/home_controller.dart` - Updated to use `toLocalDateString()`
3. `lib/view/ticket/select_route/select_route_view.dart` - Simplified date formatting with extensions

## Testing

To verify the fix:

1. Select a route from the home screen
2. Choose a departure date
3. Click "Search" or "Book Now"
4. Check the API request in logs - should show: `fromDate=2026-04-28` (not `2026-04-27T00:00:00.000`)
5. Verify the schedule list loads successfully without 500 error

## Additional Usage Examples

```dart
// Format DateTime to LocalDate string
final date = DateTime(2026, 4, 28);
print(date.toLocalDateString()); // 2026-04-28

// Format DateTime to readable date
print(date.toReadableDate()); // Mon, Apr 28, 2026

// Format DateTime to time
print(date.toTimeString()); // 00:00

// Parse ISO string and format
final isoString = "2026-04-27T14:30:00.000";
print(isoString.toLocalDateString()); // 2026-04-27
print(isoString.toReadableDate()); // Sun, Apr 27, 2026
print(isoString.toTimeString()); // 14:30
```
