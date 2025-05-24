import 'package:myvote/core/theme/domain/entities/theme_entity.dart';
import 'package:myvote/core/theme/domain/repositories/theme_repository.dart';


class SaveThemeUseCase {
  final ThemeRepository repository;

  SaveThemeUseCase(this.repository);

  Future<void> call(AppTheme theme) async {
    await repository.saveTheme(theme);
  }
}