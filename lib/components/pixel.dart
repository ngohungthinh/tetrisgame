import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  final Color? color;

  const Pixel({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      margin: EdgeInsets.all(1),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    );
  }
}
