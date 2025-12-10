import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';

class RouteSelectionDialog {
  static void show(HomeController controller) {
    // Fetch routes from backend only if cache is empty
    if (controller.state.routes.isEmpty && !controller.state.isLoadingRoutes) {
      controller.fetchRoutes();
    }

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildRouteList(controller),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Select Route',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  static Widget _buildRouteList(HomeController controller) {
    return Obx(() {
      if (controller.state.isLoadingRoutes) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        );
      }

      if (controller.state.routes.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No routes available'),
        );
      }

      return Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.state.routes.length,
          itemBuilder: (context, index) {
            final route = controller.state.routes[index];
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions_bus,
                  color: Colors.blue[700],
                ),
              ),
              title: Text(
                '${route.origin} → ${route.destination}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${route.distanceKm} km • ${route.durationMinutes} min',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                controller.selectRoute(route);
                Get.back();
              },
            );
          },
        ),
      );
    });
  }
}
