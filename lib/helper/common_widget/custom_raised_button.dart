import 'package:flutter/material.dart';

import 'custom_lable.dart';

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    this.text,
    this.color,
    this.size = 14,
    this.textcolor = Colors.white,
    this.width = 160,
    this.height = 60,
    this.fontsFamily = '',
    this.onpressed,
    this.sidecolor = Colors.blue,
    this.borderRadius = 20,
    this.icon,
    Key? key,
  }) : super(key: key);

  final String? text;
  final double size;
  final Color? color;
  final Color textcolor;
  final double width;
  final double height;
  final String fontsFamily;
  final VoidCallback? onpressed;
  final Color sidecolor;
  final double borderRadius;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: sidecolor,
            width: 1,
          ),
        ),
      ),
      onPressed: onpressed,
      child: icon != null
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          SizedBox(width: 8), // Adjust the spacing between icon and text
          if (text != null) // Add null check here
            CustomLabel(
              fontFamily: fontsFamily,
              text: text!,
              size: size,
              alignment: TextAlign.center,
              color: textcolor,
              fontWeight: FontWeight.bold,
            ),
        ],
      )
          : (text != null) // Add null check here
          ? CustomLabel(
        fontFamily: fontsFamily,
        text: text!,
        size: size,
        alignment: TextAlign.center,
        color: textcolor,
        fontWeight: FontWeight.bold,
      )
          : SizedBox(), // Return an empty SizedBox if both icon and text are null
    );
  }
}
