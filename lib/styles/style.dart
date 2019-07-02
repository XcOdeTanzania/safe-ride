import 'dart:ui';

import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFffffff);
  static const Color loginGradientEnd = const Color(0xFFf43f5f);
  static const Color loginButtonMix = const Color(0xFFeb66f30);
  static const Color saferidePrimaryColor = const Color(0xFFff453a);
  static const Color saferideSecondaryColor = const Color(0xFFdc641a);
  static const Color saferideTertiaryColor = const Color(0xFFffc0cb);

  static const prmaryGradient = const LinearGradient(
      colors: const [loginGradientStart, loginGradientEnd],
      stops: const [0.0, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
