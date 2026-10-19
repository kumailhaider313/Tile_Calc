import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/exclusion_item.dart';
import '../models/room_area_item.dart';
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

  final Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'PKR': '₨',
    'INR': '₹',
  };

  // Multi-Room / Multi-Area list
  final List<RoomAreaItem> _rooms = [];
  int _selectedRoomIndex = 0;

  RoomAreaItem get activeRoom =>
      _rooms.isNotEmpty ? _rooms[_selectedRoomIndex] : _rooms.first;

  // Tile & Pricing Controllers
  late TextEditingController _tileLengthController;
  late TextEditingController _tileWidthController;
  late TextEditingController _tilesPerBoxController;
  late TextEditingController _groutGapController;
  late TextEditingController _costPerBoxController;

  String _unitTileL = 'cm';
  String _unitTileW = 'cm';
  String _costPricingMode = 'per Box'; // 'per Box', 'per Tile', 'per m²'
  double _wastePercentage = 0.0;

  void _addNewRoom(String name,
      [String defaultL = '6.0', String defaultW = '5.0']) {
    final lController = TextEditingController(text: defaultL);
    final wController = TextEditingController(text: defaultW);
    final dController = TextEditingController(text: '20.0');
    lController.addListener(_onInputChange);
    wController.addListener(_onInputChange);
    dController.addListener(_onInputChange);

    final wExController = TextEditingController(text: '0.0');
    final hExController = TextEditingController(text: '0.0');
    wExController.addListener(_onInputChange);
    hExController.addListener(_onInputChange);

    final exclusion = ExclusionItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      widthController: wExController,
      heightController: hExController,
      unitWidth: 'ft',
      unitHeight: 'ft',
    );

    final skirtingCutoutC = TextEditingController(text: '0.0');
    skirtingCutoutC.addListener(_onInputChange);

    setState(() {
      _rooms.add(
        RoomAreaItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: name,
          lengthController: lController,
          widthController: wController,
          directAreaController: dController,
          unitLength: 'ft',
          unitWidth: 'ft',
          exclusions: [exclusion],
          skirtingHeightInches: 4,
          skirtingCutoutController: skirtingCutoutC,
          skirtingCutoutUnit: 'ft',
        ),
      );
      _selectedRoomIndex = _rooms.length - 1;
    });
  }

  void _showAddRoomDialog() {
    final nameController = TextEditingController(text: 'Bathroom');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            widget.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
        title: const Text('Add Area / Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter room or area name:',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. Bathroom, Kitchen, Living Room',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                'Bathroom',
                'Kitchen',
                'Bedroom',
                'Living Room',
                'Balcony',
                'Corridor'
              ].map((suggestion) {
                return ActionChip(
                  label: Text(suggestion, style: const TextStyle(fontSize: 11)),
                  onPressed: () {
                    nameController.text = suggestion;
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A)),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                _addNewRoom(name);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _removeRoom(int index) {
    if (_rooms.length <= 1) return;
    setState(() {
      final removed = _rooms.removeAt(index);
      removed.dispose();
      if (_selectedRoomIndex >= _rooms.length) {
        _selectedRoomIndex = _rooms.length - 1;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tileLengthController = TextEditingController(text: '60');
    _tileWidthController = TextEditingController(text: '60');
    _tilesPerBoxController = TextEditingController(text: '4');
    _groutGapController = TextEditingController(text: '2');
    _costPerBoxController = TextEditingController(text: '35.00');

    // Add listeners for auto calculation
    _tileLengthController.addListener(_onInputChange);
    _tileWidthController.addListener(_onInputChange);
    _tilesPerBoxController.addListener(_onInputChange);
    _groutGapController.addListener(_onInputChange);
    _costPerBoxController.addListener(_onInputChange);

    // Initialize with default Floor room
    _addNewRoom('Floor', '6.0', '5.0');
  }

  @override
  void dispose() {
    _tileLengthController.dispose();
    _tileWidthController.dispose();
    _tilesPerBoxController.dispose();
    _groutGapController.dispose();
    _costPerBoxController.dispose();
    for (final room in _rooms) {
      room.dispose();
    }
    super.dispose();
  }

  void _onInputChange() {
    setState(() {});
  }

  // Raw values from inputs
  double get tileLength => double.tryParse(_tileLengthController.text) ?? 0.0;
  double get tileWidth => double.tryParse(_tileWidthController.text) ?? 0.0;
  int get tilesPerBox => int.tryParse(_tilesPerBoxController.text) ?? 1;
  double get costPerBox => double.tryParse(_costPerBoxController.text) ?? 0.0;

  // Aggregate Exclusions across all rooms
  double get totalExclusionAreaM2 {
    double total = 0.0;
    for (final room in _rooms) {
      total += room.exclusionAreaM2;
    }
    return total;
  }

  // Aggregate Gross Area across all rooms
  double get grossArea {
    double total = 0.0;
    for (final room in _rooms) {
      total += room.grossArea;
    }
    return total;
  }

  double get totalSkirtingAreaM2 {
    double total = 0.0;
    for (final room in _rooms) {
      if (room.name.toLowerCase() == 'floor' && room.skirtingHeightInches > 0) {
        total += room.netSkirtingPerimeterM *
            (room.skirtingHeightInches * 0.0254);
      }
    }
    return total;
  }

  // Aggregate Net calculated area in square meters (m²) across all rooms + skirting area
  double get netArea {
    return max(0.0, grossArea - totalExclusionAreaM2) + totalSkirtingAreaM2;
  }

  double get roomLengthM => activeRoom.lengthM;
  double get roomWidthM => activeRoom.widthM;

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
        return (fullBoxes * costPerBox) +
            (looseTiles * (costPerBox / tilesPerBox));
    }
  }

  String get currencySymbol => _currencySymbols[_selectedCurrency] ?? '\$';

  void _copySummary() {
    final orderQtyText = fullBoxes > 0
        ? (looseTiles > 0
            ? '$fullBoxes Boxes + $looseTiles ${looseTiles == 1 ? 'Tile' : 'Tiles'}'
            : '$fullBoxes Boxes')
        : '$looseTiles ${looseTiles == 1 ? 'Tile' : 'Tiles'}';

    final text = '''
Tile Calculation Summary:
- Areas Included: ${_rooms.map((r) => r.name).join(', ')}
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
        backgroundColor:
            widget.isDarkMode ? Colors.white : const Color(0xFF0F172A),
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
          rooms: _rooms,
          selectedRoomIndex: _selectedRoomIndex,
          onRoomSelected: (idx) => setState(() => _selectedRoomIndex = idx),
          onAddRoom: _showAddRoomDialog,
          onDeleteRoom: _removeRoom,
          activeRoom: activeRoom,
          onStateChanged: () => setState(() {}),
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
          areaMode: activeRoom.areaMode,
          roomLengthM: roomLengthM,
          roomWidthM: roomWidthM,
          tileLengthM: tileLengthM,
          tileWidthM: tileWidthM,
        ),
      ],
    );
  }
}
