import 'package:flutter/material.dart';

enum AppTheme { light, dark, system }

class ThemeEntity {
  final AppTheme selectedTheme;
  final ThemeData themeData;

  ThemeEntity({required this.selectedTheme, required this.themeData});
}