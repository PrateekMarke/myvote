

import 'package:myvote/core/theme/domain/entities/theme_entity.dart';

abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final AppTheme theme;

  ChangeThemeEvent(this.theme);
}