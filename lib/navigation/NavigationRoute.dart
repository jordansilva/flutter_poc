import 'package:flutter/material.dart';

class NavigationRoute<T> extends MaterialPageRoute<T> {
  NavigationRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;

    // Fades between routes. (If you don't want any animation, just return child.)
    return new SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .animate(animation), child: child);
  }
}
