
import 'package:flutter/material.dart';
import 'package:myvote/core/theme/domain/entities/theme_entity.dart';
import 'package:myvote/core/theme/domain/repositories/theme_repository.dart';
import 'package:myvote/core/theme/presentation/theme.dart';


class GetThemeUseCase {
  final ThemeRepository repository;

  GetThemeUseCase(this.repository);

  Future<ThemeEntity> call() async {
    final savedTheme = await repository.getSavedTheme();
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    // final themeData = (savedTheme == AppTheme.system)
    //     ? (brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light())
    //     : (savedTheme == AppTheme.dark ? ThemeData.dark() : ThemeData.light());
    final themeData = (savedTheme == AppTheme.system)
        ? (brightness == Brightness.dark ? MyAppTheme.darkMode : MyAppTheme.lightMode)
        : (savedTheme == AppTheme.dark ? MyAppTheme.darkMode : MyAppTheme.lightMode);

    return ThemeEntity(selectedTheme: savedTheme, themeData: themeData);
  }
}