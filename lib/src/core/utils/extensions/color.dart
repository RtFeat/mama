import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color getDarkerColor([double lightness = 0.3]) {
    final HSLColor hsl = HSLColor.fromColor(this);
    final HSLColor darkerHsl =
        hsl.withLightness((hsl.lightness - lightness).clamp(0.0, 1.0));
    return darkerHsl.toColor();
  }
}
