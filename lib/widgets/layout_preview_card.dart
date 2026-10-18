import 'dart:math';
import 'package:flutter/material.dart';

class LayoutPreviewCard extends StatelessWidget {
  final bool isDark;
  final String areaMode;
  final double roomLengthM;
  final double roomWidthM;
  final double tileLengthM;
  final double tileWidthM;

  const LayoutPreviewCard({
    super.key,
    required this.isDark,
    required this.areaMode,
    required this.roomLengthM,
    required this.roomWidthM,
    required this.tileLengthM,
    required this.tileWidthM,
  });

  Widget _buildVisualGridPreview() {
    if (areaMode != 'dimensions' ||
        roomLengthM <= 0 ||
        roomWidthM <= 0 ||
        tileLengthM <= 0 ||
        tileWidthM <= 0) {
      return Text(
        'Switch to Room Dimensions for Visual Matrix',
        style: TextStyle(
          fontSize: 12,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
      );
    }

    int cols = (roomLengthM / tileLengthM).ceil();
    int rows = (roomWidthM / tileWidthM).ceil();

    // Cap preview grid elements for rendering performance and clean look
    int maxCols = min(cols, 8);
    int maxRows = min(rows, 6);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = (constraints.maxWidth - (maxCols - 1) * 4) / maxCols;
        final cellHeight =
            (constraints.maxHeight - (maxRows - 1) * 4) / maxRows;
        final cellSize = min(cellWidth, cellHeight).clamp(16.0, 36.0);

        return SizedBox(
          width: (cellSize * maxCols) + ((maxCols - 1) * 4),
          height: (cellSize * maxRows) + ((maxRows - 1) * 4),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maxCols,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: maxCols * maxRows,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : const Color(0xFF10B981).withValues(alpha: 0.12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Icon(
                    Icons.grid_3x3_rounded,
                    size: cellSize * 0.45,
                    color: isDark
                        ? const Color(0xFF34D399)
                        : const Color(0xFF059669),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Color(0xFF16A34A),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Interactive Layout Preview',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                areaMode == 'dimensions' ? 'Grid Matrix' : 'Direct Area Mode',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Preview Grid Canvas
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF020617)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Center(
              child: _buildVisualGridPreview(),
            ),
          ),

          const SizedBox(height: 12),

          // Legend below preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                areaMode == 'dimensions' && roomLengthM > 0 && tileLengthM > 0
                    ? 'Est. Tiles across length: ${(roomLengthM / tileLengthM).ceil()}'
                    : 'Tiles per row: N/A',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              Text(
                areaMode == 'dimensions' && roomWidthM > 0 && tileWidthM > 0
                    ? 'Est. Tiles across width: ${(roomWidthM / tileWidthM).ceil()}'
                    : 'Rows high: N/A',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
