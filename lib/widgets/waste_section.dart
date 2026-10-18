import 'package:flutter/material.dart';
import 'common_input_field.dart';

class WasteSection extends StatelessWidget {
  final bool isDark;
  final double wastePercentage;
  final ValueChanged<double> onWastePercentageChanged;

  const WasteSection({
    super.key,
    required this.isDark,
    required this.wastePercentage,
    required this.onWastePercentageChanged,
  });

  Widget _buildPresetBadge(String label, double value) {
    final isSelected = wastePercentage == value;
    return GestureDetector(
      onTap: () => onWastePercentageChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7))
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          border: Border.all(
            color: isSelected ? const Color(0xFF16A34A) : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? (isDark ? const Color(0xFF34D399) : const Color(0xFF15803D))
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSectionCard(
      isDark: isDark,
      number: '3',
      title: 'Waste & Cutting Buffer (%)',
      headerAction: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${wastePercentage.toInt()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF34D399) : const Color(0xFF16A34A),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF16A34A),
              inactiveTrackColor: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF16A34A),
              overlayColor: const Color(0xFF16A34A).withValues(alpha: 0.15),
              trackHeight: 6,
            ),
            child: Slider(
              value: wastePercentage,
              min: 0,
              max: 25,
              divisions: 25,
              onChanged: onWastePercentageChanged,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetBadge('Exact / No Waste (0%)', 0.0),
              _buildPresetBadge('Straight Lay (5%)', 5.0),
              _buildPresetBadge('Standard / Rooms (10%)', 10.0),
              _buildPresetBadge('Diagonal / Complex (15%)', 15.0),
              _buildPresetBadge('Intricate Patterns (20%)', 20.0),
            ],
          ),
        ],
      ),
    );
  }
}
