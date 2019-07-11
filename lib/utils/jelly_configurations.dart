import 'dart:math';
import 'dart:ui';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:jellyview/model/border_point.dart';
import 'package:jellyview/utils/common.dart';

class JellyConfiguration {
  int steps = 16;
  double radiusFactor = 4;
  double reductionRadiusFactor = 1;

  Paint fillPaint;
  Color firstColor;
  Color secondColor;

  bool keepNodes = false;
  Paint nodePaint;
  Color nodePaintColor = getRandomColor();
  double nodeRadius = 4.0;

  Offset centerPointOfJelly;
  double radiusOfJelly; // DO NOT MANUALLY UPDATE THIS ONE.
  double minRadius;
  double maxRadius;
  double stepRadian = 0;
  double startAngle = 0.0;
  double endAngle = 360.0;
  double startRadian = 0.0;
  double endRadian = 2 * pi;
  double rotationInAngle = 0.0;
  double rotationRadian = 0.0;
  double boundaryRadiusFactor = 1.2;

  // this one is in degree mean 0 to 360.
  List<BorderPoint> borderPoints = List();
  Path jellyPath = Path();
  Size size;

  Paint getDefaultPathPaint() {
    return Paint()
      ..color = getRandomColor()
      ..style = PaintingStyle.fill;
  }

  double savedTime = 0.0;

  bool isSecondColorSaturated = false;

  Color updateColor(Color color, double time, int position) {
    if (savedTime > time) {
      firstColor = secondColor;
      if (isSecondColorSaturated) {
        secondColor = getLowSaturatedRandomColor(alpha: 0.8);
      } else {
        secondColor = getHighSaturatedRandomColor(alpha: 0.8);
      }
      isSecondColorSaturated = !isSecondColorSaturated;
    }

    savedTime = time;
    Color newColor = Color.lerp(firstColor, secondColor, time);
    return newColor;
  }

  void reConfigPaint(Size size, {bool isDraw, int position = 0}) {
    this.size = size;
    if (fillPaint == null) {
      fillPaint = getDefaultPathPaint();
    }

    if (firstColor == null) {
      if (position.isEven) {
        firstColor = getHighSaturatedRandomColor(alpha: 0.8);
        secondColor = getLowSaturatedRandomColor(alpha: 0.8);
      } else {
        firstColor = getLowSaturatedRandomColor(alpha: 0.8);
        secondColor = getHighSaturatedRandomColor(alpha: 0.8);
      }
    }

    startRadian = Angle.fromDegrees(startAngle).radians;
    endRadian = Angle.fromDegrees(endAngle).radians;

    stepRadian = (endRadian - startRadian) / this.steps;
    centerPointOfJelly = Offset(size.width / 2, size.height / 2);
    if (size.width > size.height) {
      // landscape;
      radiusOfJelly = (size.height / radiusFactor) * reductionRadiusFactor;
    } else {
      // portrait;
      radiusOfJelly = (size.width / radiusFactor) * reductionRadiusFactor;
    }
    minRadius = radiusOfJelly / boundaryRadiusFactor;
    maxRadius = radiusOfJelly * boundaryRadiusFactor;
    rotationRadian = Angle.fromDegrees(rotationInAngle).radians;
    createJellyPathPoints();
    createJellyPath();
  }

  JellyConfiguration(this.size,
      {int position = 0, double reductionRadiusFactor = 1}) {
    this.reductionRadiusFactor = reductionRadiusFactor;
    reConfigPaint(size, isDraw: false, position: position);
  }

  void createJellyPathPoints() {
    borderPoints.clear();
    for (int i = 0; i < steps; i++) {
      double radian = startRadian + (stepRadian * i);
      double randomRadius = getRandomRadius(this);
      double xPoint = centerPointOfJelly.dx + randomRadius * cos(radian);
      double yPoint = centerPointOfJelly.dy + randomRadius * sin(radian);
      borderPoints.add(BorderPoint(
          xPoint, yPoint, radian, randomRadius, MovementDirection.INWARD));
    }
  }

  void updateJellyPathPoints(double time, int position) {
    fillPaint.color = updateColor(fillPaint.color, time, position);
    for (int i = 0; i < borderPoints.length; i++) {
      BorderPoint point = borderPoints[i];

      double radian = point.radianAngle + rotationRadian;

      bool movementInside = needRadiusDecrease(borderPoints[i]);
      double ran = Random().nextDouble() * Random().nextInt(2);
      double newRadius = 0.0;
      if (movementInside) {
        newRadius = point.radius - ran;
      } else {
        newRadius = point.radius + ran;
      }

      double xPoint = centerPointOfJelly.dx + (newRadius * cos(radian));
      double yPoint = centerPointOfJelly.dy + (newRadius * sin(radian));
      MovementDirection direction;
      if (movementInside) {
        direction = MovementDirection.INWARD;
      } else {
        direction = MovementDirection.OUTWARD;
      }
      borderPoints[i] =
          (BorderPoint(xPoint, yPoint, radian, newRadius, direction));
    }
    createJellyPath();
  }

  void createJellyPath() {
    jellyPath.reset();
    var mid = (getOffset(borderPoints[0]) + getOffset(borderPoints[1])) / 2;
    jellyPath.moveTo(mid.dx, mid.dy);
    for (var i = 0; i < borderPoints.length; i++) {
      var p1 = getOffset(borderPoints[(i + 1) % borderPoints.length]);
      var p2 = getOffset(borderPoints[(i + 2) % borderPoints.length]);
      mid = (p1 + p2) / 2;
      jellyPath.quadraticBezierTo(p1.dx, p1.dy, mid.dx, mid.dy);
    }
  }

  Offset getOffset(BorderPoint borderPoint) {
    return Offset(borderPoint.dx, borderPoint.dy);
  }

  bool needRadiusDecrease(BorderPoint borderPoint) {
    if (borderPoint.radius <= minRadius) {
      return false;
    } else if (borderPoint.radius >= maxRadius) {
      return true;
    } else if (borderPoint.direction == MovementDirection.INWARD) {
      return true;
    } else {
      return false;
    }
  }
}