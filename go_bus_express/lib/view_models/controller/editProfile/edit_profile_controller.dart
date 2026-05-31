import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view/edit_profile/model/edit_profile_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/editProfile/edit_profile_state.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../core/storage/local_repository.dart';
import '../../../models/body/update_profile_body.dart';
import '../../../models/profile/profile_model.dart';

class EditProfileController extends BaseController<EditProfileState> {
  final ProfileRepository _repository;
  final LocalRepository _localRepository;
  final ImagePicker _imagePicker = ImagePicker();

  EditProfileController(this._repository, this._localRepository)
    : super(EditProfileState());

  @override
  void onInit() {
    _initializeFromArguments();
    super.onInit();
  }

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      log('❌ No arguments passed to ChoosePaymentController');
      return;
    }

    // Extract data from arguments
    final fullName = args['fullName'] as String? ?? '';
    final email = args['email'] as String? ?? '';
    final phoneNumber = args['phone'] as String? ?? "";
    final imageFullUrl = args['image'] as String? ?? "";

    updateState(
      (state) => state.copyWith(
        profileModel: EditProfileModel(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          imageFullUrl: imageFullUrl,
        ),
      ),
    );
  }

  /// MARK - Image Pick From Phone Gallery

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        log('✅ Image picked from gallery: ${pickedFile.path}');
        final File imageFile = File(pickedFile.path);
        updateState((state) => state.copyWith(selectedImage: imageFile));
      }
    } catch (e) {
      log('Profile error: $e');
    }
  }

  /// MARK - Image Pick From Phone Camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        log('Photo taken: ${pickedFile.path}');
        final File imageFile = File(pickedFile.path);
        updateState((state) => state.copyWith(selectedImage: imageFile));
      }
    } catch (e) {
      log('Profile error: $e');
    }
  }

  void updateProfile(String email, String fullName, String phoneNumber) async {
    updateState((state) => state.copyWith(isLoading: true));

    try {
      final File? image = state.selectedImage;
      final body = UpdateProfileBody(email, fullName, phoneNumber);

      // Run both calls in parallel when image is selected
      final results = await Future.wait([
        _repository.updateProfile(body),
        if (image != null) _repository.uploadProfileImage(image),
      ]);

      final profileResult = results[0];
      final imageResult = image != null ? results[1] : null;

      // Check for errors
      if (profileResult is Error<ProfileModel?>) {
        updateState((state) => state.copyWith(isLoading: false));
        log('Profile error: ${profileResult.error.displayMessage}');
        _showError(profileResult.error.displayMessage ?? 'Failed to update profile');
        return;
      }

      if (imageResult is Error<ProfileModel?>) {
        updateState((state) => state.copyWith(isLoading: false));
        log('Image upload error: ${imageResult.error.displayMessage}');
        _showError(imageResult.error.displayMessage ?? 'Failed to upload image');
        return;
      }

      // Use image result if available, otherwise use profile result
      final updatedProfile = (imageResult as Success<ProfileModel?>?)?.data
          ?? (profileResult as Success<ProfileModel?>).data;

      if (updatedProfile != null) {
        final profileJson = jsonEncode(updatedProfile.toJson());
        await _localRepository.saveProfile(profileJson);

        updateState((state) => state.copyWith(isLoading: false));

        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Success'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Profile updated successfully'.tr),
                ],
              ),
              backgroundColor: const Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }

        // Refresh home screen so profile image updates immediately
        try {
          await Get.find<HomeController>().fetchProfile();
        } catch (_) {}

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back(result: true);
        });
      } else {
        updateState((state) => state.copyWith(isLoading: false));
      }
    } catch (e) {
      updateState((state) => state.copyWith(isLoading: false));
      log('Profile update exception: $e');
      _showError('An unexpected error occurred');
    }
  }

  void _showError(String message) {
    if (Get.context == null) return;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Error'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
