import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute(
      {required WidgetBuilder widgetBuilder,
    RouteSettings? routeSettings})
      : super(
          builder: widgetBuilder,
          settings: routeSettings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/'){
      return child;
    }
    return FadeTransition(opacity: animation , child: child,);
  }
}

class CustomePageTranstionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route ,
      BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (route.settings.name == '/'){
      return child;
    }
    return FadeTransition(opacity: animation , child: child,);
  }
}