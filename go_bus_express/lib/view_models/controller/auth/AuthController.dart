import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/base_share_preference.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/auth/auth_model.dart';
import 'package:go_bus_express/models/body/auth_body.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../repository/auth_repository.dart';
import '../../../resources/routes/app_routes.dart';
import '../base/base_controller.dart';
import 'AuthState.dart';

class AuthController extends BaseController<AuthState> {
  final AuthRepository _repository;
  final LocalRepository _localRepository;

  AuthController(this._repository, this._localRepository) : super(AuthState());

  Future<void> login(String email, String password) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Validate email format
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.red,
        colorText: white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Set loading state
    updateState((state) => state.copyWith(null, true));

    try {
      final body = LoginBody(email: email, password: password);
      final result = await _repository.login(body: body);

      switch (result) {
        case Success<AuthModel?>():
          {
            _localRepository.saveToken(result.data?.token ?? "");
            Get.offAllNamed(AppRoutes.mainNavigation);
            log("Login success >>>>>>>> ${result.data?.token}");
          }

        case Error<AuthModel?>():
          // Error - show message
          log("Login error: ${result.error}");
          Get.snackbar(
            'Error',
            result.error.displayMessage,
            backgroundColor: Colors.red,
            colorText: white,
            snackPosition: SnackPosition.TOP,
          );
      }
    } finally {
      updateState((state) => state.copyWith(null, false));
    }
  }
}
