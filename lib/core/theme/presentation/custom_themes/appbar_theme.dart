
import 'package:flutter/material.dart';
import 'package:myvote/core/utils/constants/colors.dart';

class MyAppBarTheme{
  MyAppBarTheme._();
  static const lightAppBarTheme = AppBarTheme(
    
    elevation: 0,
    shape: Border(
      bottom: BorderSide(
        color: MyColors.darkshade,
        width: 0.5,
      ),
    ),
    // shadowColor: MyColors.darkshade,
    scrolledUnderElevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MyColors.tertiary, size: 24),
    actionsIconTheme: IconThemeData(color: MyColors.tertiary, size: 24),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: MyColors.tertiary),
    


  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    shape: Border(
      bottom: BorderSide(
        color: MyColors.lightshade,
        width: 0.5,
      ),
    ),
    // shadowColor: MyColors.lightshade,
    scrolledUnderElevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MyColors.primary, size: 24),
    actionsIconTheme: IconThemeData(color: MyColors.primary, size: 24),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: MyColors.primary),
    

  );
}