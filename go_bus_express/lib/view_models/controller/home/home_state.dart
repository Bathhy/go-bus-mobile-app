import 'package:go_bus_express/core/base/base_ui_state.dart';
import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';

import '../../../models/home/all_route_model.dart';

class HomeState extends BaseUiState {
  final ProfileModel? profileModel;
  final String? profileImageUrl;
  final List<AllRouteModel> routes;
  final bool isLoadingRoutes;
  final int? selectedRouteId;
  final String? selectedRouteOrigin;
  final String? selectedRouteDestination;
  final String selectedCountry;
  final DateTime? departureDate;
  final DateTime? returnDate;

  HomeState({
    super.isLoading = false,
    this.profileModel = const ProfileModel(),
    this.profileImageUrl,
    this.routes = const [],
    this.isLoadingRoutes = false,
    this.selectedRouteId,
    this.selectedRouteOrigin,
    this.selectedRouteDestination,
    this.selectedCountry = 'Cambodia',
    this.returnDate,
    DateTime? departureDate,
  }) : departureDate = departureDate ?? DateTime.now();

  HomeState copyWith({
    bool? isLoading,
    ProfileModel? profileModel,
    String? profileImageUrl,
    List<AllRouteModel>? routes,
    bool? isLoadingRoutes,
    int? selectedRouteId,
    String? selectedRouteOrigin,
    String? selectedRouteDestination,
    String? selectedCountry,
    DateTime? departureDate,
    DateTime? returnDate,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      profileModel: profileModel ?? this.profileModel,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      routes: routes ?? this.routes,
      isLoadingRoutes: isLoadingRoutes ?? this.isLoadingRoutes,
      selectedRouteId: selectedRouteId ?? this.selectedRouteId,
      selectedRouteOrigin: selectedRouteOrigin ?? this.selectedRouteOrigin,
      selectedRouteDestination:
          selectedRouteDestination ?? this.selectedRouteDestination,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
    );
  }
}
