import 'package:flutter/material.dart';

// Single route for on the fly creation
class CustomRouteTransition<T> extends MaterialPageRoute<T> {
  // 'MaterialPageRoute<T>' is a generic class.
  // '<T>' is the placeholder for the generic type.
  // Since, 'MaterialPageRoute<T>' is a generic class,
  // 'CustomRouteTransition<T>' should also be generic.
  CustomRouteTransition({
    WidgetBuilder builder,
    RouteSettings settings,
    // 'RouteSettings' holds the basic route settings.
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // TODO: implement buildTransitions
    // 'buildTransitions()' controls how the page transition is animated.
    if (settings.name == "/") {
      return child;
      // Home screen will not be animated.
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// General theme that affects all route transitions
class CustomPageRouteTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route, // Works with different routes
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // TODO: implement buildTransitions
    // 'buildTransitions()' controls how the page transition is animated.
    if (route.settings.name == "/") {
      return child;
      // Home screen will not be animated.
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
