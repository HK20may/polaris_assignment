import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/utils/routes/routes.dart';
import 'package:polaris_assignment/presentation/screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? routeName = settings.name;

    final Widget widget;
    switch (routeName) {
      case Routes.HOME:
        widget = const HomeScreen();
        break;

      default:
        widget = const SizedBox();
        break;
    }

    return MaterialPageRoute(
      builder: (_) => widget,
      settings: RouteSettings(name: routeName),
    );
  }
}
