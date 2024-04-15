import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  const CustomLabel({
    this.text,
    this.textStyle,
    this.size = 14,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontFamily = '',
    this.alignment = TextAlign.left,
    this.maxlines = 1,
    this.underline = false,
    Key? key,
  }) : super(key: key);

  final dynamic text;
  final TextStyle? textStyle; // Add a textStyle property.
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextAlign alignment;
  final int maxlines;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    TextStyle finalTextStyle = textStyle ??
        TextStyle(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          decoration: underline ? TextDecoration.underline : TextDecoration.none,
        );

    return Text(
      text,
      maxLines: maxlines,
      textAlign: alignment,
      style: finalTextStyle,
    );
  }
}
