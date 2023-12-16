import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';

class AppLayout {
  static InputBorder inactiveBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.text,
        width: 2,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }

  static InputBorder activeBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 4,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }

  static ShapeBorder cardBorder({double borderRadius = 10, dynamic borderColor = Colors.white, double borderWidth = 1}) {
    return RoundedRectangleBorder(
      side: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static Widget colorAdaptivText(text, {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: TextStyle(color: colorScheme.text, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  static Widget primaryText(text, {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: TextStyle(color: colorScheme.primary, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}