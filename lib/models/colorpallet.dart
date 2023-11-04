import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightColorPallete {
  static const primaryColor = Color.fromARGB(255, 0, 245, 245);
  static const secondaryColor = Color.fromARGB(255, 226, 255, 254);
  static const accentColor = Color.fromARGB(255, 128, 241, 14);
  static const backgroundColor = Color.fromARGB(255, 230, 244, 241);
  static const textColor = Color.fromARGB(255, 8, 17, 17);
  static TextStyle titleText = GoogleFonts.tiltNeon(
    color: LightColorPallete.textColor,
    fontSize: 20,
  );
  static TextStyle displayText = GoogleFonts.kanit(
    color: LightColorPallete.textColor,
    fontSize: 16,
  );
  static const lightThemeColor = ColorScheme.light(
    primary: LightColorPallete.primaryColor,
    tertiary: LightColorPallete.secondaryColor,
    background: LightColorPallete.backgroundColor,
    secondary: LightColorPallete.accentColor,
  );
  static final textTheme = TextTheme(
    titleSmall: LightColorPallete.titleText,
    displaySmall: LightColorPallete.displayText,
  );
  static const iconTheme = IconThemeData(
    color: LightColorPallete.textColor,
  );
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(GoogleFonts.tiltNeon()),
      shadowColor: const MaterialStatePropertyAll(
        LightColorPallete.textColor,
      ),
      backgroundColor: const MaterialStatePropertyAll(
        LightColorPallete.accentColor,
      ),
      elevation: const MaterialStatePropertyAll(2),
      shape: const MaterialStatePropertyAll(
        LinearBorder(),
      ),
    ),
  );
  static final textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(LightColorPallete.titleText),
      shape: const MaterialStatePropertyAll(
        LinearBorder(),
      ),
    ),
  );
  static final chipTheme = ChipThemeData(
    checkmarkColor: LightColorPallete.textColor,
    labelStyle: LightColorPallete.displayText,
  );
}

class DarkColorPallet {
  static const primaryColor = Color.fromARGB(255, 10, 255, 255);
  static const secondaryColor = Color.fromARGB(255, 0, 31, 30);
  static const accentColor = Color.fromARGB(255, 128, 241, 14);
  static const backgroundColor = Color.fromARGB(255, 11, 25, 22);
  static const textColor = Color.fromARGB(255, 238, 247, 247);
  static TextStyle titleText = GoogleFonts.tiltNeon(
    color: DarkColorPallet.textColor,
    fontSize: 20,
  );
  static TextStyle displayText = GoogleFonts.kanit(
    color: DarkColorPallet.textColor,
    fontSize: 16,
  );
  static const themeColor = ColorScheme.dark(
    primary: DarkColorPallet.primaryColor,
    tertiary: DarkColorPallet.secondaryColor,
    background: DarkColorPallet.backgroundColor,
    secondary: DarkColorPallet.accentColor,
  );
  static final textTheme = TextTheme(
    titleSmall: DarkColorPallet.titleText,
    displaySmall: DarkColorPallet.displayText,
  );
  static const iconTheme = IconThemeData(
    color: DarkColorPallet.textColor,
  );
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(GoogleFonts.tiltNeon()),
      shadowColor: const MaterialStatePropertyAll(
        DarkColorPallet.textColor,
      ),
      backgroundColor: const MaterialStatePropertyAll(
        DarkColorPallet.accentColor,
      ),
      elevation: const MaterialStatePropertyAll(2),
      shape: const MaterialStatePropertyAll(
        LinearBorder(),
      ),
    ),
  );
  static final textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(DarkColorPallet.titleText),
      shape: const MaterialStatePropertyAll(
        LinearBorder(),
      ),
    ),
  );
  static final chipTheme = ChipThemeData(
    checkmarkColor: DarkColorPallet.textColor,
    labelStyle: DarkColorPallet.displayText,
  );
}
