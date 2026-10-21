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

  late TextEditingController _groutGapController;
  double _wastePercentage = 0.0;

  void _addNewRoom(String name,
      [String defaultL = '6.0', String defaultW = '5.0']) {
    String tileL = '60';
    String tileW = '60';
    String tileUnit = 'cm';
    String wallH = '7.0';

    if (name.toLowerCase().contains('bathroom')) {
      defaultL = '8.0';
      defaultW = '6.0';
      tileL = '6';
      tileW = '4';
      tileUnit = 'in';
    } else if (name.toLowerCase().contains('room') ||
        name.toLowerCase().contains('bedroom') ||
        name.toLowerCase().contains('living')) {
      defaultL = '12.0';
      defaultW = '10.0';
      tileL = '12';
      tileW = '14';
      tileUnit = 'in';
    }

    final lController = TextEditingController(text: defaultL);
    final wController = TextEditingController(text: defaultW);
    final dController = TextEditingController(text: '20.0');
    final wallHC = TextEditingController(text: wallH);
    final skirtingCutoutC = TextEditingController(text: '0.0');

    final tLC = TextEditingController(text: tileL);
    final tWC = TextEditingController(text: tileW);
    final tBoxC = TextEditingController(text: '10');
    final costC = TextEditingController(text: '1800.00');

    final openingWC = TextEditingController(text: '0.0');
    final openingHC = TextEditingController(text: '0.0');

    lController.addListener(_onInputChange);
    wController.addListener(_onInputChange);
    dController.addListener(_onInputChange);
    wallHC.addListener(_onInputChange);
    skirtingCutoutC.addListener(_onInputChange);
    tLC.addListener(_onInputChange);
    tWC.addListener(_onInputChange);
    tBoxC.addListener(_onInputChange);
    costC.addListener(_onInputChange);
    openingWC.addListener(_onInputChange);
    openingHC.addListener(_onInputChange);

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
          wallHeightController: wallHC,
          wallHeightUnit: 'ft',
          tileLengthController: tLC,
          tileWidthController: tWC,
          tilesPerBoxController: tBoxC,
          costPerBoxController: costC,
          unitTileL: tileUnit,
          unitTileW: tileUnit,
          costPricingMode: 'per m²',
          darkValue: 3,
          motiveValue: 1,
          openingWidthController: openingWC,
          openingHeightController: openingHC,
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
    _groutGapController = TextEditingController(text: '2');
    _groutGapController.addListener(_onInputChange);

    // Initialize with default Floor room (12x14 inch default for Room, 6x4 inch for Bathroom, 60x60cm for Floor)
    _addNewRoom('Floor', '6.0', '5.0');
  }

  @override
  void dispose() {
    _groutGapController.dispose();
    for (final room in _rooms) {
      room.dispose();
    }
    super.dispose();
  }

  void _onInputChange() {
    setState(() {});
  }

  // Aggregate Gross Area across all rooms (including bathroom walls)
  double get grossArea {
    double total = 0.0;
    for (final room in _rooms) {
      total += room.totalRoomAreaM2;
    }
    return total;
  }

  // Aggregate Exclusions across all rooms
  double get totalExclusionAreaM2 {
    double total = 0.0;
    for (final room in _rooms) {
      total += room.exclusionAreaM2;
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

  double get areaWithWaste => netArea * (1 + _wastePercentage / 100);

  int get totalFloorTiles {
    int total = 0;
    for (final room in _rooms) {
      total += room.getFloorTilesCount(_wastePercentage);
    }
    return total;
  }

  int get totalDarkTiles {
    int total = 0;
    for (final room in _rooms) {
      total += room.getDarkTilesCount(_wastePercentage);
    }
    return total;
  }

  int get totalMotiveTiles {
    int total = 0;
    for (final room in _rooms) {
      total += room.getMotiveTilesCount(_wastePercentage);
    }
    return total;
  }

  int get totalSkirtingTiles {
    int total = 0;
    for (final room in _rooms) {
      total += room.getSkirtingTilesCount();
    }
    return total;
  }

  int get totalLightTiles {
    int total = 0;
    for (final room in _rooms) {
      total += room.getLightTilesCount(_wastePercentage);
    }
    return total;
  }

  int get totalBathroomWallTiles {
    int total = 0;
    for (final room in _rooms) {
      if (room.name.toLowerCase().contains('bathroom') &&
          room.wallHeightM > 0 &&
          room.darkValue == 0 &&
          room.singleTileArea > 0) {
        double wArea = room.perimeterM * room.wallHeightM;
        total +=
            (wArea * (1 + _wastePercentage / 100) / room.singleTileArea).ceil();
      }
    }
    return total;
  }

  int get totalTilesNeeded {
    return totalFloorTiles +
        totalDarkTiles +
        totalMotiveTiles +
        totalSkirtingTiles +
        totalBathroomWallTiles +
        totalLightTiles;
  }

  int get fullBoxes {
    if (activeRoom.tilesPerBox <= 0) return totalTilesNeeded;
    return totalTilesNeeded ~/ activeRoom.tilesPerBox;
  }

  int get looseTiles {
    if (activeRoom.tilesPerBox <= 0) return 0;
    return totalTilesNeeded % activeRoom.tilesPerBox;
  }

  double get boxCoverage => activeRoom.tilesPerBox * activeRoom.singleTileArea;

  double get totalCost {
    double total = 0.0;
    for (final room in _rooms) {
      if (room.singleTileArea <= 0) continue;
      int rTiles = room.getFloorTilesCount(_wastePercentage) +
          room.getDarkTilesCount(_wastePercentage) +
          room.getMotiveTilesCount(_wastePercentage) +
          room.getSkirtingTilesCount() +
          room.getLightTilesCount(_wastePercentage);
      if (room.name.toLowerCase().contains('bathroom') &&
          room.wallHeightM > 0 &&
          room.darkValue == 0) {
        rTiles +=
            (room.perimeterM * room.wallHeightM * (1 + _wastePercentage / 100) / room.singleTileArea).ceil();
      }

      int rBoxes = room.tilesPerBox > 0
          ? (rTiles / room.tilesPerBox).ceil().toInt()
          : rTiles;
      int rLoose = room.tilesPerBox > 0 ? rTiles % room.tilesPerBox : 0;

      switch (room.costPricingMode) {
        case 'per Tile':
          total += rTiles * room.costPerBox;
          break;
        case 'per m²':
          total += (rTiles * room.singleTileArea) * room.costPerBox;
          break;
        case 'per Box':
        default:
          total += (rBoxes * room.costPerBox) +
              (rLoose * (room.costPerBox / max(1, room.tilesPerBox)));
          break;
      }
    }
    return total;
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
- Pricing Option: ${activeRoom.costPricingMode}
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
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 11),
            children: [
              TextSpan(
                text:
                    'TileCalc Pro © 2026. Designed for precision flooring, tiling & remodeling projects. ',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
              TextSpan(
                text: 'Developed by Kumail Computer.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF34D399)
                      : const Color(0xFF16A34A),
                ),
              ),
            ],
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
          tileLengthController: activeRoom.tileLengthController,
          tileWidthController: activeRoom.tileWidthController,
          tilesPerBoxController: activeRoom.tilesPerBoxController,
          groutGapController: _groutGapController,
          costPerBoxController: activeRoom.costPerBoxController,
          unitTileL: activeRoom.unitTileL,
          onUnitTileLChanged: (val) {
            if (val != null) {
              setState(() {
                activeRoom.unitTileL = val;
                activeRoom.unitTileW = val;
              });
            }
          },
          unitTileW: activeRoom.unitTileW,
          onUnitTileWChanged: (val) {
            if (val != null) {
              setState(() {
                activeRoom.unitTileW = val;
                activeRoom.unitTileL = val;
              });
            }
          },
          currencySymbol: currencySymbol,
          costPricingMode: activeRoom.costPricingMode,
          onCostPricingModeChanged: (val) {
            if (val != null) {
              setState(() {
                activeRoom.costPricingMode = val;
              });
            }
          },
          singleTileArea: activeRoom.singleTileArea,
          tileLengthM: activeRoom.tileLengthM,
          tileWidthM: activeRoom.tileWidthM,
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
          singleTileArea: activeRoom.singleTileArea,
          boxCoverage: boxCoverage,
          onCopySummary: _copySummary,
          rooms: _rooms,
          wastePercentage: _wastePercentage,
        ),
        const SizedBox(height: 16),
        LayoutPreviewCard(
          isDark: isDark,
          areaMode: activeRoom.areaMode,
          roomLengthM: roomLengthM,
          roomWidthM: roomWidthM,
          tileLengthM: activeRoom.tileLengthM,
          tileWidthM: activeRoom.tileWidthM,
        ),
      ],
    );
  }
}
