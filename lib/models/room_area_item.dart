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

  // Skirting properties (for Floor)
  int skirtingHeightInches; // 0, 4, 6
  TextEditingController skirtingCutoutController;
  String skirtingCutoutUnit;

  // Wall Height properties (for Bathroom)
  TextEditingController wallHeightController;
  String wallHeightUnit;

  // Dark and Motive properties (for Bathroom and Bedroom)
  int darkValue; // 0, 3, 4
  int motiveValue; // 0, 1, 2
  String bedroomFinishMode; // 'motiveDark' or 'skirting'

  // Opening (Door/Window) properties
  bool hasOpening;
  TextEditingController openingWidthController;
  TextEditingController openingHeightController;
  String openingUnit;

  // Dark Cutout properties
  bool hasDarkCutout;
  TextEditingController darkCutoutWidthController;
  TextEditingController darkCutoutHeightController;
  String darkCutoutUnit;

  // Motive Cutout properties
  bool hasMotiveCutout;
  TextEditingController motiveCutoutWidthController;
  TextEditingController motiveCutoutHeightController;
  String motiveCutoutUnit;

  // Room-specific Tile Specs
  TextEditingController tileLengthController;
  TextEditingController tileWidthController;
  TextEditingController tilesPerBoxController;
  TextEditingController costPerBoxController;
  String unitTileL;
  String unitTileW;
  String costPricingMode; // 'per Box', 'per Tile', 'per m²'

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
    required this.wallHeightController,
    required this.wallHeightUnit,
    this.darkValue = 3,
    this.motiveValue = 1,
    this.bedroomFinishMode = 'motiveDark',
    this.hasOpening = false,
    required this.openingWidthController,
    required this.openingHeightController,
    this.openingUnit = 'ft',
    this.hasDarkCutout = false,
    required this.darkCutoutWidthController,
    required this.darkCutoutHeightController,
    this.darkCutoutUnit = 'ft',
    this.hasMotiveCutout = false,
    required this.motiveCutoutWidthController,
    required this.motiveCutoutHeightController,
    this.motiveCutoutUnit = 'ft',
    required this.tileLengthController,
    required this.tileWidthController,
    required this.tilesPerBoxController,
    required this.costPerBoxController,
    this.unitTileL = 'cm',
    this.unitTileW = 'cm',
    this.costPricingMode = 'per m²',
  });

  double get length => double.tryParse(lengthController.text) ?? 0.0;
  double get width => double.tryParse(widthController.text) ?? 0.0;
  double get directArea => double.tryParse(directAreaController.text) ?? 0.0;
  double get wallHeight => double.tryParse(wallHeightController.text) ?? 0.0;
  double get skirtingCutout =>
      double.tryParse(skirtingCutoutController.text) ?? 0.0;
  double get tileLength => double.tryParse(tileLengthController.text) ?? 0.0;
  double get tileWidth => double.tryParse(tileWidthController.text) ?? 0.0;
  int get tilesPerBox => int.tryParse(tilesPerBoxController.text) ?? 10;
  double get costPerBox => double.tryParse(costPerBoxController.text) ?? 1800.0;

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

  double get wallHeightM {
    switch (wallHeightUnit) {
      case 'cm':
        return wallHeight / 100.0;
      case 'ft':
        return wallHeight * 0.3048;
      case 'in':
        return wallHeight * 0.0254;
      case 'm':
      default:
        return wallHeight;
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

  double get openingWidthM {
    double v = double.tryParse(openingWidthController.text) ?? 0.0;
    switch (openingUnit) {
      case 'cm':
        return v / 100.0;
      case 'ft':
        return v * 0.3048;
      case 'in':
        return v * 0.0254;
      case 'm':
      default:
        return v;
    }
  }

  double get openingHeightM {
    double v = double.tryParse(openingHeightController.text) ?? 0.0;
    switch (openingUnit) {
      case 'cm':
        return v / 100.0;
      case 'ft':
        return v * 0.3048;
      case 'in':
        return v * 0.0254;
      case 'm':
      default:
        return v;
    }
  }

  double get darkCutoutWidthM {
    double v = double.tryParse(darkCutoutWidthController.text) ?? 0.0;
    switch (darkCutoutUnit) {
      case 'cm':
        return v / 100.0;
      case 'ft':
        return v * 0.3048;
      case 'in':
        return v * 0.0254;
      case 'm':
      default:
        return v;
    }
  }

  double get motiveCutoutWidthM {
    double v = double.tryParse(motiveCutoutWidthController.text) ?? 0.0;
    switch (motiveCutoutUnit) {
      case 'cm':
        return v / 100.0;
      case 'ft':
        return v * 0.3048;
      case 'in':
        return v * 0.0254;
      case 'm':
      default:
        return v;
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
    if (name.toLowerCase().contains('floor') ||
        name.toLowerCase().contains('bathroom') ||
        name.toLowerCase().contains('bedroom')) {
      return 0.0;
    }
    double total = 0.0;
    for (final item in exclusions) {
      total += item.areaM2;
    }
    return total;
  }

  double get netArea => max(0.0, grossArea - exclusionAreaM2);

  // Bathroom Wall Area
  double get wallAreaM2 {
    if (!name.toLowerCase().contains('bathroom') ||
        wallHeightM <= 0 ||
        areaMode != 'dimensions') {
      return 0.0;
    }
    double perimeterM = 2 * (lengthM + widthM);
    return perimeterM * wallHeightM;
  }

  double get shortSideTileM {
    if (tileLengthM <= 0 || tileWidthM <= 0) return 0.0;
    return min(tileLengthM, tileWidthM);
  }

  double get perimeterM {
    if (areaMode != 'dimensions') return 0.0;
    return 2 * (lengthM + widthM);
  }

  double get darkWallAreaM2 {
    if (!(name.toLowerCase().contains('bathroom') ||
            name.toLowerCase().contains('bedroom')) ||
        darkValue <= 0 ||
        perimeterM <= 0 ||
        shortSideTileM <= 0 ||
        areaMode != 'dimensions') {
      return 0.0;
    }
    double darkWallHeightM = darkValue * shortSideTileM;
    double effectivePerimeter = perimeterM;
    if (hasOpening) {
      effectivePerimeter = max(0.0, effectivePerimeter - openingWidthM);
    }
    double darkArea = effectivePerimeter * darkWallHeightM;
    if (hasDarkCutout) {
      darkArea = max(0.0, darkArea - (darkCutoutWidthM * darkWallHeightM));
    }
    return darkArea;
  }

  double get motiveAreaM2 {
    if (!(name.toLowerCase().contains('bathroom') ||
            name.toLowerCase().contains('bedroom')) ||
        motiveValue <= 0 ||
        perimeterM <= 0 ||
        shortSideTileM <= 0 ||
        areaMode != 'dimensions') {
      return 0.0;
    }
    double motiveHeightM = motiveValue * shortSideTileM;
    double effectivePerimeter = perimeterM;
    if (hasOpening) {
      effectivePerimeter = max(0.0, effectivePerimeter - openingWidthM);
    }
    double motiveArea = effectivePerimeter * motiveHeightM;
    if (hasMotiveCutout) {
      motiveArea = max(0.0, motiveArea - (motiveCutoutWidthM * motiveHeightM));
    }
    return motiveArea;
  }

  double get lightAreaM2 {
    if (!name.toLowerCase().contains('bathroom') ||
        wallHeightM <= 0 ||
        perimeterM <= 0 ||
        shortSideTileM <= 0 ||
        singleTileArea <= 0 ||
        areaMode != 'dimensions') {
      return 0.0;
    }
    double darkHeightM = darkValue * shortSideTileM;
    double motiveHeightM = motiveValue * shortSideTileM;
    double remainingHeightM = wallHeightM - (darkHeightM + motiveHeightM);
    if (remainingHeightM <= 0) return 0.0;

    double effectivePerimeter = perimeterM;
    if (hasOpening) {
      effectivePerimeter = max(0.0, effectivePerimeter - openingWidthM);
    }
    double lightArea = effectivePerimeter * remainingHeightM;
    if (hasDarkCutout) {
      lightArea = max(0.0, lightArea - (darkCutoutWidthM * remainingHeightM));
    }
    if (hasMotiveCutout) {
      lightArea = max(0.0, lightArea - (motiveCutoutWidthM * remainingHeightM));
    }
    // If opening height is less than total wall height, add the upper space above the opening door
    if (hasOpening && wallHeightM > openingHeightM) {
      double upperOpeningWidth = openingWidthM;
      double upperOpeningHeight = wallHeightM - max(openingHeightM, darkHeightM + motiveHeightM);
      if (upperOpeningHeight > 0) {
        lightArea += (upperOpeningWidth * upperOpeningHeight);
      }
    }
    return lightArea;
  }

  double get totalRoomAreaM2 {
    if (name.toLowerCase().contains('bathroom')) {
      return netArea + darkWallAreaM2 + motiveAreaM2 + lightAreaM2;
    }
    if (name.toLowerCase().contains('bedroom')) {
      if (bedroomFinishMode == 'motiveDark') {
        return netArea + darkWallAreaM2 + motiveAreaM2;
      } else {
        return netArea;
      }
    }
    return netArea;
  }

  double get netSkirtingPerimeterM {
    if (skirtingHeightInches <= 0 ||
        areaMode != 'dimensions' ||
        !(name.toLowerCase() == 'floor' ||
            name.toLowerCase().contains('bedroom'))) {
      return 0.0;
    }
    double perimeterM = 2 * (lengthM + widthM);
    return max(0.0, perimeterM - skirtingCutoutM);
  }

  int getFloorTilesCount(double wastePct) {
    if (name.toLowerCase().contains('bathroom')) {
      return 0;
    }
    if (singleTileArea <= 0) return 0;
    double areaWithWaste = netArea * (1 + wastePct / 100);
    return (areaWithWaste / singleTileArea).ceil();
  }

  int getDarkTilesCount(double wastePct) {
    if (name.toLowerCase().contains('bathroom')) {
      double darkWallArea = darkWallAreaM2;
      double totalArea = darkWallArea + netArea;
      double areaWithWaste = totalArea * (1 + wastePct / 100);
      return singleTileArea > 0 ? (areaWithWaste / singleTileArea).ceil() : 0;
    }

    if (name.toLowerCase().contains('bedroom') &&
        bedroomFinishMode != 'motiveDark') {
      return 0;
    }
    if (!(name.toLowerCase().contains('bathroom') ||
            name.toLowerCase().contains('bedroom')) ||
        darkValue <= 0 ||
        perimeterM <= 0 ||
        shortSideTileM <= 0 ||
        singleTileArea <= 0 ||
        areaMode != 'dimensions') {
      return 0;
    }
    double darkWallHeightM = darkValue * shortSideTileM;
    double darkWallArea = perimeterM * darkWallHeightM;
    if (hasOpening) {
      darkWallArea = max(0.0, (perimeterM - openingWidthM) * darkWallHeightM);
    }
    if (hasDarkCutout) {
      darkWallArea = max(0.0, darkWallArea - (darkCutoutWidthM * darkWallHeightM));
    }
    double areaWithWaste = darkWallArea * (1 + wastePct / 100);
    return (areaWithWaste / singleTileArea).ceil();
  }

  int getMotiveTilesCount(double wastePct) {
    if (name.toLowerCase().contains('bedroom') &&
        bedroomFinishMode != 'motiveDark') {
      return 0;
    }
    if (!(name.toLowerCase().contains('bathroom') ||
            name.toLowerCase().contains('bedroom')) ||
        motiveValue <= 0 ||
        perimeterM <= 0 ||
        shortSideTileM <= 0 ||
        singleTileArea <= 0 ||
        areaMode != 'dimensions') {
      return 0;
    }
    double motiveArea = motiveAreaM2;
    double areaWithWaste = motiveArea * (1 + wastePct / 100);
    return (areaWithWaste / singleTileArea).ceil();
  }

  int getSkirtingTilesCount() {
    if (name.toLowerCase().contains('bedroom') &&
        bedroomFinishMode != 'skirting') {
      return 0;
    }
    if ((name.toLowerCase() == 'floor' ||
            name.toLowerCase().contains('bedroom')) &&
        skirtingHeightInches > 0) {
      return getSkirtingTilesNeeded();
    }
    return 0;
  }

  int getLightTilesCount(double wastePct) {
    double lArea = lightAreaM2;
    if (lArea <= 0 || singleTileArea <= 0) return 0;
    double areaWithWaste = lArea * (1 + wastePct / 100);
    return (areaWithWaste / singleTileArea).ceil();
  }

  double get tileLengthM {
    switch (unitTileL) {
      case 'mm':
        return tileLength / 1000.0;
      case 'cm':
        return tileLength / 100.0;
      case 'ft':
        return tileLength * 0.3048;
      case 'in':
        return tileLength * 0.0254;
      case 'm':
      default:
        return tileLength;
    }
  }

  double get tileWidthM {
    switch (unitTileW) {
      case 'mm':
        return tileWidth / 1000.0;
      case 'cm':
        return tileWidth / 100.0;
      case 'ft':
        return tileWidth * 0.3048;
      case 'in':
        return tileWidth * 0.0254;
      case 'm':
      default:
        return tileWidth;
    }
  }

  double get singleTileArea {
    if (tileLengthM <= 0 || tileWidthM <= 0) return 0.0;
    return tileLengthM * tileWidthM;
  }

  int getSkirtingTilesNeeded() {
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
    wallHeightController.dispose();
    openingWidthController.dispose();
    openingHeightController.dispose();
    darkCutoutWidthController.dispose();
    darkCutoutHeightController.dispose();
    motiveCutoutWidthController.dispose();
    motiveCutoutHeightController.dispose();
    tileLengthController.dispose();
    tileWidthController.dispose();
    tilesPerBoxController.dispose();
    costPerBoxController.dispose();
    for (final item in exclusions) {
      item.dispose();
    }
  }
}
