
import 'package:myvote/core/theme/domain/entities/theme_entity.dart';



abstract class ThemeRepository {
  Future<void> saveTheme(AppTheme theme);
  Future<AppTheme> getSavedTheme();
}