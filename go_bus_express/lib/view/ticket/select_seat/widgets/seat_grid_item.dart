import 'package:flutter/material.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/view_models/controller/route/select_seat/select_seat_state.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';

enum _SeatDisplayState { available, selectedByMe, pendingByOther, booked }

class SeatGridItem extends StatelessWidget {
  final String seatNumber;
  final SeatInfo? info;
  final String? currentUserId;
  final bool isLegacySelected;
  final bool isLegacyBooked;
  final VoidCallback? onTap;

  const SeatGridItem({
    super.key,
    required this.seatNumber,
    required this.info,
    required this.currentUserId,
    required this.isLegacySelected,
    required this.isLegacyBooked,
    this.onTap,
  });

  _SeatDisplayState get _display {
    if (info != null) {
      if (info!.isBooked()) return _SeatDisplayState.booked;
      if (info!.isPending()) {
        return info!.isSelectedBy(currentUserId ?? '')
            ? _SeatDisplayState.selectedByMe
            : _SeatDisplayState.pendingByOther;
      }
      return _SeatDisplayState.available;
    }
    if (isLegacyBooked) return _SeatDisplayState.booked;
    if (isLegacySelected) return _SeatDisplayState.selectedByMe;
    return _SeatDisplayState.available;
  }

  Color get _color => switch (_display) {
        _SeatDisplayState.available => Colors.grey.shade500,
        _SeatDisplayState.selectedByMe => Colors.pink.shade200,
        _SeatDisplayState.pendingByOther => Colors.orange.shade300,
        _SeatDisplayState.booked => Colors.red.shade300,
      };

  bool get _tappable => _display == _SeatDisplayState.available ||
      _display == _SeatDisplayState.selectedByMe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tappable ? onTap : null,
      child: SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AppSvgImage(
              path: AppImages.icSeat,
              width: 70,
              height: 70,
              color: _color,
            ),
            Text(
              seatNumber,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
