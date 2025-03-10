import 'package:ember_bus_trip_view/cubits/simple_bloc_observer.dart';
import 'package:ember_bus_trip_view/utils/app_utils.dart';
import 'package:ember_bus_trip_view/views/trip_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(const EmberBusTripViewApp());
}

class EmberBusTripViewApp extends StatelessWidget {
  const EmberBusTripViewApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ember Bus Trip View',
      theme: AppUtils.appTheme,
      home: const TripListPage(),
    );
  }
}
