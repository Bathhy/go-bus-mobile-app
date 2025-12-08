import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSvgImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final Color? color;
  final bool defaultColor;
  final BoxFit boxFit;

  const AppSvgImage({
    super.key,
    this.height = 25,
    this.width = 25,
    this.color,
    required this.path,
    this.defaultColor = false,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      fit: boxFit,
      height: height,
      width: width,
      colorFilter:
          defaultColor
              ? null
              : ColorFilter.mode(
                color ?? Theme.of(context).hintColor,
                BlendMode.srcIn,
              ),
    );
  }
}
