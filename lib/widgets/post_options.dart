import 'package:flutter/material.dart';

class PostOptions extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  const PostOptions({
    Key? key,
    required this.icon,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}
