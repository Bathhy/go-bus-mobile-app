import 'package:go_bus_express/models/profile/profile_model.dart';
import 'package:go_bus_express/models/route/detail_route_model.dart';

import '../../../models/home/all_route_model.dart';

class HomeState {
  final bool isLoading;
  final ProfileModel? profileModel;
  final List<AllRouteModel> routes;
  final bool isLoadingRoutes;
  final int? selectedRouteId;
  final String? selectedRouteOrigin;
  final String? selectedRouteDestination;
  final String selectedCountry;
  final DateTime? departureDate;
  final DateTime? returnDate;

  HomeState({
    this.isLoading = false,
    this.profileModel,
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
