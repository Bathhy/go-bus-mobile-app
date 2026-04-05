import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view/edit_profile/model/edit_profile_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/editProfile/edit_profile_state.dart';
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
    // Set loading
    updateState((state) => state.copyWith(isLoading: true));

    try {
      final File? image = state.selectedImage;
      final body = UpdateProfileBody(email, fullName, phoneNumber);
      final result = await _repository.updateProfile(body, image);

      switch (result) {
        case Success<ProfileModel?>():
          if (result.data != null) {
            final profileJson = jsonEncode(result.data!.toJson());
            await _localRepository.saveProfile(profileJson);

            // Stop loading before showing success message
            updateState((state) => state.copyWith(isLoading: false));

            // Show success message using Get.rawSnackbar
            Get.rawSnackbar(
              title: 'Success'.tr,
              message: 'Profile updated successfully'.tr,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF4CAF50),
              borderRadius: 8,
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            );

            // Navigate back after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.back(result: true);
            });
          } else {
            updateState((state) => state.copyWith(isLoading: false));
          }
        case Error<ProfileModel?>():
          updateState((state) => state.copyWith(isLoading: false));
          log('Profile error: ${result.error.displayMessage}');

          // Show error message using Get.rawSnackbar
          Get.rawSnackbar(
            title: 'Error'.tr,
            message: result.error.displayMessage ?? 'Failed to update profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          );
      }
    } catch (e) {
      updateState((state) => state.copyWith(isLoading: false));
      log('Profile update exception: $e');

      Get.rawSnackbar(
        title: 'Error'.tr,
        message: 'An unexpected error occurred'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
