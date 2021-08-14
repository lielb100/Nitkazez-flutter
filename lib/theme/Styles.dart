import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    var darkColor = Colors.tealAccent[900];
    var lightColor = Colors.tealAccent[700];
    TextStyle txtStyle =
        TextStyle(color: isDarkTheme ? Colors.white : Colors.black);
    return ThemeData(
      textTheme: TextTheme(
        bodyText1: txtStyle,
        bodyText2: txtStyle,
        button: txtStyle,
        caption: txtStyle,
        headline1: txtStyle,
        headline2: txtStyle,
        headline3: txtStyle,
        headline4: txtStyle,
        headline5: txtStyle,
        headline6: txtStyle,
        overline: txtStyle,
        subtitle1: txtStyle,
        subtitle2: txtStyle,
      ),
      primaryColor: lightColor,
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      indicatorColor: isDarkTheme ? darkColor : lightColor,
      buttonColor: isDarkTheme ? darkColor : lightColor,
      hintColor: isDarkTheme ? Colors.white : Colors.grey,
      highlightColor: isDarkTheme ? lightColor : darkColor,
      hoverColor: isDarkTheme ? lightColor : darkColor,
      focusColor: isDarkTheme ? lightColor : darkColor,
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      dividerColor: isDarkTheme ? darkColor : lightColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: isDarkTheme ? darkColor : lightColor),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.black : Colors.white),
    );
  }
}
