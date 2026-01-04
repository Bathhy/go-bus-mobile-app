import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view/edit_profile/model/edit_profile_model.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/editProfile/edit_profile_state.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_state.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../core/storage/local_repository.dart';
import '../../../models/body/update_profile_body.dart';
import '../../../models/profile/profile_model.dart';
import '../../../resources/localizations/app_localization.dart';
import '../../../resources/routes/app_routes.dart';

class EditProfileController extends BaseController<EditProfileState> {
  final ProfileRepository _repository;
  final LocalRepository _localRepository;

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

    updateState(
      (state) => state.copyWith(
        profileModel: EditProfileModel(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
        ),
      ),
    );
  }

  void updateProfile(String email, String fullName, String phoneNumber) async {
    // Set loading
    updateState((state) => state.copyWith(isLoading: true));
    final body = UpdateProfileBody(email, fullName, phoneNumber);
    final result = await _repository.updateProfile(body);

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
