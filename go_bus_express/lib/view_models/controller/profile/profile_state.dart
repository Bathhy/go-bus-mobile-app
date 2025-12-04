import '../../../models/profile/profile_model.dart';

class ProfileState {
  final bool isLoading;
  final ProfileModel? profileModel;

  ProfileState({this.isLoading = false, this.profileModel});

  ProfileState copyWith({bool? isLoading, ProfileModel? profileModel}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileModel: profileModel ?? this.profileModel,
    );
  }
}
