import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
mixin RouteHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get navigatorContext => navigatorKey.currentContext!;

  static Future push(String routeName, {Object? args}) {
    return Navigator.of(navigatorContext).pushNamed(
      routeName,
      arguments: args,
    );
  }

  static Future pushReplacement(String routeName, {Object? args}) {
    return Navigator.of(navigatorContext).pushReplacementNamed(
      routeName,
      arguments: args,
    );
  }

  static Future pushAndPopUntil(
    String routeName, {
    String? popUntilRouteName,
    Object? args,
  }) {
    return Navigator.of(navigatorContext).pushNamedAndRemoveUntil(
      routeName,
      popUntilRouteName != null
          ? ModalRoute.withName(popUntilRouteName)
          : (Route<dynamic> route) => false,
      arguments: args,
    );
  }

  static void pop({dynamic args}) {
    Navigator.of(navigatorContext).pop(args);
  }

  static bool canPop() {
    return Navigator.of(navigatorContext).canPop();
  }

  static Future<void> maybePop() {
    return Navigator.of(navigatorContext).maybePop();
  }

  static void popUntil(String routesName) {
    Navigator.of(navigatorContext).popUntil(ModalRoute.withName(routesName));
  }
}
