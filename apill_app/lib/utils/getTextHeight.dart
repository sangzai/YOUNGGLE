import 'package:flutter/material.dart';

double getTextHeight(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 4, // Adjust as needed
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.height;
}