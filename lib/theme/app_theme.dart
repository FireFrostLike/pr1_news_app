import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme(bool isLight) {
    final brightness = isLight ? Brightness.light : Brightness.dark;
    final theme = ThemeData(
      brightness: brightness,
    );
    return theme.copyWith(
      iconTheme: theme.iconTheme.copyWith(size: 32),
    );
  }
}
