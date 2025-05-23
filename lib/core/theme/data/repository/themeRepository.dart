



import 'package:myvote/core/theme/data/datasource/local%20/theme_source.dart';
import 'package:myvote/core/theme/domain/entities/theme_entity.dart';

import '../../domain/repository/theme_repository.dart';


class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveTheme(AppTheme theme) {
    return localDataSource.saveTheme(theme);
  }

  @override
  Future<AppTheme> getSavedTheme() {
    return localDataSource.getSavedTheme();
  }
}