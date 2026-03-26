import 'package:flutter/material.dart';
import 'package:shared_ui/theme/my_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: MyTheme.color.primary,
      hintColor: MyTheme.color.primary,
      scaffoldBackgroundColor: MyTheme.color.white,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: MyTheme.color.primary),
        surfaceTintColor: Colors.transparent,
        shadowColor: MyTheme.color.black.withValues(alpha: 0.1),
        elevation: 6,
      ),
      colorScheme: ColorScheme.light(
        primary: MyTheme.color.primary,
        secondary: MyTheme.color.secondary,
        error: MyTheme.color.danger,
        // Define other colors from the color scheme here
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: MyTheme.color.white,
          backgroundColor: MyTheme.color.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          iconSize: 24,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: MyTheme.color.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: MyTheme.color.black,
        ),
        bodySmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: MyTheme.color.black,
        ),
      ),
      // Define other theme properties like textTheme, buttonTheme, etc.
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: MyTheme.color.primary,
      hintColor: MyTheme.color.primary,
      scaffoldBackgroundColor: MyTheme.color.black,
      appBarTheme: AppBarTheme(
        backgroundColor: MyTheme.color.primary,
        iconTheme: IconThemeData(color: MyTheme.color.white),
      ),
      colorScheme: ColorScheme.dark(
        primary: MyTheme.color.primary,
        secondary: MyTheme.color.secondary,
        error: MyTheme.color.danger,
        // Define other colors from the color scheme here
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: MyTheme.color.white,
          backgroundColor: MyTheme.color.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          iconSize: 24,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: MyTheme.color.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: MyTheme.color.white,
        ),
        bodySmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: MyTheme.color.white,
        ),
      ),
      // Define other theme properties like textTheme, buttonTheme, etc.
    );
  }

  // Optionally, define a darkTheme if your app will have a dark mode
}
