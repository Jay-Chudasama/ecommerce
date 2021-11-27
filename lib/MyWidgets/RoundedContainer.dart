import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RoundedContainer extends StatelessWidget {
  late Color color;
  late double radius;
  late EdgeInsets padding;
  late EdgeInsets margin;
  late double? width;
  late double? height;

  late Widget child;

  RoundedContainer(
      {required this.child,
      this.color = Colors.white,
      this.radius = 16,
      this.padding = const EdgeInsets.all(16),
      this.margin = const EdgeInsets.all(0),
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    if (height == null && width == null) {
      return Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(radius)),
        child: child,
      );
    }
    if (height == null) {
      return Container(
        width: width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(radius)),
        child: child,
      );
    }
    if (width == null) {
      return Container(
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(radius)),
        child: child,
      );
    }
      return Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(radius)),
        child: child,
      );
  }
}
