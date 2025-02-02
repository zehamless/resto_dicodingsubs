import 'package:flutter/material.dart';

import '../typography/resto-text-typography.dart';

class RestoTheme {

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: RestoTextStyles.displayLarge,
      displayMedium: RestoTextStyles.displayMedium,
      displaySmall: RestoTextStyles.displaySmall,
      headlineLarge: RestoTextStyles.headlineLarge,
      headlineMedium: RestoTextStyles.headlineMedium,
      headlineSmall: RestoTextStyles.headlineSmall,
      titleLarge: RestoTextStyles.titleLarge,
      titleMedium: RestoTextStyles.titleMedium,
      titleSmall: RestoTextStyles.titleSmall,
      bodyLarge: RestoTextStyles.bodyLargeBold,
      bodyMedium: RestoTextStyles.bodyLargeMedium,
      bodySmall: RestoTextStyles.bodyLargeRegular,
      labelLarge: RestoTextStyles.labelLarge,
      labelMedium: RestoTextStyles.labelMedium,
      labelSmall: RestoTextStyles.labelSmall,
    );
  }
  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: RestoColors.blue.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: RestoColors.blue.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}