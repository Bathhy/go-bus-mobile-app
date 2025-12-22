# Select Route View - Date/Time Formatting Fixes

## Issues Fixed ✅

### 1. Departure & Arrival Time Formatting
**Problem:** Times were showing as ISO 8601 strings (e.g., "2025-11-24T13:00:00.000Z")

**Solution:** Added date parsing and formatting using `intl` package
```dart
// Format departure time from ISO 8601
String formattedDepartureTime = 'N/A';
if (model?.departureTime != null) {
  try {
    final dt = DateTime.parse(model!.departureTime!);
    formattedDepartureTime = DateFormat('HH:mm').format(dt);
  } catch (e) {
    formattedDepartureTime = model?.departureTime ?? 'N/A';
  }
}
```

**Result:** Times now display as "13:00", "21:00", etc.

### 2. Available Seats Display
**Problem:** Was showing `bookedSeats/totalSeats` instead of `availableSeats/totalSeats`

**Solution:** Changed to use correct fields from API response
```dart
availableSeats: '${model?.bus?.availableSeats ?? 0}/${model?.bus?.totalSeats ?? 0} Seats'
```

**Result:** Now correctly shows "15/15 Seats" for available buses

### 3. Price Formatting
**Problem:** Price was showing as raw number without proper formatting

**Solution:** Added proper price formatting with 2 decimal places
```dart
price: '\$${model?.price?.toStringAsFixed(2) ?? '0.00'}'
```

**Result:** Prices now display as "$15.50", "$14.00", etc.

### 4. Duration Calculation
**Problem:** Was using `model?.bus?.route?.durationMinutes` (nested route) instead of main route

**Solution:** Use the correct route duration
```dart
duration: minutesToHours(
  controller.state.model?.route?.durationMinutes ?? 0,
).toString()
```

**Result:** Shows correct trip duration (e.g., "6h 10m")

### 5. Location Labels
**Problem:** Both departure and arrival showed "Boarding:"

**Solution:** Updated labels to be more descriptive
```dart
departureLocation: 'Boarding: ${controller.state.model?.route?.origin ?? 'N/A'}'
arrivalLocation: 'Drop-off: ${controller.state.model?.route?.destination ?? 'N/A'}'
```

**Result:** Clear distinction between boarding and drop-off locations

### 6. Schedule ID Passing
**Problem:** Hardcoded `scheduleId: 6` in navigation

**Solution:** Pass actual schedule ID from model
```dart
'scheduleId': scheduleId ?? 0,
'busId': budId ?? 0,
```

**Result:** Correct schedule is selected when booking

## API Response Mapping

Your API returns:
```json
{
  "data": {
    "route": {
      "id": 1,
      "origin": "Phnom Penh",
      "destination": "Siem Reap",
      "distanceKm": 320,
      "durationMinutes": 370
    },
    "schedules": [
      {
        "id": 27,
        "busId": 8,
        "departureTime": "2025-11-24T13:00:00.000Z",
        "arrivalTime": "2025-11-24T21:00:00.000Z",
        "price": 15.5,
        "bus": {
          "totalSeats": 15,
          "availableSeats": 15,
          "bookedSeats": 0,
          "busType": "SLEEPER"
        }
      }
    ]
  }
}
```

Now correctly displays as:
- **Departure:** 13:00
- **Arrival:** 21:00
- **Duration:** 6h 10m
- **Price:** $15.50
- **Seats:** 15/15 Seats
- **Type:** SLEEPER

## Files Modified

- `lib/view/ticket/select_route/select_route_view.dart`
  - Added `intl` import for date formatting
  - Added time parsing logic
  - Fixed available seats display
  - Fixed price formatting
  - Fixed duration calculation
  - Updated location labels
  - Fixed schedule ID passing

## Testing

Run the app and navigate to Select Route screen:
1. ✅ Times display in HH:mm format (13:00, 21:00)
2. ✅ Available seats show correctly (15/15 Seats)
3. ✅ Price formatted with 2 decimals ($15.50)
4. ✅ Duration calculated from route (6h 10m)
5. ✅ Locations labeled correctly (Boarding/Drop-off)
6. ✅ Correct schedule ID passed to seat selection

## Before vs After

### Before
```
Departure: 2025-11-24T13:00:00.000Z
Arrival: 23:22
Duration: 0h 0m
Price: $15.5
Seats: 0/15 Seats
Boarding: N/A
Boarding: N/A
```

### After
```
Departure: 13:00
Arrival: 21:00
Duration: 6h 10m
Price: $15.50
Seats: 15/15 Seats
Boarding: Phnom Penh
Drop-off: Siem Reap
```

---

All date/time formatting issues are now resolved! 🎉
