import 'package:flutter/material.dart';

class ResultsSummaryCard extends StatelessWidget {
  final bool isDark;
  final int fullBoxes;
  final int looseTiles;
  final double totalCost;
  final String currencySymbol;
  final int totalTilesNeeded;
  final double areaWithWaste;
  final double netArea;
  final double singleTileArea;
  final double boxCoverage;
  final VoidCallback onCopySummary;

  const ResultsSummaryCard({
    super.key,
    required this.isDark,
    required this.fullBoxes,
    required this.looseTiles,
    required this.totalCost,
    required this.currencySymbol,
    required this.totalTilesNeeded,
    required this.areaWithWaste,
    required this.netArea,
    required this.singleTileArea,
    required this.boxCoverage,
    required this.onCopySummary,
  });

  Widget _buildMetricTile(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFFA7F3D0),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFA7F3D0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Copy Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CALCULATION SUMMARY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: Color(0xFFA7F3D0),
                ),
              ),
              InkWell(
                onTap: onCopySummary,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.copy_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Copy Stats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Primary Metric Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommended Order Quantity',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA7F3D0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            fullBoxes > 0 ? '$fullBoxes' : '$looseTiles',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              fullBoxes > 0
                                  ? (looseTiles > 0
                                      ? 'Boxes + $looseTiles ${looseTiles == 1 ? 'Tile' : 'Tiles'}'
                                      : 'Boxes')
                                  : (looseTiles == 1 ? 'Tile' : 'Tiles'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD1FAE5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$currencySymbol${totalCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Estimated Cost',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFA7F3D0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Secondary Metrics Grid (6 items)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              _buildMetricTile(
                'Net Surface Area',
                netArea.toStringAsFixed(2),
                'm²',
              ),
              _buildMetricTile(
                'Area with Waste',
                areaWithWaste.toStringAsFixed(2),
                'm²',
              ),
              _buildMetricTile(
                'Total Tiles Needed',
                '$totalTilesNeeded',
                'pcs',
              ),
              _buildMetricTile(
                'Area of One Box',
                boxCoverage.toStringAsFixed(2),
                'm²',
              ),
              _buildMetricTile(
                'Total Tiles Area',
                (totalTilesNeeded * singleTileArea).toStringAsFixed(2),
                'm²',
              ),
              _buildMetricTile(
                'Single Tile Area',
                singleTileArea.toStringAsFixed(2),
                'm²',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
