import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:shared_package/config/themes.dart';
import 'package:shared_package/design_system/constant/ts_padding.dart';
import 'package:shared_package/design_system/x_widget/x_app_bar.dart';
import 'package:shared_package/design_system/x_widget/x_location_title.dart';

class SelectRouteView extends StatelessWidget {
  const SelectRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: XAppBar(
          title: 'Phnom Penh → Siem Reap',
          subTitle: "2025-10-08",
          onBackPressed: () => Navigator.of(context).pop(),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              onPressed: () {
                _showDatePicker(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTripInfo(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder:
                  (context, index) => _buildBusCard(
                    departureTime: '17:30',
                    arrivalTime: '23:30',
                    duration: '6:00 h',
                    price: '\$13:00',
                    availableSeats: '4/15 Seats',
                    departureLocation: 'Boarding: Phnom Penh, France St. 47,',
                    arrivalLocation: 'Boarding: Siem Reap, Phuemy St. 80',
                  ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
  }

  Widget _buildTripInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Select Time',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Text(
            '10 Available Trips',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBusCard({
    required String departureTime,
    required String arrivalTime,
    required String duration,
    required String price,
    required String availableSeats,
    required String departureLocation,
    required String arrivalLocation,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/image 18.png', width: 24, height: 24),
              const SizedBox(width: 12),
              const Text(
                'Minivan 15 seats',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Text(
                availableSeats,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure Time',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    departureTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              _buildTimeLineArrow(duration),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Arrival',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    arrivalTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              XLocationTitle(localtion: departureLocation),
              XLocationTitle(localtion: arrivalLocation),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey.shade300,
            child: Row(
              children: List.generate(
                20,
                (index) => Expanded(
                  child: Container(
                    color:
                        index % 2 == 0
                            ? Colors.transparent
                            : Colors.grey.shade300,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: success,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.selectSeat);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: XPadding.extralarge,
                    vertical: XPadding.medium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLineArrow(String duration) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Container(height: 2, color: Colors.black)),
              Container(
                width: 0,
                height: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.transparent, width: 5),
                    right: BorderSide(color: Colors.black, width: 8),
                    bottom: BorderSide(color: Colors.transparent, width: 5),
                  ),
                ),
              ),
            ],
          ),
          Text(
            duration,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// class XAppBar extends StatelessWidget {
//   const XAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(kToolbarHeight),
//       child: AppBar(
//         backgroundColor: goBusPrimary,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: const [
//             Text(
//               'Phnom Penh → Siem Reap',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               '2025-10-08',
//               style: TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_month, color: Colors.white),
//             onPressed: () {
//               _showDatePicker(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
