import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';

class APPcolorScheme {
  MaterialColor primary = colorSchemeReference[accentColor]!;
  dynamic background = darkMode ? Colors.grey[900] : Colors.white;
  dynamic text = darkMode ? Colors.white : Colors.grey[900];
  dynamic card = darkMode ? Colors.grey[800] : Colors.white60;

  void setPrimary(newAccentColor) {
    primary = colorSchemeReference[newAccentColor]!;
  }

  void switchLightDarkMode() {
    darkMode = !darkMode;
    background = darkMode ? Colors.grey[900] : Colors.white;
    text = darkMode ? Colors.white : Colors.grey[900];
    card = darkMode ? Colors.grey[800] : Colors.white60;
  }
}