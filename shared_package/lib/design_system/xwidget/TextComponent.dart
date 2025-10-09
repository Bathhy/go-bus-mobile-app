import 'package:flutter/material.dart';

import '../../config/themes.dart';
import '../constant/ts_fontsize.dart';

class XTextMegaLarge extends StatelessWidget {
  final String label;
  final Color? colortext;
  final TextDecoration? decoration;

  const XTextMegaLarge({
    super.key,
    this.colortext,
    required this.label,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: colortext,
        fontSize: TsFontSize.megaExtraLarge,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class XTextExtraLarge extends StatelessWidget {
  final String label;
  final Color? colortext;
  final TextDecoration? decoration;

  const XTextExtraLarge({
    super.key,
    this.colortext,
    required this.label,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: colortext,
        fontSize: TsFontSize.extralarge,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class XTextLarge extends StatelessWidget {
  final String label;
  final Color colortext;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final TextOverflow? textOverFlow;
  final int? maxLines;
  const XTextLarge(
      {super.key,
      required this.colortext,
      this.textOverFlow = TextOverflow.ellipsis,
      required this.label,
      this.decoration,
      this.maxLines,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: textOverFlow,
      maxLines: maxLines,
      style: TextStyle(
          color: colortext,
          fontSize: TsFontSize.large,
          fontWeight: fontWeight,
        
          decoration: decoration),
    );
  }
}

class XTextMedium extends StatelessWidget {
  final String label;
  final Color? colortext;
  final TextDecoration? decoration;
  final Color? decorcolor;
  final FontWeight? fontWeight;
  final int? maxline;
  final TextOverflow? textOverFlow;
  const XTextMedium({
    super.key,
    required this.label,
    this.decoration,
    this.decorcolor,
    this.fontWeight,
    this.colortext = eventPrimaryColor,
    this.maxline,
    this.textOverFlow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxline,
      overflow: textOverFlow,
      style: TextStyle(
        color: colortext,
        fontSize: TsFontSize.medium,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorcolor,
      ),
    );
  }
}

class XTextSmall extends StatelessWidget {
  final String label;
  final Color? colortext;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextOverflow? overFlowText;
  const XTextSmall({
    super.key,
    this.colortext = eventPrimaryColor,
    required this.label,
    this.decoration,
    this.maxLines,
    this.overFlowText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: colortext,
        fontSize: TsFontSize.small,
        fontWeight: FontWeight.bold,
      ),
      maxLines: maxLines,
      overflow: overFlowText,
    );
  }
}

class TsTextExtraSmall extends StatelessWidget {
  final String label;
  final Color colortext = eventPrimaryColor;
  final TextDecoration? decoration;
  const TsTextExtraSmall({
    super.key,
    required this.label,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: colortext,
        fontSize: TsFontSize.extraSmall,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
