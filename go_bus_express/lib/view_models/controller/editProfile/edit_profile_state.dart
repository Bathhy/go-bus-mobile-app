import 'package:go_bus_express/view/edit_profile/model/edit_profile_model.dart';

import '../../../models/profile/profile_model.dart';

class EditProfileState {
  final bool isLoading;
  final EditProfileModel profileModel;

  EditProfileState({
    this.isLoading = false,
    this.profileModel = const EditProfileModel(),
  });

  EditProfileState copyWith({
    bool? isLoading,
    EditProfileModel? profileModel,
    String? currentLanguage,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      profileModel: profileModel ?? this.profileModel,
    );
  }
}
