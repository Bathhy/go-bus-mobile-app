import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';

import '../../../../resources/app_images.dart';
import 'home_app_bar.dart';

class NeedHelpSection extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapTelegram;

  const NeedHelpSection({super.key, this.onTap, this.onTapTelegram});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need Help?'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: goBusPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                AppSvgImage(
                  path: AppImages.icCustomerSupport,
                  width: 35,
                  height: 35,
                  defaultColor: true,
                ),
                SizedBox(width: XPadding.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need Help?'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'We are always here to help'.tr,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    XSocialButton(
                      icon: Icons.telegram,
                      color: Colors.blue,
                      onTap: onTapTelegram,
                    ),
                    const SizedBox(width: 12),
                    XSocialButton(
                      icon: Icons.phone,
                      color: Colors.green,
                      onTap: onTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
