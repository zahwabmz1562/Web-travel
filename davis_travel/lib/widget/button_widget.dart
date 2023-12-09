import 'package:davis_travel/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? iconData;
  final Color? iconColor;
  final bool isLoading;
  final double width;
  final double height;
  final double fontSize;
  final double? radius;

  const ButtonWidget({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.iconData,
    this.iconColor,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
    this.fontSize = 18,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(width, height),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)),
          side: BorderSide(
            color: borderColor ?? colorPrimary,
          ),
        ),
        backgroundColor: backgroundColor ?? colorPrimary,
      ),
      onPressed: isLoading
          ? null
          : () {
              onPressed();
            },
      child: isLoading
          ? CupertinoActivityIndicator(
              color: textColor ?? colorWhite,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconData != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Icon(
                      iconData,
                      size: 20,
                      color: iconColor ?? colorPrimary,
                    ),
                  ),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor ?? colorWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
    );
  }
}
