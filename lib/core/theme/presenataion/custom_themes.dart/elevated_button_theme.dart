import 'package:flutter/material.dart';
import 'package:myvote/core/utils/constants/colors.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._(); 
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MyColors.primary, 
      backgroundColor: MyColors.secondary, 
      disabledForegroundColor: MyColors.darkshade,
      disabledBackgroundColor: MyColors.lightshade,

      textStyle: const TextStyle(
        color: MyColors.textPrimary,
        fontSize: 16, 
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MyColors.secondary,
      backgroundColor: MyColors.primary, // primary
      disabledForegroundColor: MyColors.darkshade,
      disabledBackgroundColor: MyColors.lightshade,

      textStyle: const TextStyle(
        color: MyColors.textSecondary,
        fontSize: 16, 
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  );
}
