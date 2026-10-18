import 'package:flutter/material.dart';

class ExclusionItem {
  final String id;
  final TextEditingController widthController;
  final TextEditingController heightController;
  String unitWidth;
  String unitHeight;

  ExclusionItem({
    required this.id,
    required this.widthController,
    required this.heightController,
    this.unitWidth = 'm',
    this.unitHeight = 'm',
  });

  double get width => double.tryParse(widthController.text) ?? 0.0;
  double get height => double.tryParse(heightController.text) ?? 0.0;

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

  double get heightM {
    switch (unitHeight) {
      case 'cm':
        return height / 100.0;
      case 'ft':
        return height * 0.3048;
      case 'in':
        return height * 0.0254;
      case 'm':
      default:
        return height;
    }
  }

  double get areaM2 => widthM * heightM;

  void dispose() {
    widthController.dispose();
    heightController.dispose();
  }
}
