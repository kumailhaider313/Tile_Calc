import 'package:flutter/material.dart';
import '../models/exclusion_item.dart';
import 'common_input_field.dart';

class AreaInputSection extends StatelessWidget {
  final bool isDark;
  final String areaMode;
  final ValueChanged<String> onAreaModeChanged;

  final TextEditingController roomLengthController;
  final TextEditingController roomWidthController;
  final TextEditingController directAreaController;

  final String unitLength;
  final ValueChanged<String?> onUnitLengthChanged;
  final String unitWidth;
  final ValueChanged<String?> onUnitWidthChanged;
  final String unitDirectArea;
  final ValueChanged<String?> onUnitDirectAreaChanged;

  final List<ExclusionItem> exclusions;
  final VoidCallback onAddExclusion;
  final ValueChanged<int> onRemoveExclusion;
  final Function(ExclusionItem item, String? val) onExclusionUnitChanged;

  final double grossArea;
  final double totalExclusionAreaM2;
  final double netArea;
  final double roomLengthM;
  final double roomWidthM;

  const AreaInputSection({
    super.key,
    required this.isDark,
    required this.areaMode,
    required this.onAreaModeChanged,
    required this.roomLengthController,
    required this.roomWidthController,
    required this.directAreaController,
    required this.unitLength,
    required this.onUnitLengthChanged,
    required this.unitWidth,
    required this.onUnitWidthChanged,
    required this.unitDirectArea,
    required this.onUnitDirectAreaChanged,
    required this.exclusions,
    required this.onAddExclusion,
    required this.onRemoveExclusion,
    required this.onExclusionUnitChanged,
    required this.grossArea,
    required this.totalExclusionAreaM2,
    required this.netArea,
    required this.roomLengthM,
    required this.roomWidthM,
  });

  @override
  Widget build(BuildContext context) {
    return buildSectionCard(
      isDark: isDark,
      number: '1',
      title: 'Area Input Method',
      headerAction: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTabButton(
              title: 'Room Dimensions',
              isActive: areaMode == 'dimensions',
              isDark: isDark,
              onTap: () => onAreaModeChanged('dimensions'),
            ),
            buildTabButton(
              title: 'Direct Area',
              isActive: areaMode == 'direct',
              isDark: isDark,
              onTap: () => onAreaModeChanged('direct'),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          areaMode == 'dimensions'
              ? Row(
                  children: [
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: 'Room Length',
                        controller: roomLengthController,
                        unitValue: unitLength,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: onUnitLengthChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: 'Room Width',
                        controller: roomWidthController,
                        unitValue: unitWidth,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: onUnitWidthChanged,
                      ),
                    ),
                  ],
                )
              : buildInputFieldWithUnit(
                  isDark: isDark,
                  label: 'Total Surface Area',
                  controller: directAreaController,
                  unitValue: unitDirectArea,
                  unitOptions: const ['m²', 'cm²', 'sq ft', 'sq in'],
                  onUnitChanged: onUnitDirectAreaChanged,
                ),

          const SizedBox(height: 12),
          Divider(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 12),

          // Deductions / Exclusions Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.crop_free_rounded,
                    size: 16,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Deductions / Exclusions (Windows, Doors)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onAddExclusion,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF064E3B)
                        : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF10B981)
                          : const Color(0xFF16A34A),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 14,
                        color: isDark
                            ? const Color(0xFF34D399)
                            : const Color(0xFF15803D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add Cutout',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFF34D399)
                              : const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Render List of Dynamic Exclusion Items
          Column(
            children: List.generate(exclusions.length, (index) {
              final item = exclusions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: exclusions.length > 1
                            ? 'Cutout #${index + 1} Width'
                            : 'Exclusion Width',
                        controller: item.widthController,
                        unitValue: item.unitWidth,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: (val) =>
                            onExclusionUnitChanged(item, val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: exclusions.length > 1
                            ? 'Cutout #${index + 1} Height'
                            : 'Exclusion Height',
                        controller: item.heightController,
                        unitValue: item.unitHeight,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: (val) =>
                            onExclusionUnitChanged(item, val),
                      ),
                    ),
                    if (exclusions.length > 1 ||
                        item.width > 0 ||
                        item.height > 0) ...[
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: IconButton(
                          onPressed: () => onRemoveExclusion(index),
                          icon: const Icon(
                            Icons.remove_circle_outline_rounded,
                          ),
                          color: isDark
                              ? const Color(0xFFF87171)
                              : const Color(0xFFEF4444),
                          tooltip: 'Remove Cutout',
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Highlighted Green Box showing Net Area in Meters (m²)
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
                    Icons.aspect_ratio_rounded,
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
                        'TOTAL CALCULATED AREA (IN METERS)',
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
                            netArea.toStringAsFixed(2),
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
                          if (totalExclusionAreaM2 > 0) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '(Gross: ${grossArea.toStringAsFixed(2)}m² - Cutouts: ${totalExclusionAreaM2.toStringAsFixed(2)}m²)',
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
                          ] else if (areaMode == 'dimensions' &&
                              (unitLength != 'm' || unitWidth != 'm')) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '(${roomLengthM.toStringAsFixed(2)}m × ${roomWidthM.toStringAsFixed(2)}m)',
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
