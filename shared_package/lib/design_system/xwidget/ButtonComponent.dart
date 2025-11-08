export 'ButtonComponent.dart';
import 'package:flutter/material.dart';

import '../../config/themes.dart';
import '../../design_system/constant/ts_fontsize.dart';

class XButton extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;
  final int optionbutton;
  final double? width;
  final double? height;
  final bool loadingState;
  final Color bgColor;
  final Color textColor;
  final bool isDisabled;

  const XButton({
    super.key,
    required this.label,
    this.onTap,
    this.bgColor = eventPrimaryColor,
    this.textColor = white,
    required this.optionbutton,
    this.width = double.infinity,
    this.loadingState = false,
    this.isDisabled = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBgColor = isDisabled ? Colors.grey.shade400 : bgColor;
    final Color effectiveTextColor = isDisabled ? Colors.black45 : textColor;

    return InkWell(
      onTap: isDisabled || loadingState ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: TsFontSize.medium),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius:
              optionbutton == 1
                  ? BorderRadius.circular(10)
                  : BorderRadius.circular(20),
          color: effectiveBgColor,
          boxShadow:
              isDisabled
                  ? []
                  : [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        33,
                        32,
                        32,
                      ).withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Center(
          child:
              loadingState
                  ? CircularProgressIndicator(
                    backgroundColor: white,
                    color: shimmerColor,
                  )
                  : Text(
                    label,
                    style: TextStyle(
                      fontSize: TsFontSize.large,
                      color: effectiveTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:tos_book_event/config/themes/app_color.dart';
// import 'package:tos_book_event/core/utils/constant/ts_fontsize.dart';

// class XButton extends StatelessWidget {
//   final String label;
//   final GestureTapCallback? onTap;
//   final int optionbutton;
//   final double? width;
//   final bool loadingState;
//   final Color bgColor;
//   final Color textColor;
//   const XButton({
//     super.key,
//     required this.label,
//     this.onTap,
//     this.bgColor = eventPrimaryColor,
//     this.textColor = white,
//     required this.optionbutton,
//     this.width = double.infinity,
//     this.loadingState = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: Tsfontsize.medium),
//         width: width,
//         decoration: BoxDecoration(
//           borderRadius: optionbutton == 1
//               ? BorderRadius.circular(10)
//               : BorderRadius.circular(20),
//           color: bgColor,
//           boxShadow: [
//             BoxShadow(
//               color: const Color.fromARGB(255, 33, 32, 32).withOpacity(0.5),
//               spreadRadius: 0.5,
//               blurRadius: 3,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Center(
//           child: loadingState
//               ? CircularProgressIndicator(
//                   backgroundColor: white,
//                   color: shimmerColor,
//                 )
//               : Text(
//                   label,
//                   style: TextStyle(
//                       fontSize: Tsfontsize.large,
//                       color: textColor,
//                       fontWeight: FontWeight.bold),
//                 ),
//         ),
//       ),
//     );
//   }
// }
