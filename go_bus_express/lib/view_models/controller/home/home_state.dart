import 'package:go_bus_express/models/profile/profile_model.dart';

class HomeState {
  final bool isLoading;
  final ProfileModel? profileModel;

  HomeState({
    this.isLoading = false,
    this.profileModel,
  });

  HomeState copyWith({
    bool? isLoading,
    ProfileModel? profileModel,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      profileModel: profileModel ?? this.profileModel,
    );
  }
}
