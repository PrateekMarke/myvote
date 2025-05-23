
import 'package:flutter/material.dart';
import 'package:myvote/core/theme/presenataion/custom_themes.dart/appbar_theme.dart';
import 'package:myvote/core/theme/presenataion/custom_themes.dart/elevated_button_theme.dart';
import 'package:myvote/core/theme/presenataion/custom_themes.dart/text_theme.dart';
import 'package:myvote/core/theme/presenataion/custom_themes.dart/textfiled_theme.dart';
import 'package:myvote/core/utils/constants/colors.dart';

class MyAppTheme{
  MyAppTheme._();
static ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: MyColors.primary,
  elevatedButtonTheme:MyElevatedButtonTheme.lightElevatedButtonTheme,
  textTheme: MyTextTheme.lightTextTheme,
  appBarTheme: MyAppBarTheme.lightAppBarTheme,
  inputDecorationTheme:  MyTextFieldTheme.lightTextFieldTheme,

  // colorScheme: const ColorScheme.light(
  //   surface: Colors.white,
  //   primary: Colors.black
  // )
);
static ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  // primaryColor: Colors.blue,
  scaffoldBackgroundColor: MyColors.tertiary,
  elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
  textTheme: MyTextTheme.darkTextTheme,
  appBarTheme: MyAppBarTheme.darkAppBarTheme ,
  inputDecorationTheme:  MyTextFieldTheme.darkTextFieldTheme,
  // colorScheme: ColorScheme.dark(
  //   surface: Colors.black,
  //   primary: Colors.white,
  // )
);
}



