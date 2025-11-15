import 'package:flutter/material.dart';
import 'package:go_bus_express/resources/app_images.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/xwidget/AppImage.dart';
import 'package:shared_package/design_system/xwidget/ButtonComponent.dart';
import 'package:shared_package/design_system/xwidget/TextComponent.dart';
import 'package:shared_package/design_system/xwidget/user_profile_card.dart';
import 'package:go_bus_express/view/edit_profile/edit_profile_view.dart';

import '../../../utils/enums/ImageType.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var selectedLanguage = 'km';
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Profile',
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
                    const UserProfileCard(
                      name: 'សុប្រ័យ ស៊ុន',
                      email: 'goldammy24k@gmail.com',
                    ),
                    const SizedBox(height: 24),
                    _buildMenuItem(
                      context: context,
                      imageType: ImageType.iconData,
                      source: Icons.person_outline,
                      iconColor: Colors.orange,
                      title: 'Edit Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context: context,
                      imageType: ImageType.svgImage,
                      source: AppImages.icSeat,
                      iconColor: Colors.purple,
                      title: 'Languages',
                      onTap: () {
                        void _showLanguageBottomSheet() {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder:
                                (context) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(XPadding.extralarge),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      XTextLarge(
                                        label: 'Choose Your Language',
                                        colortext: black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: XPadding.extralarge),

                                      // Khmer option
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            XPadding.large,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                selectedLanguage == 'ខ្មែរ'
                                                    ? goBusPrimary
                                                    : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '🇰🇭',
                                                style: TextStyle(fontSize: 32),
                                              ),
                                              SizedBox(width: XPadding.large),
                                              XTextMedium(
                                                label: 'ខ្មែរ',
                                                colortext:
                                                    selectedLanguage == 'ខ្មែរ'
                                                        ? white
                                                        : black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: XPadding.medium),

                                      // English option
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedLanguage = 'English';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            XPadding.large,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                selectedLanguage == 'English'
                                                    ? goBusPrimary
                                                    : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '🇬🇧',
                                                style: TextStyle(fontSize: 32),
                                              ),
                                              SizedBox(width: XPadding.large),
                                              XTextMedium(
                                                label: 'English',
                                                colortext:
                                                    selectedLanguage ==
                                                            'English'
                                                        ? white
                                                        : black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: XPadding.extralarge),

                                      // Cancel button
                                      SizedBox(
                                        width: double.infinity,
                                        child: XButton(
                                          label: 'CANCEL',
                                          optionbutton: 1,
                                          bgColor: goBusPrimary,
                                          onTap: () => Navigator.pop(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context: context,
                      imageType: ImageType.iconData,
                      source: Icons.history,
                      iconColor: Colors.blue,
                      title: 'Booking History',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your existing file: lib/view/dashboard/profile/profile_view.dart
  Widget _buildMenuItem({
    required BuildContext context,
    required ImageType imageType,
    required dynamic source, // Renamed from 'icon' for clarity
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    // The caret was here, this is the updated implementation.
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
                // USE THE DYNAMIC WIDGET BUILDER HERE
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

  // (_buildLogoutButton and the rest of the class...)
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: XPadding.extralarge),
      child: GestureDetector(
        onTap: () {
          // Handle logout
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
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.logout, color: errorPrimary),
                ),
                SizedBox(width: 12),
                XTextMedium(label: 'Log Out', colortext: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // This helper widget decides which image widget to render based on the type.
  Widget _buildDynamicIcon({
    required ImageType imageType,
    required dynamic source, // This will be IconData or a String path/URL
    required Color color,
    double size = 24.0,
  }) {
    switch (imageType) {
      case ImageType.iconData:
        // Source is IconData
        return Icon(source as IconData, color: color, size: size);

      case ImageType.svgImage:
        // Source is a String path to an SVG asset
        return AppSvgImage(path: source as String, width: size, height: size);
    }
  }
}
