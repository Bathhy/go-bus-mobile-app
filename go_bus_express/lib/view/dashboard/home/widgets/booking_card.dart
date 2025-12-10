import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/di/app_di.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';
import 'package:intl/intl.dart';
import 'route_selection_dialog.dart';
import 'country_selection_dialog.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = getIt<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[600]!, Colors.blue[700]!],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Obx(() {
              final hasRoute = homeController.state.selectedRouteId != null;
              final routeText = hasRoute
                  ? '${homeController.state.selectedRouteOrigin} → ${homeController.state.selectedRouteDestination}'
                  : 'Choose Direction';
              return GestureDetector(
                onTap: () => RouteSelectionDialog.show(homeController),
                child: _buildDirectionRow(routeText, Icons.flag_outlined),
              );
            }),
            const SizedBox(height: 12),
            Obx(() {
              final selectedCountry = homeController.state.selectedCountry;
              return GestureDetector(
                onTap: () => CountrySelectionDialog.show(homeController),
                child: _buildDirectionRow(
                  selectedCountry,
                  Icons.public,
                ),
              );
            }),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Obx(() => GestureDetector(
                        onTap: () => _selectDepartureDate(context, homeController),
                        child: _buildDatePicker(
                          'Departure Date',
                          homeController.state.departureDate != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(homeController.state.departureDate!)
                              : 'Select Date',
                        ),
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => GestureDetector(
                        onTap: () => _selectReturnDate(context, homeController),
                        child: _buildDatePicker(
                          'Return Date',
                          homeController.state.returnDate != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(homeController.state.returnDate!)
                              : 'Select Date',
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _handleSearch(context, homeController),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[700],
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionRow(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                date,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDepartureDate(
    BuildContext context,
    HomeController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.state.departureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.selectDepartureDate(picked);
      
      // If return date is before departure date, clear it
      if (controller.state.returnDate != null &&
          controller.state.returnDate!.isBefore(picked)) {
        controller.selectReturnDate(picked);
      }
    }
  }

  Future<void> _selectReturnDate(
    BuildContext context,
    HomeController controller,
  ) async {
    final DateTime initialDate = controller.state.returnDate ??
        controller.state.departureDate ??
        DateTime.now();
    
    final DateTime firstDate = controller.state.departureDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.selectReturnDate(picked);
    }
  }

  void _handleSearch(BuildContext context, HomeController controller) {
    final params = controller.getSearchParams();
    
    if (params == null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select route, departure and return dates'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Navigate with parameters
    Get.toNamed(
      AppRoutes.selectRoute,
      arguments: params,
    );
  }
}
