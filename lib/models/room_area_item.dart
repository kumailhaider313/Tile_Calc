import 'dart:math';
import 'package:flutter/material.dart';
import 'exclusion_item.dart';

class RoomAreaItem {
  final String id;
  String name;
  String areaMode; // 'dimensions' or 'direct'
  TextEditingController lengthController;
  TextEditingController widthController;
  TextEditingController directAreaController;
  String unitLength;
  String unitWidth;
  String unitDirectArea;
  List<ExclusionItem> exclusions;

  // Skirting properties
  int skirtingHeightInches; // 0, 4, 6
  TextEditingController skirtingCutoutController;
  String skirtingCutoutUnit;

  RoomAreaItem({
    required this.id,
    required this.name,
    this.areaMode = 'dimensions',
    required this.lengthController,
    required this.widthController,
    required this.directAreaController,
    this.unitLength = 'ft',
    this.unitWidth = 'ft',
    this.unitDirectArea = 'm²',
    required this.exclusions,
    this.skirtingHeightInches = 4,
    required this.skirtingCutoutController,
    this.skirtingCutoutUnit = 'ft',
  });

  double get length => double.tryParse(lengthController.text) ?? 0.0;
  double get width => double.tryParse(widthController.text) ?? 0.0;
  double get directArea => double.tryParse(directAreaController.text) ?? 0.0;
  double get skirtingCutout =>
      double.tryParse(skirtingCutoutController.text) ?? 0.0;

  double get lengthM {
    switch (unitLength) {
      case 'cm':
        return length / 100.0;
      case 'ft':
        return length * 0.3048;
      case 'in':
        return length * 0.0254;
      case 'm':
      default:
        return length;
    }
  }

  double get widthM {
    switch (unitWidth) {
      case 'cm':
        return width / 100.0;
      case 'ft':
        return width * 0.3048;
      case 'in':
        return width * 0.0254;
      case 'm':
      default:
        return width;
    }
  }

  double get skirtingCutoutM {
    switch (skirtingCutoutUnit) {
      case 'cm':
        return skirtingCutout / 100.0;
      case 'ft':
        return skirtingCutout * 0.3048;
      case 'in':
        return skirtingCutout * 0.0254;
      case 'm':
      default:
        return skirtingCutout;
    }
  }

  double get directAreaM2 {
    switch (unitDirectArea) {
      case 'cm²':
        return directArea / 10000.0;
      case 'sq ft':
        return directArea * 0.09290304;
      case 'sq in':
        return directArea * 0.00064516;
      case 'm²':
      default:
        return directArea;
    }
  }

  double get grossArea {
    if (areaMode == 'dimensions') {
      return lengthM * widthM;
    } else {
      return directAreaM2;
    }
  }

  double get exclusionAreaM2 {
    double total = 0.0;
    for (final item in exclusions) {
      total += item.areaM2;
    }
    return total;
  }

  double get netArea => max(0.0, grossArea - exclusionAreaM2);

  double get netSkirtingPerimeterM {
    if (skirtingHeightInches <= 0 || areaMode != 'dimensions' || name.toLowerCase() != 'floor') {
      return 0.0;
    }
    double perimeterM = 2 * (lengthM + widthM);
    return max(0.0, perimeterM - skirtingCutoutM);
  }

  int getSkirtingTilesNeeded(double tileLengthM, double tileWidthM) {
    if (netSkirtingPerimeterM <= 0 || tileLengthM <= 0 || tileWidthM <= 0) {
      return 0;
    }

    double skirtingHeightM = skirtingHeightInches * 0.0254; // 1 inch = 0.0254m

    int strips1 = (tileWidthM / skirtingHeightM).floor();
    double length1 = (strips1 > 0) ? tileLengthM * strips1 : 0.0;

    int strips2 = (tileLengthM / skirtingHeightM).floor();
    double length2 = (strips2 > 0) ? tileWidthM * strips2 : 0.0;

    double linearMetersPerTile = max(length1, length2);
    if (linearMetersPerTile <= 0) {
      linearMetersPerTile = tileLengthM;
    }

    return (netSkirtingPerimeterM / linearMetersPerTile).ceil();
  }

  void dispose() {
    lengthController.dispose();
    widthController.dispose();
    directAreaController.dispose();
    skirtingCutoutController.dispose();
    for (final item in exclusions) {
      item.dispose();
    }
  }
}
