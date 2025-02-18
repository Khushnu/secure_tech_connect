import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? textSize;
  final FontWeight? fontWeight;
  const TextWidget({super.key, required this.text, this.textColor, this.textSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor ?? Colors.black, fontSize: textSize ?? 14, 
        fontWeight: fontWeight ?? FontWeight.normal 
      ),
    );
  }
}