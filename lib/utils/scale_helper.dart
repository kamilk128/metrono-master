import 'package:flutter/material.dart';

class ScaleHelper {
  static TextScaler getScaler(String text, TextStyle style, int factor) {
    double width = textWidth(text, style);
    return TextScaler.linear(width > factor ? factor / width : 1);
  }

  static double textWidth(String text, TextStyle style) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }
}
