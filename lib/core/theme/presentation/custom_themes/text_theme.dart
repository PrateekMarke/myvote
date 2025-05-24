import 'package:flutter/material.dart';
import 'package:myvote/core/utils/constants/colors.dart';
import 'package:myvote/core/utils/device/screen_utils.dart';


class MyTextTheme{
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: ScreenUtil.responsiveFontSize(32), fontWeight: FontWeight.bold, color: MyColors.texttertiary,fontFamily: 'Roboto'),
    headlineMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(24) , fontWeight: FontWeight.bold, color: MyColors.texttertiary, fontFamily: 'Roboto'),  
    headlineSmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(20) , fontWeight: FontWeight.bold, color: MyColors.texttertiary),

    titleLarge: TextStyle(fontSize:ScreenUtil.responsiveFontSize(18) , fontWeight: FontWeight.bold, color: MyColors.texttertiary, fontFamily: 'Roboto'),
    titleMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(16) , fontWeight: FontWeight.bold, color: MyColors.texttertiary, fontFamily: 'Roboto'),
    titleSmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(14), fontWeight: FontWeight.bold, color: MyColors.texttertiary, fontFamily: 'Roboto'),

    bodyLarge: TextStyle(fontSize:ScreenUtil.responsiveFontSize(16), fontWeight: FontWeight.normal, color: MyColors.texttertiary),
    bodyMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(14), fontWeight: FontWeight.normal, color: MyColors.texttertiary, fontFamily: 'Roboto'),
    bodySmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(12), fontWeight: FontWeight.normal, color: MyColors.texttertiary, fontFamily: 'Roboto'), 

    labelLarge: TextStyle(fontSize:ScreenUtil.responsiveFontSize(16), fontWeight: FontWeight.normal, color: MyColors.texttertiary, fontFamily: 'Roboto'),
    labelMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(14), fontWeight: FontWeight.normal, color: MyColors.texttertiary, fontFamily: 'Roboto'),
    labelSmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(12), fontWeight: FontWeight.normal, color: MyColors.texttertiary, fontFamily: 'Roboto'),

  );
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize:ScreenUtil.responsiveFontSize(32), fontWeight: FontWeight.bold, color: MyColors.textPrimary,fontFamily: 'Roboto'),
    headlineMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(24), fontWeight: FontWeight.bold, color: MyColors.textPrimary,fontFamily: 'Roboto'),  
    headlineSmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(20), fontWeight: FontWeight.bold, color: MyColors.textPrimary,fontFamily: 'Roboto'),

    titleLarge: TextStyle(fontSize:ScreenUtil.responsiveFontSize(18), fontWeight: FontWeight.bold, color: MyColors.textPrimary,fontFamily: 'Roboto'),
    titleMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(16), fontWeight: FontWeight.bold, color: MyColors.textPrimary,fontFamily: 'Roboto'),
    titleSmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(14), fontWeight: FontWeight.bold, color: MyColors.textPrimary,fontFamily: 'Roboto'),

    bodyLarge: TextStyle(fontSize:ScreenUtil.responsiveFontSize(16), fontWeight: FontWeight.normal, color: MyColors.textPrimary,fontFamily: 'Roboto'),
    bodyMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(14), fontWeight: FontWeight.normal, color: MyColors.textPrimary,fontFamily: 'Roboto'),
    bodySmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(12), fontWeight: FontWeight.normal, color: MyColors.textPrimary,fontFamily: 'Roboto'), 

    labelLarge: TextStyle(fontSize:ScreenUtil.responsiveFontSize(16), fontWeight: FontWeight.normal, color: MyColors.textPrimary,fontFamily: 'Roboto'),
    labelMedium: TextStyle(fontSize:ScreenUtil.responsiveFontSize(14), fontWeight: FontWeight.normal, color: MyColors.textPrimary,fontFamily: 'Roboto'),
    labelSmall: TextStyle(fontSize:ScreenUtil.responsiveFontSize(12), fontWeight: FontWeight.normal, color: MyColors.textPrimary,fontFamily: 'Roboto'),

  )
  ;
}