import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 *
 * This is the theme of the application, here, the look and the feel of the app
 */
const Color lightBG = Colors.white;
const Color darkBG = Colors.black;
const Color lightPrimary = Colors.white;
const Color darkPrimary = Colors.black;

final lightTheme = ThemeData(
  // backgroundColor: lightBG,
  // fontFamily: 'Lato',
  // appBarTheme: AppBarTheme(
  //   elevation: 0,
  //   toolbarTextStyle: const TextTheme(
  //     subtitle1: TextStyle(
  //       fontFamily: "TimesNewRoman",
  //       color: Colors.white,
  //       fontSize: 20,
  //       fontWeight: FontWeight.w800,
  //     ),
  //   ).bodyText2,
  //   titleTextStyle: const TextTheme(
  //     subtitle1: TextStyle(
  //       fontFamily: "TimesNewRoman",
  //       color: Colors.white,
  //       fontSize: 20,
  //       fontWeight: FontWeight.w800,
  //     ),
  //   ).headline6,
  // ),
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.indigo,
      onPrimary: lightPrimary,
      secondary: Colors.deepOrange,
      onSecondary: Colors.indigo,
      error: Colors.red,
      onError: Colors.red,
      background: lightBG,
      onBackground: darkPrimary,
      surface: lightBG,
      onSurface: darkPrimary),

  // ColorScheme.fromSwatch(
  //   primarySwatch: Colors.indigo,
  // ).copyWith(secondary: Colors.deepOrange),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.teal,
      onPrimary: darkPrimary,
      secondary: Colors.orangeAccent,
      onSecondary: Colors.indigo,
      error: Colors.red,
      onError: Colors.red,
      background: darkBG,
      onBackground: lightPrimary,
      surface: Colors.grey.shade800,
      onSurface: lightPrimary),

// .dark().copyWith(
//   backgroundColor: darkBG,
//   scaffoldBackgroundColor: darkBG,
//   appBarTheme: AppBarTheme(
//     surfaceTintColor: darkBG,
//     backgroundColor: darkBG,
//     iconTheme: const IconThemeData(color: lightBG),
//     elevation: 0,
//     toolbarTextStyle: const TextTheme(
//       subtitle1: TextStyle(
//         fontFamily: "TimesNewRoman",
//         color: lightBG,
//         fontSize: 20,
//         fontWeight: FontWeight.w800,
//       ),
//     ).bodyText2,
//     titleTextStyle: const TextTheme(
//       subtitle1: TextStyle(
//         fontFamily: "TimesNewRoman",
//         color: lightBG,
//         fontSize: 20,
//         fontWeight: FontWeight.w800,
//       ),
//     ).headline6,
//   ),
//   colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
//     secondary: Colors.orangeAccent,
//     brightness: Brightness.dark,
//   ),
);

// final cupertinoTheme = const CupertinoThemeData(
//     primaryColor: const CupertinoDynamicColor.withBrightness(
//         color: Colors.indigo, darkColor: Colors.teal));



// final ThemeData lightTheme = ThemeData(
//   scaffoldBackgroundColor: Colors.teal,
//   appBarTheme: const AppBarTheme(
//     color: Colors.teal,
//     iconTheme: IconThemeData(
//       color: Colors.white,
//     ),
//   ),
//   colorScheme: const ColorScheme.light(
//     primary: Colors.white,
//     onPrimary: Colors.white,
//     secondary: Colors.red,
//   ),
//   cardTheme: const CardTheme(
//     color: Colors.teal,
//   ),
//   iconTheme: const IconThemeData(
//     color: Colors.white54,
//   ),
//   textTheme: const TextTheme(
//     subtitle1: TextStyle(
//       color: Colors.white,
//       fontSize: 20.0,
//     ),
//     subtitle2: TextStyle(
//       color: Colors.white70,
//       fontSize: 18.0,
//     ),
//   ),
// );

// final ThemeData darkTheme = ThemeData(
//   scaffoldBackgroundColor: Colors.black,
//   appBarTheme: const AppBarTheme(
//     color: Colors.black,
//     iconTheme: IconThemeData(
//       color: Colors.white,
//     ),
//   ),
//   colorScheme: const ColorScheme.light(
//     primary: Colors.black,
//     onPrimary: Colors.black,
//     secondary: Colors.red,
//   ),
//   cardTheme: const CardTheme(
//     color: Colors.black,
//   ),
//   iconTheme: const IconThemeData(
//     color: Colors.white54,
//   ),
//   textTheme: const TextTheme(
//     subtitle1: TextStyle(
//       color: Colors.white,
//       fontSize: 20.0,
//     ),
//     subtitle2: TextStyle(
//       color: Colors.white70,
//       fontSize: 18.0,
//     ),
//   ),
// );
