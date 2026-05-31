import '../../../core/utils/image_helper.dart';
import '../../../models/profile/profile_model.dart';

class ProfileState {
  final bool isLoading;
  final ProfileModel? profileModel;
  final String currentLanguage;
  final String? profileImageUrl;

  ProfileState({
    this.isLoading = false,
    this.profileModel = const ProfileModel(),
    this.currentLanguage = 'en',
    this.profileImageUrl,
  });

  // Use signed URL from /profile/image/url if available, otherwise fall back
  String get imageUrl {
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return profileImageUrl!;
    }
    return getImageUrl(profileModel?.image);
  }

  ProfileState copyWith({
    bool? isLoading,
    ProfileModel? profileModel,
    String? currentLanguage,
    String? profileImageUrl,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileModel: profileModel ?? this.profileModel,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
