import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_controller.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/AppImage.dart';
import 'package:shared_package/design_system/x_widget/ButtonComponent.dart';
import 'package:shared_package/design_system/x_widget/TextComponent.dart';
import 'package:shared_package/design_system/x_widget/user_profile_card.dart';

import '../../../core/di/app_di.dart';
import '../../../utils/enums/image_type_enum.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final ProfileController controller = getIt<ProfileController>();

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: primaryBgColor,
      appBar: AppBar(
        backgroundColor: primaryBgColor,
        title: Text(
          'Profile'.tr,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (controller.state.profileModel != null) {
                        return UserProfileCard(
                          name: controller.state.profileModel!.fullName ?? "",
                          email: controller.state.profileModel!.email ?? "",
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: 24),
                    _buildMenuItem(
                      context: context,
                      imageType: ImageType.iconData,
                      source: Icons.person_outline,
                      iconColor: Colors.orange,
                      title: 'Edit Profile'.tr,
                      onTap: () async {
                        final result = await Get.toNamed(
                          AppRoutes.editProfile,
                          arguments: {
                            'fullName': controller.state.profileModel?.fullName,
                            'email': controller.state.profileModel?.email,
                            'phone': controller.state.profileModel?.phone,
                          },
                        );

                        if (result == true || result != null) {
                          controller.refreshProfile();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context: context,
                      imageType: ImageType.svgImage,
                      source: AppImages.imgLanguage,
                      iconColor: Colors.purple,
                      title: 'Languages'.tr,
                      onTap: () {
                        _showLanguageBottomSheet(context, controller);
                      },
                    ),
                    /*  const SizedBox(height: 12),
                    _buildMenuItem(
                      context: context,
                      imageType: ImageType.iconData,
                      source: Icons.history,
                      iconColor: Colors.blue,
                      title: 'Booking History'.tr,
                      onTap: () {
                        Get.toNamed(AppRoutes.bookingHistory);
                      },
                    ),*/
                    const SizedBox(height: 36),
                    _buildLogoutButton(context, controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required ImageType imageType,
    required dynamic source,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: shimerBgColor,
                child: _buildDynamicIcon(
                  imageType: imageType,
                  source: source,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    ProfileController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
      child: GestureDetector(
        onTap: () {
          _showLogoutDialog(context, controller);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: XPadding.large),
          decoration: BoxDecoration(
            color: errorPrimary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: XPadding.extralarge),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.logout, color: errorPrimary),
                ),
                SizedBox(width: 12),
                XTextMedium(label: 'Logout'.tr, colortext: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicIcon({
    required ImageType imageType,
    required dynamic source,
    required Color color,
    double size = 24.0,
  }) {
    switch (imageType) {
      case ImageType.iconData:
        return Icon(source as IconData, color: color, size: size);

      case ImageType.svgImage:
        return AppSvgImage(path: source as String, width: size, height: size);
    }
  }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(XPadding.extralarge),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gradient background
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [errorPrimary.withOpacity(0.8), errorPrimary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: errorPrimary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              SizedBox(height: XPadding.extralarge),

              // Title
              XTextLarge(
                label: 'Logout'.tr,
                colortext: black,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: XPadding.medium),

              // Message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: XPadding.medium),
                child: Text(
                  'logout'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: XPadding.extralarge + XPadding.medium),

              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: XPadding.large),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: XTextMedium(
                            label: 'Cancel'.tr,
                            colortext: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: XPadding.large),

                  // Logout Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.logout();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: XPadding.large),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              errorPrimary.withOpacity(0.9),
                              errorPrimary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: errorPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: XTextMedium(
                            label: 'Yes'.tr,
                            colortext: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    ProfileController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.all(XPadding.extralarge),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              XTextLarge(
                label: 'Choose Your Language'.tr,
                colortext: black,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: XPadding.extralarge),

              // Khmer option
              Obx(() {
                final currentLanguage = controller.state.currentLanguage;
                return GestureDetector(
                  onTap: () async {
                    await controller.changeLanguage('km');
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(XPadding.extralarge),
                    decoration: BoxDecoration(
                      color: currentLanguage == 'km'
                          ? goBusPrimary
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        AppSvgImage(
                          width: 25,
                          height: 25,
                          path: AppImages.imgKhLang,
                          defaultColor: true,
                        ),
                        SizedBox(width: XPadding.large),
                        XTextMedium(
                          label: 'ខ្មែរ',
                          colortext: currentLanguage == 'km' ? white : black,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: XPadding.extralarge),

              // English option
              Obx(() {
                final currentLanguage = controller.state.currentLanguage;
                return GestureDetector(
                  onTap: () async {
                    await controller.changeLanguage('en');
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(XPadding.extralarge),
                    decoration: BoxDecoration(
                      color: currentLanguage == 'en'
                          ? goBusPrimary
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        AppSvgImage(
                          path: AppImages.imgEngLang,
                          height: 25,
                          width: 25,
                          defaultColor: true,
                        ),
                        SizedBox(width: XPadding.large),
                        XTextMedium(
                          label: 'English',
                          colortext: currentLanguage == 'en' ? white : black,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: XPadding.extralarge),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: XButton(
                  label: 'Cancel'.tr,
                  optionbutton: 1,
                  bgColor: goBusPrimary,
                  onTap: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
