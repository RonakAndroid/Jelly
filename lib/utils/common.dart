import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jellyview/utils/jelly_configurations.dart';
import 'package:random_color/random_color.dart';

double getRandomRadius(JellyConfiguration myConfigurations) {
  return myConfigurations.minRadius +
      Random().nextInt(
          (myConfigurations.maxRadius - myConfigurations.minRadius).toInt());
}

RandomColor _randomColor = RandomColor();

Color getHighSaturatedRandomColor({double alpha = 1.0}) {
  return _randomColor
      .randomColor(colorSaturation: ColorSaturation.highSaturation)
      .withOpacity(alpha);
}

Color getLowSaturatedRandomColor({double alpha = 1.0}) {
  return _randomColor
      .randomColor(colorSaturation: ColorSaturation.lowSaturation)
      .withOpacity(alpha);
}

Color getRandomColor({double alpha = 1.0}) {
  return _randomColor
      .randomColor(colorSaturation: ColorSaturation.random)
      .withOpacity(alpha);
}
