import 'package:flutter/material.dart';

class CustomScroll extends StatelessWidget {
  final Widget child;
  final AxisDirection axisDirection;

  CustomScroll({
    this.child,
    this.axisDirection = AxisDirection.down
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: axisDirection,
        color: Colors.grey,
        child: child,
      )
    );
  }
}

