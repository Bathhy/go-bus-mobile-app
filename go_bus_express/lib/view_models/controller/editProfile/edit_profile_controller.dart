import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view/edit_profile/model/edit_profile_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/editProfile/edit_profile_state.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../core/storage/local_repository.dart';
import '../../../models/body/update_profile_body.dart';
import '../../../models/profile/profile_model.dart';
import '../../../resources/localizations/app_localization.dart';
import '../../../resources/routes/app_routes.dart';

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
    final File? image = state.selectedImage;
    final body = UpdateProfileBody(email, fullName, phoneNumber);
    final result = await _repository.updateProfile(body, image);

    switch (result) {
      case Success<ProfileModel?>():
        if (result.data != null) {
          final profileJson = jsonEncode(result.data!.toJson());
          await _localRepository.saveProfile(profileJson);
          Future.delayed(Duration(seconds: 3), () {
            updateState((state) => state.copyWith(isLoading: false));
            Get.back(result: true);
          });
        }
      case Error<ProfileModel?>():
        updateState((state) => state.copyWith(isLoading: false));
        log('Profile error: ${result.error.displayMessage}');
    }
  }
}
