import 'package:flutter/material.dart';

import '../../config/themes.dart';
import '../constant/ts_padding.dart';

class XTextfield extends StatelessWidget {
  const XTextfield({
    super.key,
    this.label,
    this.controller,
    this.obscureTextl = false,
    this.icondata,
    this.colorIcon,
    this.iconsize,
    this.onpress,
    this.keyboardType,
    required this.titletextfield,
    this.prefixicon,
    this.bgcolor = const Color(0xFFF0F4FF),
    this.radiuschoice = 1,
    this.border = InputBorder.none,
    this.onDone,
    this.autofocus = false,
    this.enablePrefixIcon = false,
    this.onChanged,
  });
  final String titletextfield;
  final InputBorder? border;
  final void Function(String)? onDone;
  final String? label;
  final bool obscureTextl;
  final TextEditingController? controller;
  final IconData? icondata;
  final IconData? prefixicon;
  final Color? colorIcon;
  final double? iconsize;
  final VoidCallback? onpress;
  final TextInputType? keyboardType;
  final Color? bgcolor;
  final int? radiuschoice;
  final bool autofocus;
  final bool enablePrefixIcon;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titletextfield.isNotEmpty
            ? Text(
              titletextfield,
              style: const TextStyle(color: eventPrimaryColor),
            )
            : const SizedBox.shrink(),
        SizedBox(height: XPadding.medium),
        Container(
          decoration: BoxDecoration(
            color: bgcolor,
            border: Border.all(color: black),
            borderRadius:
                radiuschoice == 1
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(10),
          ),
          child: TextFormField(
            onChanged: onChanged,
            autofocus: autofocus,
            keyboardType: keyboardType,
            obscureText: obscureTextl,
            controller: controller,
            onFieldSubmitted: onDone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: label,
              contentPadding: EdgeInsets.symmetric(
                vertical: XPadding.extralarge,
                horizontal: XPadding.extralarge + 5,
              ),
              border:
                  border ??
                  OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red, // Border color
                      width: 20, // Border thickness
                    ),
                    borderRadius:
                        radiuschoice == 1
                            ? BorderRadius.circular(20)
                            : BorderRadius.circular(10),
                  ),
              suffixIcon:
                  enablePrefixIcon && icondata != null
                      ? IconButton(
                        onPressed: onpress,
                        icon: Icon(icondata, color: colorIcon, size: iconsize),
                      )
                      : null,
              prefixIcon: prefixicon != null ? Icon(prefixicon) : null,
            ),
          ),
        ),
      ],
    );
  }
}
