import 'dart:developer';
import 'package:get/get.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view_models/controller/home/home_state.dart';
import 'package:shared_package/network/x_result.dart';

class HomeController extends GetxController {
  final ProfileRepository _repository;

  HomeController(this._repository);

  // State
  final Rx<HomeState> _state = HomeState().obs;
  HomeState get state => _state.value;

  void emit(HomeState newState) {
    _state.value = newState;
  }

  void updateState(HomeState Function(HomeState state) reducer) {
    emit(reducer(_state.value));
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    // Set loading
    updateState((state) => state.copyWith(isLoading: true));

    try {
      final result = await _repository.fetchProfile();

      switch (result) {
        case Success<ProfileModel>():
          // Update profile
          updateState((state) => state.copyWith(
                isLoading: false,
                profileModel: result.data,
              ));
          log('Profile fetched: ${result.data.fullName}');

        case Error<ProfileModel>():
          // Error
          updateState((state) => state.copyWith(isLoading: false));
          log('Profile error: ${result.error}');
      }
    } catch (e) {
      updateState((state) => state.copyWith(isLoading: false));
      log('Profile exception: $e');
    }
  }
}