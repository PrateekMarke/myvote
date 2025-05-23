import 'package:flutter/material.dart';
import 'package:myvote/core/utils/constants/colors.dart';


class MyTextFieldTheme {
  MyTextFieldTheme._(); 

  static final lightTextFieldTheme = InputDecorationTheme(
    labelStyle: const TextStyle(color: MyColors.textSecondary, fontSize: 14),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: MyColors.secondary, width: 1),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MyColors.secondary, width: 1),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MyColors.secondary, width: 2),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),

  );

  static final darkTextFieldTheme = InputDecorationTheme(
    labelStyle: const TextStyle(color: MyColors.textPrimary, fontSize: 14),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: MyColors.primary, width: 1),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MyColors.primary, width: 1),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MyColors.primary, width: 2),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
  
   
  );
}
