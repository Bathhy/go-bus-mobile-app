import '../../../core/utils/image_helper.dart';
import '../../../models/profile/profile_model.dart';

class ProfileState {
  final bool isLoading;
  final ProfileModel? profileModel;
  final String currentLanguage;

  ProfileState({
    this.isLoading = false,
    this.profileModel = const ProfileModel(),
    this.currentLanguage = 'en',
  });

  String get imageUrl {
    return getImageUrl(profileModel?.image);
  }

  ProfileState copyWith({
    bool? isLoading,
    ProfileModel? profileModel,
    String? currentLanguage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileModel: profileModel ?? this.profileModel,
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }
}
