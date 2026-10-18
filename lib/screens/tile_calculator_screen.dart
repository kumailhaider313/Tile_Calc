import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/exclusion_item.dart';
import '../widgets/area_input_section.dart';
import '../widgets/header_app_bar.dart';
import '../widgets/layout_preview_card.dart';
import '../widgets/results_summary_card.dart';
import '../widgets/tile_specs_section.dart';
import '../widgets/waste_section.dart';

class TileCalculatorScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const TileCalculatorScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<TileCalculatorScreen> createState() => _TileCalculatorScreenState();
}

class _TileCalculatorScreenState extends State<TileCalculatorScreen> {
  String _selectedCurrency = 'PKR';
  String _areaMode = 'dimensions'; // 'dimensions' or 'direct'

  final Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'PKR': '₨',
    'INR': '₹',
  };

  // Text Editing Controllers
  late TextEditingController _roomLengthController;
  late TextEditingController _roomWidthController;
  late TextEditingController _directAreaController;
  late TextEditingController _tileLengthController;
  late TextEditingController _tileWidthController;
  late TextEditingController _tilesPerBoxController;
  late TextEditingController _groutGapController;
  late TextEditingController _costPerBoxController;

  String _unitLength = 'ft'; // 'm', 'cm', 'ft', 'in'
  String _unitWidth = 'ft'; // 'm', 'cm', 'ft', 'in'
  String _unitDirectArea = 'm²'; // 'm²', 'cm²', 'sq ft', 'sq in'

  String _unitTileL = 'cm';
  String _unitTileW = 'cm';
  String _costPricingMode = 'per Box'; // 'per Box', 'per Tile', 'per m²'
  double _wastePercentage = 0.0;

  // Dynamic Exclusions (Windows, Doors)
  final List<ExclusionItem> _exclusions = [];

  void _addExclusionItem() {
    final wController = TextEditingController(text: '0.0');
    final hController = TextEditingController(text: '0.0');
    wController.addListener(_onInputChange);
    hController.addListener(_onInputChange);

    final initialUnit =
        _exclusions.isNotEmpty ? _exclusions.last.unitWidth : 'ft';

    setState(() {
      _exclusions.add(
        ExclusionItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          widthController: wController,
          heightController: hController,
          unitWidth: initialUnit,
          unitHeight: initialUnit,
        ),
      );
    });
  }

  void _removeExclusionItem(int index) {
    if (_exclusions.isEmpty) return;
    setState(() {
      final item = _exclusions.removeAt(index);
      item.dispose();
    });
  }

  @override
  void initState() {
    super.initState();
    _roomLengthController = TextEditingController(text: '6.0');
    _roomWidthController = TextEditingController(text: '5.0');
    _directAreaController = TextEditingController(text: '20.0');
    _tileLengthController = TextEditingController(text: '60');
    _tileWidthController = TextEditingController(text: '60');
    _tilesPerBoxController = TextEditingController(text: '4');
    _groutGapController = TextEditingController(text: '2');
    _costPerBoxController = TextEditingController(text: '35.00');

    // Add listeners for auto calculation
    _roomLengthController.addListener(_onInputChange);
    _roomWidthController.addListener(_onInputChange);
    _directAreaController.addListener(_onInputChange);
    _tileLengthController.addListener(_onInputChange);
    _tileWidthController.addListener(_onInputChange);
    _tilesPerBoxController.addListener(_onInputChange);
    _groutGapController.addListener(_onInputChange);
    _costPerBoxController.addListener(_onInputChange);

    // Initialize with 1 exclusion item
    _addExclusionItem();
  }

  @override
  void dispose() {
    _roomLengthController.dispose();
    _roomWidthController.dispose();
    _directAreaController.dispose();
    _tileLengthController.dispose();
    _tileWidthController.dispose();
    _tilesPerBoxController.dispose();
    _groutGapController.dispose();
    _costPerBoxController.dispose();
    for (final item in _exclusions) {
      item.dispose();
    }
    super.dispose();
  }

  void _onInputChange() {
    setState(() {});
  }

  // Raw values from inputs
  double get roomLength => double.tryParse(_roomLengthController.text) ?? 0.0;
  double get roomWidth => double.tryParse(_roomWidthController.text) ?? 0.0;
  double get directArea => double.tryParse(_directAreaController.text) ?? 0.0;
  double get tileLength => double.tryParse(_tileLengthController.text) ?? 0.0;
  double get tileWidth => double.tryParse(_tileWidthController.text) ?? 0.0;
  int get tilesPerBox => int.tryParse(_tilesPerBoxController.text) ?? 1;
  double get costPerBox => double.tryParse(_costPerBoxController.text) ?? 0.0;

  // Length & Width converted to meters
  double get roomLengthM {
    switch (_unitLength) {
      case 'cm':
        return roomLength / 100.0;
      case 'ft':
        return roomLength * 0.3048;
      case 'in':
        return roomLength * 0.0254;
      case 'm':
      default:
        return roomLength;
    }
  }

  double get roomWidthM {
    switch (_unitWidth) {
      case 'cm':
        return roomWidth / 100.0;
      case 'ft':
        return roomWidth * 0.3048;
      case 'in':
        return roomWidth * 0.0254;
      case 'm':
      default:
        return roomWidth;
    }
  }

  double get totalExclusionAreaM2 {
    double total = 0.0;
    for (final item in _exclusions) {
      total += item.areaM2;
    }
    return total;
  }

  // Direct area converted to square meters (m²)
  double get directAreaM2 {
    switch (_unitDirectArea) {
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

  // Gross area before deductions
  double get grossArea {
    if (_areaMode == 'dimensions') {
      return roomLengthM * roomWidthM;
    } else {
      return directAreaM2;
    }
  }

  // Net calculated area in square meters (m²) after subtracting exclusions
  double get netArea {
    return max(0.0, grossArea - totalExclusionAreaM2);
  }

  double get tileLengthM {
    switch (_unitTileL) {
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
    switch (_unitTileW) {
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

  double get areaWithWaste => netArea * (1 + _wastePercentage / 100);

  int get totalTilesNeeded {
    if (singleTileArea <= 0) return 0;
    return (areaWithWaste / singleTileArea).ceil();
  }

  int get fullBoxes {
    if (tilesPerBox <= 0) return totalTilesNeeded;
    return totalTilesNeeded ~/ tilesPerBox;
  }

  int get looseTiles {
    if (tilesPerBox <= 0) return 0;
    return totalTilesNeeded % tilesPerBox;
  }

  double get boxCoverage => tilesPerBox * singleTileArea;

  double get totalCost {
    switch (_costPricingMode) {
      case 'per Tile':
        return totalTilesNeeded * costPerBox;
      case 'per m²':
        return (totalTilesNeeded * singleTileArea) * costPerBox;
      case 'per Box':
      default:
        return (fullBoxes * costPerBox) + (looseTiles * (costPerBox / tilesPerBox));
    }
  }

  String get currencySymbol => _currencySymbols[_selectedCurrency] ?? '\$';

  void _copySummary() {
    final orderQtyText = fullBoxes > 0
        ? (looseTiles > 0 ? '$fullBoxes Boxes + $looseTiles ${looseTiles == 1 ? 'Tile' : 'Tiles'}' : '$fullBoxes Boxes')
        : '$looseTiles ${looseTiles == 1 ? 'Tile' : 'Tiles'}';

    final text = '''
Tile Calculation Summary:
- Order Quantity: $orderQtyText
- Total Tiles Needed: $totalTilesNeeded pcs
- Area (with waste): ${areaWithWaste.toStringAsFixed(2)} m²
- Pricing Option: $_costPricingMode
- Estimated Cost: $currencySymbol${totalCost.toStringAsFixed(2)}
'''
        .trim();

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: widget.isDarkMode
            ? Colors.white
            : const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF22C55E),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Summary copied to clipboard successfully!',
                style: TextStyle(
                  color: widget.isDarkMode
                      ? const Color(0xFF0F172A)
                      : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      appBar: HeaderAppBar(
        isDark: isDark,
        onToggleTheme: widget.onToggleTheme,
        selectedCurrency: _selectedCurrency,
        onCurrencyChanged: (val) {
          if (val != null) setState(() => _selectedCurrency = val);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 850;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildInputsColumn(isDark)),
                        const SizedBox(width: 24),
                        Expanded(flex: 5, child: _buildResultsColumn(isDark)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildInputsColumn(isDark),
                        const SizedBox(height: 24),
                        _buildResultsColumn(isDark),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color:
                  isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: Text(
          'TileCalc Pro © 2026. Designed for precision flooring, tiling & remodeling projects. Developed by Kumail Computer.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildInputsColumn(bool isDark) {
    return Column(
      children: [
        AreaInputSection(
          isDark: isDark,
          areaMode: _areaMode,
          onAreaModeChanged: (mode) => setState(() => _areaMode = mode),
          roomLengthController: _roomLengthController,
          roomWidthController: _roomWidthController,
          directAreaController: _directAreaController,
          unitLength: _unitLength,
          onUnitLengthChanged: (val) {
            if (val != null) {
              setState(() {
                _unitLength = val;
                _unitWidth = val;
              });
            }
          },
          unitWidth: _unitWidth,
          onUnitWidthChanged: (val) {
            if (val != null) {
              setState(() {
                _unitWidth = val;
                _unitLength = val;
              });
            }
          },
          unitDirectArea: _unitDirectArea,
          onUnitDirectAreaChanged: (val) {
            if (val != null) setState(() => _unitDirectArea = val);
          },
          exclusions: _exclusions,
          onAddExclusion: _addExclusionItem,
          onRemoveExclusion: _removeExclusionItem,
          onExclusionUnitChanged: (item, val) {
            if (val != null) {
              setState(() {
                item.unitWidth = val;
                item.unitHeight = val;
              });
            }
          },
          grossArea: grossArea,
          totalExclusionAreaM2: totalExclusionAreaM2,
          netArea: netArea,
          roomLengthM: roomLengthM,
          roomWidthM: roomWidthM,
        ),
        const SizedBox(height: 16),
        TileSpecsSection(
          isDark: isDark,
          tileLengthController: _tileLengthController,
          tileWidthController: _tileWidthController,
          tilesPerBoxController: _tilesPerBoxController,
          groutGapController: _groutGapController,
          costPerBoxController: _costPerBoxController,
          unitTileL: _unitTileL,
          onUnitTileLChanged: (val) {
            if (val != null) {
              setState(() {
                _unitTileL = val;
                _unitTileW = val;
              });
            }
          },
          unitTileW: _unitTileW,
          onUnitTileWChanged: (val) {
            if (val != null) {
              setState(() {
                _unitTileW = val;
                _unitTileL = val;
              });
            }
          },
          currencySymbol: currencySymbol,
          costPricingMode: _costPricingMode,
          onCostPricingModeChanged: (val) {
            if (val != null) setState(() => _costPricingMode = val);
          },
          singleTileArea: singleTileArea,
          tileLengthM: tileLengthM,
          tileWidthM: tileWidthM,
        ),
        const SizedBox(height: 16),
        WasteSection(
          isDark: isDark,
          wastePercentage: _wastePercentage,
          onWastePercentageChanged: (val) =>
              setState(() => _wastePercentage = val),
        ),
      ],
    );
  }

  Widget _buildResultsColumn(bool isDark) {
    return Column(
      children: [
        ResultsSummaryCard(
          isDark: isDark,
          fullBoxes: fullBoxes,
          looseTiles: looseTiles,
          totalCost: totalCost,
          currencySymbol: currencySymbol,
          totalTilesNeeded: totalTilesNeeded,
          areaWithWaste: areaWithWaste,
          netArea: netArea,
          singleTileArea: singleTileArea,
          boxCoverage: boxCoverage,
          onCopySummary: _copySummary,
        ),
        const SizedBox(height: 16),
        LayoutPreviewCard(
          isDark: isDark,
          areaMode: _areaMode,
          roomLengthM: roomLengthM,
          roomWidthM: roomWidthM,
          tileLengthM: tileLengthM,
          tileWidthM: tileWidthM,
        ),
      ],
    );
  }
}
