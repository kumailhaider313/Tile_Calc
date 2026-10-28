import 'package:flutter/material.dart';
import 'common_input_field.dart';

class TileSpecsSection extends StatelessWidget {
  final bool isDark;
  final bool is12X24Bathroom;
  final TextEditingController? tileLengthController;
  final TextEditingController? tileWidthController;
  final TextEditingController tilesPerBoxController;
  final TextEditingController groutGapController;
  final TextEditingController costPerBoxController;

  final String? unitTileL;
  final ValueChanged<String?>? onUnitTileLChanged;
  final String? unitTileW;
  final ValueChanged<String?>? onUnitTileWChanged;

  final String tileType; // 'Forte' or 'China'
  final ValueChanged<String> onTileTypeChanged;

  final String currencySymbol;
  final String costPricingMode;
  final ValueChanged<String?> onCostPricingModeChanged;

  final double singleTileArea;
  final double tileLengthM;
  final double tileWidthM;

  const TileSpecsSection({
    super.key,
    required this.isDark,
    required this.is12X24Bathroom,
    this.tileLengthController,
    this.tileWidthController,
    required this.tilesPerBoxController,
    required this.groutGapController,
    required this.costPerBoxController,
    this.unitTileL,
    this.onUnitTileLChanged,
    this.unitTileW,
    this.onUnitTileWChanged,
    required this.tileType,
    required this.onTileTypeChanged,
    required this.currencySymbol,
    required this.costPricingMode,
    required this.onCostPricingModeChanged,
    required this.singleTileArea,
    required this.tileLengthM,
    required this.tileWidthM,
  });

  @override
  Widget build(BuildContext context) {
    return buildSectionCard(
      isDark: isDark,
      number: '2',
      title: 'Tile Specifications & Packing',
      child: Column(
        children: [
          Row(
            children: [
              if (is12X24Bathroom)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tile Size / Brand',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onTileTypeChanged('Forte'),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: tileType == 'Forte'
                                      ? (isDark
                                          ? const Color(0xFF064E3B)
                                          : const Color(0xFFDCFCE7))
                                      : (isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: tileType == 'Forte'
                                        ? const Color(0xFF16A34A)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  'Forte (12x24 in)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: tileType == 'Forte'
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: tileType == 'Forte'
                                        ? (isDark
                                            ? const Color(0xFF34D399)
                                            : const Color(0xFF15803D))
                                        : (isDark
                                            ? const Color(0xFFCBD5E1)
                                            : const Color(0xFF475569)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onTileTypeChanged('China'),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: tileType == 'China'
                                      ? (isDark
                                          ? const Color(0xFF064E3B)
                                          : const Color(0xFFDCFCE7))
                                      : (isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: tileType == 'China'
                                        ? const Color(0xFF16A34A)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  'China (30x60 cm)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: tileType == 'China'
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: tileType == 'China'
                                        ? (isDark
                                            ? const Color(0xFF34D399)
                                            : const Color(0xFF15803D))
                                        : (isDark
                                            ? const Color(0xFFCBD5E1)
                                            : const Color(0xFF475569)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else ...[
                Expanded(
                  child: buildInputFieldWithUnit(
                    isDark: isDark,
                    label: 'Tile Length',
                    controller: tileLengthController!,
                    unitValue: unitTileL ?? 'cm',
                    unitOptions: const ['cm', 'inch', 'ft'],
                    onUnitChanged: onUnitTileLChanged ?? (_) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildInputFieldWithUnit(
                    isDark: isDark,
                    label: 'Tile Width',
                    controller: tileWidthController!,
                    unitValue: unitTileW ?? 'cm',
                    unitOptions: const ['cm', 'inch', 'ft'],
                    onUnitChanged: onUnitTileWChanged ?? (_) {},
                  ),
                ),
              ],
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: buildInputField(
                  isDark: isDark,
                  label: 'Tiles per Box',
                  controller: tilesPerBoxController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: buildInputField(
                  isDark: isDark,
                  label: 'Grout Joint Gap (mm)',
                  controller: groutGapController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildInputFieldWithUnit(
                  isDark: isDark,
                  label: 'Estimated Cost',
                  controller: costPerBoxController,
                  prefixText: '$currencySymbol ',
                  unitValue: costPricingMode,
                  unitOptions: const ['per Box', 'per Tile', 'per m²'],
                  onUnitChanged: onCostPricingModeChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Highlighted Green Box showing Single Tile Area in Meters (m²)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF064E3B)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF10B981)
                    : const Color(0xFF16A34A),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF047857)
                        : const Color(0xFF16A34A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.crop_square_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SINGLE TILE AREA (IN METERS)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: isDark
                              ? const Color(0xFFA7F3D0)
                              : const Color(0xFF15803D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            singleTileArea.toStringAsFixed(3),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF064E3B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'm²',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFF16A34A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '(${tileLengthM.toStringAsFixed(3)}m × ${tileWidthM.toStringAsFixed(3)}m)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFA7F3D0)
                                    : const Color(0xFF15803D),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Highlighted Green Box showing One Box Tile Area in Meters (m²)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF064E3B)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF10B981)
                    : const Color(0xFF16A34A),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF047857)
                        : const Color(0xFF16A34A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.view_module_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ONE BOX TILE AREA (${tilesPerBoxController.text.trim()} Tiles / Box)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: isDark
                              ? const Color(0xFFA7F3D0)
                              : const Color(0xFF15803D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            (singleTileArea *
                                    (int.tryParse(tilesPerBoxController.text) ??
                                        8))
                                .toStringAsFixed(3),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF064E3B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'm²',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
