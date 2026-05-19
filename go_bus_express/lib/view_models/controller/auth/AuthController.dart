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
    // Use WidgetsBinding to ensure we're in the right context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error',
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                ),
                Text(message, style: TextStyle(color: white)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _showSuccess(String message) {
    // Use WidgetsBinding to ensure we're in the right context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Success',
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                ),
                Text(message, style: TextStyle(color: white)),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
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
          final authData = result.data;
          if (authData?.token != null) {
            await _localRepository.saveToken(authData!.token!);
            if (authData.refreshToken != null) {
              await _localRepository.saveRefreshToken(authData.refreshToken!);
            }
          }
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
  Future<void> signup(String email, String password, String username, String phone) async {
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
        userName: username,
        phone: phone,
      );

      final result = await _repository.signup(body: body);

      switch (result) {
        case Success<AuthModel?>():
          final authData = result.data;
          if (authData?.token != null) {
            await _localRepository.saveToken(authData!.token!);
            if (authData.refreshToken != null) {
              await _localRepository.saveRefreshToken(authData.refreshToken!);
            }
          }
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
