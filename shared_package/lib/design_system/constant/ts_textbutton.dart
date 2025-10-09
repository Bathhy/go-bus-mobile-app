import 'package:flutter/material.dart';
import 'package:shared_package/design_system/constant/ts_fontsize.dart';

import '../../config/themes.dart';

class TsTextLargebutton extends StatelessWidget {
  final String label;
  final Color colortext;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final GestureTapCallback? onTap;
  const TsTextLargebutton(
      {super.key,
      required this.colortext,
      required this.label,
      this.decoration,
      this.fontWeight,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
            color: colortext,
            fontSize: TsFontSize.large,
            fontWeight: fontWeight,
            decoration: decoration),
      ),
    );
  }
}

class TsTextMediumbutton extends StatelessWidget {
  final String label;
  final Color? colortext;
  final TextDecoration? decoration;
  final Color? decorcolor;
  final FontWeight? fontWeight;
  final GestureTapCallback onTap;
  const TsTextMediumbutton({
    super.key,
    required this.label,
    this.decoration,
    this.decorcolor,
    this.fontWeight,
    this.colortext = eventPrimaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
            color: colortext,
            fontSize: TsFontSize.medium,
            fontWeight: fontWeight,
            decoration: decoration,
            decorationColor: decorcolor),
      ),
    );
  }
}

class TsTextSmallbutton extends StatelessWidget {
  final String label;
  final Color colortext = eventPrimaryColor;
  final TextDecoration? decoration;
  final GestureTapCallback? onTap;
  const TsTextSmallbutton({
    super.key,
    required this.label,
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: colortext,
          fontSize: TsFontSize.small,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TsTextExtraSmallbutton extends StatelessWidget {
  final String label;
  final Color colortext = eventPrimaryColor;
  final TextDecoration? decoration;
  final GestureTapCallback? onTap;
  const TsTextExtraSmallbutton({
    super.key,
    required this.label,
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: colortext,
          fontSize: TsFontSize.extraSmall,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
