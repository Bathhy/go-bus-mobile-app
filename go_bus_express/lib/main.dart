import 'package:flutter/material.dart';
import 'package:go_bus_express/view/ticket/select_route/select_route_view.dart';
import 'package:go_bus_express/view/ticket/select_seat/select_seat_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SelectSeatView(),
    );
  }
}
