import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget {
  final Widget widget;
  EdgeInsets? padding;
  EdgeInsets? margin;

  ShapeDecoration? shapeDecoration;
  final double height;
  MyAppBar({
    Key? key,
    required this.widget,
    this.padding,
    this.margin,
    this.shapeDecoration,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: shapeDecoration,
      height: height,
      child: widget,
    );
  }
}
