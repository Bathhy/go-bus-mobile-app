import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/view_models/controller/home/home_controller.dart';

class CountrySelectionDialog {
  static void show(HomeController controller) {
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
            _buildCountryOption(
              controller,
              'Cambodia',
              Icons.flag,
              Colors.blue,
            ),
            _buildCountryOption(
              controller,
              'Non-Cambodia',
              Icons.public,
              Colors.orange,
            ),
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
            'Select Country',
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

  static Widget _buildCountryOption(
    HomeController controller,
    String country,
    IconData icon,
    MaterialColor color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color[700],
        ),
      ),
      title: Text(
        country,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Obx(() => controller.state.selectedCountry == country
          ? Icon(Icons.check_circle, color: Colors.blue[700])
          : const Icon(Icons.chevron_right)),
      onTap: () {
        controller.selectCountry(country);
        Get.back();
      },
    );
  }
}
