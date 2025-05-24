import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myvote/core/routes/path.dart';
import 'package:myvote/core/theme/data/datasources/theme_source.dart';
import 'package:myvote/core/theme/data/repositories/theme._repositoryImpl.dart';
import 'package:myvote/core/theme/domain/usecases/getTheme.dart';
import 'package:myvote/core/theme/domain/usecases/saveTheme.dart';
import 'package:myvote/core/theme/presentation/bloc/theme_bloc.dart';
import 'package:myvote/core/theme/presentation/bloc/theme_state.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final localDataSource = ThemeLocalDataSourceImpl();
  final themeRepository = ThemeRepositoryImpl(localDataSource);
  final getThemeUseCase = GetThemeUseCase(themeRepository);
  final saveThemeUseCase = SaveThemeUseCase(themeRepository);
  runApp(
    MyApp(getThemeUseCase: getThemeUseCase, saveThemeUseCase: saveThemeUseCase),
  );
}

class MyApp extends StatelessWidget {
  final GetThemeUseCase getThemeUseCase;
  final SaveThemeUseCase saveThemeUseCase;
  const MyApp({
    super.key,
    required this.getThemeUseCase,
    required this.saveThemeUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ThemeBloc(
            getThemeUseCase: getThemeUseCase,
            saveThemeUseCase: saveThemeUseCase,
          ),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'MyMote',
            theme: state.theme.themeData,
            darkTheme: state.theme.themeData,
            routerConfig: router,
          );
        },
      ),
    );
  }
}