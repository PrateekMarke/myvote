
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myvote/core/theme/domain/entities/theme_entity.dart';
import 'package:myvote/core/theme/domain/usecases/getTheme.dart';
import 'package:myvote/core/theme/domain/usecases/saveTheme.dart';
import 'package:myvote/core/theme/presentation/theme.dart';



import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> with WidgetsBindingObserver {
  final GetThemeUseCase getThemeUseCase;
  final SaveThemeUseCase saveThemeUseCase;

  ThemeBloc({required this.getThemeUseCase, required this.saveThemeUseCase})
      : super(ThemeState(theme: ThemeEntity(selectedTheme: AppTheme.system, themeData: MyAppTheme.lightMode))) {
    _loadTheme();

    on<ChangeThemeEvent>((event, emit) async {
      await saveThemeUseCase.call(event.theme);
      await _loadTheme();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _loadTheme() async {
    final themeEntity = await getThemeUseCase.call();
    // final currentThemeData = themeEntity.themeData;
    // ignore: invalid_use_of_visible_for_testing_member
    emit(ThemeState(theme: themeEntity));
  }

  @override
  void didChangePlatformBrightness() {
    if (state.theme.selectedTheme == AppTheme.system) {
      _loadTheme();
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}