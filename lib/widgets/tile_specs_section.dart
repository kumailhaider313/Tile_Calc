import 'package:flutter/material.dart';
import 'common_input_field.dart';

class TileSpecsSection extends StatelessWidget {
  final bool isDark;
  final TextEditingController tileLengthController;
  final TextEditingController tileWidthController;
  final TextEditingController tilesPerBoxController;
  final TextEditingController groutGapController;
  final TextEditingController costPerBoxController;

  final String unitTileL;
  final ValueChanged<String?> onUnitTileLChanged;
  final String unitTileW;
  final ValueChanged<String?> onUnitTileWChanged;

  final String currencySymbol;
  final String costPricingMode;
  final ValueChanged<String?> onCostPricingModeChanged;

  final double singleTileArea;
  final double tileLengthM;
  final double tileWidthM;

  const TileSpecsSection({
    super.key,
    required this.isDark,
    required this.tileLengthController,
    required this.tileWidthController,
    required this.tilesPerBoxController,
    required this.groutGapController,
    required this.costPerBoxController,
    required this.unitTileL,
    required this.onUnitTileLChanged,
    required this.unitTileW,
    required this.onUnitTileWChanged,
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
              Expanded(
                child: buildInputFieldWithUnit(
                  isDark: isDark,
                  label: 'Tile Length',
                  controller: tileLengthController,
                  unitValue: unitTileL,
                  unitOptions: const ['cm', 'mm', 'm', 'ft', 'in'],
                  onUnitChanged: onUnitTileLChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildInputFieldWithUnit(
                  isDark: isDark,
                  label: 'Tile Width',
                  controller: tileWidthController,
                  unitValue: unitTileW,
                  unitOptions: const ['cm', 'mm', 'm', 'ft', 'in'],
                  onUnitChanged: onUnitTileWChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                            singleTileArea.toStringAsFixed(
                              singleTileArea < 0.1 ? 4 : 2,
                            ),
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
                              '(${tileLengthM.toStringAsFixed(2)}m × ${tileWidthM.toStringAsFixed(2)}m)',
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
        ],
      ),
    );
  }
}
