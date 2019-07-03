import 'package:flutter/material.dart';

class ArchSampleTheme {
  static get theme {
    final originalTextTheme = ThemeData.light().textTheme;
    final originalBody1 = originalTextTheme.body1;

    return ThemeData.light().copyWith(
        primaryColor: Colors.cyan[300],
        accentColor: Colors.white,
        buttonColor: Color(0xFFff453a),
        textSelectionColor: Colors.cyan[100],
        backgroundColor: Colors.grey[800],
        toggleableActiveColor: Colors.cyan[300],
        textTheme: originalTextTheme.copyWith(
            body1:
                originalBody1.copyWith(decorationColor: Colors.transparent)));
  }
}
