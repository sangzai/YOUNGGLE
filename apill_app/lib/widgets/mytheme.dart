import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';


final ThemeData myTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,

  ),

  scaffoldBackgroundColor: Colors.transparent,

  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appColorBlue),

  fontFamily: "Pretendard",

  textTheme: TextTheme(
    headlineLarge: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 60.sp,
        fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 50.sp,
        fontWeight: FontWeight.w500
    ),

    titleLarge: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 60.sp,
        fontWeight: FontWeight.w700
    ),
    titleMedium: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 50.sp,
        fontWeight: FontWeight.w600
    ),

    bodyLarge: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 40.sp
    ),
    bodyMedium: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 30.sp
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // 버튼 텍스트 색
      foregroundColor: AppColors.appColorWhite80,
      // 버튼 배경 색
      backgroundColor: AppColors.appColorBlue80,
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

  datePickerTheme: DatePickerThemeData(
    backgroundColor: AppColors.appColorBlue.lighten(60),
    headerHelpStyle: TextStyle(fontSize: 0),
  )


);

