import 'package:ember_bus_trip_view/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DotsLoadingIndicator extends StatelessWidget {
  const DotsLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.threeRotatingDots(color: AppUtils.appPrimaryColor, size: 120);
  }
}
