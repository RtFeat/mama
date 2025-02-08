import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'app_theme.g.dart';

class ThemeStore extends _AppThemeStore with _$ThemeStore {
  ThemeStore({required super.mode, required super.seed});
}

abstract class _AppThemeStore extends AppThemeStore with Store {
  _AppThemeStore({
    required super.mode,
    required super.seed,
  }) : super(
            lightTheme: FlexThemeData.light(
                fontFamily: 'SFProText',
                useMaterial3: true,
                textTheme: TextTheme(
                  headlineSmall: GoogleFonts.nunito(
                      fontSize: 32, fontWeight: FontWeight.w700),
                  titleMedium: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  titleLarge: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  titleSmall: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  labelLarge: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  bodyMedium: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  bodySmall: const TextStyle(
                    fontSize: 17,
                    color: AppColors.greyBrighterColor,
                  ),
                  labelMedium: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor,
                      letterSpacing: 0),
                  labelSmall: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greyBrighterColor,
                      letterSpacing: 0),
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: seed,
                  primary: AppColors.primaryColor,
                )),
            darkTheme: FlexThemeData.dark(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: seed),
            ));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeStore && seed == other.seed && mode == other.mode;

  @override
  int get hashCode => Object.hash(seed, mode);
}
