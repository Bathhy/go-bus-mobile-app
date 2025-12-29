import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  /* -------------------- SNACKBARS -------------------- */
  void _showError(String message) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();

    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        titleText: Text(
          'Error',
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(message, style: TextStyle(color: white)),
      ),
    );
  }

  void _showSuccess(String message) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();

    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        titleText: Text(
          'Success',
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(message, style: TextStyle(color: white)),
      ),
    );
  }

  /* -------------------- LOGIN -------------------- */
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showError('Please enter a valid email');
      return;
    }

    updateState((state) => state.copyWith(null, true));

    try {
      final body = LoginBody(email: email, password: password);
      final result = await _repository.login(body: body);

      switch (result) {
        case Success<AuthModel?>():
          _localRepository.saveToken(result.data?.token ?? "");
          Get.offAllNamed(AppRoutes.mainNavigation);
          log("Login success >>> ${result.data?.token}");
          break;

        case Error<AuthModel?>():
          log("Login error >>> ${result.error}");
          _showError(result.error.displayMessage);
          break;
      }
    } finally {
      updateState((state) => state.copyWith(null, false));
    }
  }

  /* -------------------- SIGN UP -------------------- */
  Future<void> signup(String email, String password, String username) async {
    // if (email.isEmpty || password.isEmpty || username.isEmpty) {
    //   _showError('Please fill in all fields');
    //   return;
    // }
    //
    // if (!GetUtils.isEmail(email)) {
    //   _showError('Please enter a valid email');
    //   return;
    // }
    //
    // if (password.length < 6) {
    //   _showError('Password must be at least 6 characters');
    //   return;
    // }

    updateState((state) => state.copyWith(null, true));

    try {
      final body = SignupBody(
        email: email,
        password: password,
        fullName: username,
      );

      final result = await _repository.signup(body: body);

      switch (result) {
        case Success<AuthModel?>():
          Get.back();
          log("Signup success >>> ${result.data?.token}");
          _showSuccess('Account created successfully');
          break;

        case Error<AuthModel?>():
          log("Signup error >>> ${result.error}");
          _showError(result.error.toString());
          break;
      }
    } finally {
      updateState((state) => state.copyWith(null, false));
    }
  }
}
