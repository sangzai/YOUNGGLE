import 'package:flutter/material.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';


final ThemeData myTheme = ThemeData(
  scaffoldBackgroundColor: Colors.transparent,

  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appColorBlue),

  fontFamily: "Pretendard",

  textTheme: TextTheme(
    headlineLarge: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 26,
        fontWeight: FontWeight.w500),
    headlineMedium: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 22),
    bodyMedium: TextStyle(color: Colors.white.withOpacity(0.5)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // 버튼 텍스트 색
      foregroundColor: AppColors.appColorWhite80,
      // 버튼 배경 색
      backgroundColor: AppColors.appColorBlue,
    )
  ),

  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: Colors.transparent
    )
  ),

  timePickerTheme: TimePickerThemeData(
    dayPeriodColor:
        MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)){
            return AppColors.appColorBlue50;
          }
          return Colors.transparent;
        }),
    backgroundColor: AppColors.appColorWhite.darken(15),

    dialHandColor: AppColors.appColorBlue90,

    hourMinuteColor:
      MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)){
          return AppColors.appColorBlue50;
        }
        return Colors.transparent;
      }),

    dialBackgroundColor: AppColors.appColorWhite.darken(25),

    helpTextStyle: TextStyle(fontSize: 0),
  ),


);

