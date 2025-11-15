import 'package:flutter/material.dart';
import 'package:shared_package/config/themes.dart';

class XAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final String? subTitle;
  final String title;
  final void Function()? onBackPressed;
  const XAppBar({
    super.key,
    this.actions,
    this.subTitle,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: goBusPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackPressed,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          subTitle != null
              ? Text(
                subTitle!,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              )
              : SizedBox.shrink(),
        ],
      ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.calendar_month, color: Colors.white),
      //     onPressed: () {
      //       _showDatePicker(context);
      //     },
      //   ),
      // ],
      actions: actions,
    );
  }
}
