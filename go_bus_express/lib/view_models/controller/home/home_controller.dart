import 'dart:convert';
import 'dart:developer';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/repository/profile_repository.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/home/home_state.dart';
import 'package:shared_package/network/x_result.dart';

class HomeController extends BaseController<HomeState> {
  final ProfileRepository _repository;
  final LocalRepository _localRepository;

  HomeController(this._repository, this._localRepository) : super(HomeState());

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    // Set loading
    updateState((state) => state.copyWith(isLoading: true));
    final result = await _repository.fetchProfile();

    switch (result) {
      case Success<ProfileModel?>():
        // Update profile
        updateState(
          (state) =>
              state.copyWith(isLoading: false, profileModel: result.data),
        );

        if (result.data != null) {
          final profileJson = jsonEncode(result.data!.toJson());
          await _localRepository.saveProfile(profileJson);
        }
      case Error<ProfileModel?>():
        // Error
        updateState((state) => state.copyWith(isLoading: false));
        log('Profile error: ${result.error}');
    }
  }
}
