import 'package:flutter/material.dart';

class AppColors {
  static const Color appColorBlue = Color(0xFF5d6dbe);
  static const Color appColorBlue10 = Color.fromRGBO(93, 109, 190, 0.1);
  static const Color appColorBlue20 = Color.fromRGBO(93, 109, 190, 0.2);
  static const Color appColorBlue30 = Color.fromRGBO(93, 109, 190, 0.3);
  static const Color appColorBlue40 = Color.fromRGBO(93, 109, 190, 0.4);
  static const Color appColorBlue50 = Color.fromRGBO(93, 109, 190, 0.5);
  static const Color appColorBlue60 = Color.fromRGBO(93, 109, 190, 0.6);
  static const Color appColorBlue70 = Color.fromRGBO(93, 109, 190, 0.7);
  static const Color appColorBlue80 = Color.fromRGBO(93, 109, 190, 0.8);
  static const Color appColorBlue90 = Color.fromRGBO(93, 109, 190, 0.9);

  static const Color appColorBlack = Colors.black;

  static const Color appColorWhite = Colors.white;
  static const Color appColorWhite90 = Color.fromRGBO(255, 255, 255, 0.9);
  static const Color appColorWhite80 = Color.fromRGBO(255, 255, 255, 0.8);
  static const Color appColorWhite70 = Color.fromRGBO(255, 255, 255, 0.7);
  static const Color appColorWhite60 = Color.fromRGBO(255, 255, 255, 0.6);
  static const Color appColorWhite50 = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color appColorWhite40 = Color.fromRGBO(255, 255, 255, 0.4);
  static const Color appColorWhite30 = Color.fromRGBO(255, 255, 255, 0.3);
  static const Color appColorWhite20 = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color appColorWhite10 = Color.fromRGBO(255, 255, 255, 0.1);

  static const Color appColorGreen = Color(0xFF7DB249);

  static const Color ContainerBackColor = Color.fromRGBO(238, 238, 238, 0.1);
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}