
import 'package:myvote/core/theme/domain/entities/theme_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';




abstract class ThemeLocalDataSource {
  Future<void> saveTheme(AppTheme theme);
  Future<AppTheme> getSavedTheme();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const _themeKey = 'theme';

  @override
  Future<void> saveTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.toString().split('.').last);
  }

  @override
  Future<AppTheme> getSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey) ?? 'system';

    switch (theme) {
      case 'light':
        return AppTheme.light;
      case 'dark':
        return AppTheme.dark;
      default:
        return AppTheme.system;
    }
  }
}