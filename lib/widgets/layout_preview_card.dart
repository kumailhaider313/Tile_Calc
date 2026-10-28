import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LayoutPreviewCard extends StatefulWidget {
  final bool isDark;
  final String areaMode;
  final double roomLengthM;
  final double roomWidthM;
  final double roomHeightM;
  final double tileLengthM;
  final double tileWidthM;
  final bool hasHeight;
  final bool hasSkirting;
  final int darkRows;
  final int motiveRows;
  final double skirtingHeightM;
  final String roomName;

  const LayoutPreviewCard({
    super.key,
    required this.isDark,
    required this.areaMode,
    required this.roomLengthM,
    required this.roomWidthM,
    required this.roomHeightM,
    required this.tileLengthM,
    required this.tileWidthM,
    required this.hasHeight,
    required this.hasSkirting,
    required this.darkRows,
    required this.motiveRows,
    required this.skirtingHeightM,
    required this.roomName,
  });

  @override
  State<LayoutPreviewCard> createState() => _LayoutPreviewCardState();
}

class _LayoutPreviewCardState extends State<LayoutPreviewCard> {
  double _angleX = 0.4;
  double _angleY = -0.6;
  double _scale = 1.0;

  void _resetView() {
    setState(() {
      _angleX = 0.4;
      _angleY = -0.6;
      _scale = 1.0;
    });
  }

  void _zoomIn() {
    setState(() {
      _scale = (_scale + 0.2).clamp(0.5, 3.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale - 0.2).clamp(0.5, 3.0);
    });
  }

  void _openFullscreen(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: widget.isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.view_in_ar_rounded,
                              color: Color(0xFF16A34A), size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Interactive 3D Room Box with Tiles (Fullscreen)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 24),
                        color: widget.isDark ? Colors.white70 : Colors.black87,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _build3DRoomBoxContent(
                        isFullScreen: true, setDialogState: setDialogState),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTileGridForFace({
    required int cols,
    required int rows,
    required double tileAspect,
    required bool isWall,
  }) {
    double shortSide = min(widget.tileLengthM, widget.tileWidthM);
    double darkH = widget.darkRows * shortSide;
    double motiveH = widget.motiveRows * shortSide;
    double skirtingH = widget.skirtingHeightM;

    int maxCols = cols.clamp(1, 8);
    int maxRows = rows.clamp(1, 8);

    return ClipRect(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: maxCols,
          crossAxisSpacing: 1.5,
          mainAxisSpacing: 1.5,
          childAspectRatio: tileAspect,
        ),
        itemCount: maxCols * maxRows,
        itemBuilder: (context, index) {
          int row = index ~/ maxCols;
          int invertedRow = (maxRows - 1) - row;
          double currentHeightFromBottom = (invertedRow + 1) * widget.tileWidthM;

          String typeLabel = 'L';
          Color tileColor = const Color(0xFF059669);

          if (isWall) {
            if (widget.hasSkirting && currentHeightFromBottom <= skirtingH) {
              typeLabel = 'S';
              tileColor = const Color(0xFFD97706); // Skirting
            } else if (widget.hasHeight && currentHeightFromBottom <= darkH) {
              typeLabel = 'D';
              tileColor = const Color(0xFF1E3A8A); // Dark
            } else if (widget.hasHeight &&
                currentHeightFromBottom > darkH &&
                currentHeightFromBottom <= (darkH + motiveH)) {
              typeLabel = 'M';
              tileColor = const Color(0xFF0D9488); // Motive
            } else {
              typeLabel = 'L';
              tileColor = const Color(0xFF059669); // Light
            }
          } else {
            typeLabel = 'L';
            tileColor = const Color(0xFF3B82F6); // Floor
          }

          return Container(
            decoration: BoxDecoration(
              color: tileColor.withValues(alpha: widget.isDark ? 0.45 : 0.35),
              border: Border.all(
                color: tileColor.withValues(alpha: 0.8),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                typeLabel,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: tileColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _build3DRoomBoxContent(
      {bool isFullScreen = false, StateSetter? setDialogState}) {
    if (widget.areaMode != 'dimensions' ||
        widget.roomLengthM <= 0 ||
        (widget.roomWidthM <= 0 && widget.roomHeightM <= 0) ||
        widget.tileLengthM <= 0 ||
        widget.tileWidthM <= 0) {
      return Center(
        child: Text(
          'Switch to Room Dimensions for 3D Box',
          style: TextStyle(
            fontSize: 12,
            color: widget.isDark
                ? const Color(0xFF64748B)
                : const Color(0xFF94A3B8),
          ),
        ),
      );
    }

    int colsL = (widget.roomLengthM / widget.tileLengthM).ceil();
    int colsW = (widget.roomWidthM / widget.tileLengthM).ceil();
    double verticalDim = widget.hasHeight
        ? (widget.roomHeightM > 0
            ? widget.roomHeightM
            : (widget.hasSkirting ? 0.3 : widget.roomWidthM))
        : widget.roomWidthM;
    int rows = (verticalDim / widget.tileWidthM).ceil();
    double tileAspect = widget.tileLengthM / widget.tileWidthM;

    double bW = isFullScreen ? 280.0 : 200.0;
    double bH = isFullScreen ? 220.0 : 160.0;
    double bD = isFullScreen ? 280.0 : 200.0;

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          final sState = setDialogState ?? setState;
          sState(() {
            if (pointerSignal.scrollDelta.dy > 0) {
              _scale = (_scale - 0.1).clamp(0.5, 3.0);
            } else {
              _scale = (_scale + 0.1).clamp(0.5, 3.0);
            }
          });
        }
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          final sState = setDialogState ?? setState;
          sState(() {
            _angleY -= details.delta.dx * 0.015;
            _angleX += details.delta.dy * 0.015;
            _angleX = _angleX.clamp(-1.2, 1.2);
          });
        },
        child: Container(
          height: isFullScreen ? double.infinity : 260,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isDark
                ? const Color(0xFF020617)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Zoom & Rotate Transform
              Transform.scale(
                scale: _scale,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_angleX)
                    ..rotateY(_angleY),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: bW,
                    height: bH,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Floor
                        Transform(
                          transform: Matrix4.translationValues(0.0, bH / 2, 0.0)
                            ..rotateX(pi / 2),
                          alignment: Alignment.center,
                          child: Container(
                            width: bW,
                            height: bD,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6)
                                  .withValues(alpha: 0.25),
                              border: Border.all(
                                  color: const Color(0xFF60A5FA), width: 1.5),
                            ),
                            child: _buildTileGridForFace(
                              cols: colsL,
                              rows: (widget.roomWidthM / widget.tileWidthM)
                                  .ceil(),
                              tileAspect: tileAspect,
                              isWall: false,
                            ),
                          ),
                        ),
                        // Back Wall
                        Transform(
                          transform:
                              Matrix4.translationValues(0.0, 0.0, -bD / 2),
                          alignment: Alignment.center,
                          child: Container(
                            width: bW,
                            height: bH,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669)
                                  .withValues(alpha: 0.25),
                              border: Border.all(
                                  color: const Color(0xFF10B981), width: 1.5),
                            ),
                            child: _buildTileGridForFace(
                              cols: colsL,
                              rows: rows,
                              tileAspect: tileAspect,
                              isWall: true,
                            ),
                          ),
                        ),
                        // Left Wall
                        Transform(
                          transform:
                              Matrix4.translationValues(-bW / 2, 0.0, 0.0)
                                ..rotateY(pi / 2),
                          alignment: Alignment.center,
                          child: Container(
                            width: bD,
                            height: bH,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488)
                                  .withValues(alpha: 0.25),
                              border: Border.all(
                                  color: const Color(0xFF2DD4BF), width: 1.5),
                            ),
                            child: _buildTileGridForFace(
                              cols: colsW,
                              rows: rows,
                              tileAspect: tileAspect,
                              isWall: true,
                            ),
                          ),
                        ),
                        // Right Wall
                        Transform(
                          transform: Matrix4.translationValues(bW / 2, 0.0, 0.0)
                            ..rotateY(-pi / 2),
                          alignment: Alignment.center,
                          child: Container(
                            width: bD,
                            height: bH,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.25),
                              border: Border.all(
                                  color: const Color(0xFFA78BFA), width: 1.5),
                            ),
                            child: _buildTileGridForFace(
                              cols: colsW,
                              rows: rows,
                              tileAspect: tileAspect,
                              isWall: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Controls Toolbar (Zoom & Reset)
              Positioned(
                bottom: 12,
                right: 12,
                child: Row(
                  children: [
                    _buildControlButton(Icons.remove_rounded, () {
                      final sState = setDialogState ?? setState;
                      sState(_zoomOut);
                    }),
                    const SizedBox(width: 6),
                    _buildControlButton(Icons.add_rounded, () {
                      final sState = setDialogState ?? setState;
                      sState(_zoomIn);
                    }),
                    const SizedBox(width: 6),
                    _buildControlButton(Icons.refresh_rounded, () {
                      final sState = setDialogState ?? setState;
                      sState(_resetView);
                    }),
                  ],
                ),
              ),
              // Drag hint & Zoom level indicator
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '💡 Drag to rotate | Zoom: ${(_scale * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool is3DView =
        widget.hasHeight || widget.hasSkirting || widget.roomHeightM > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
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
                    Icons.view_in_ar_rounded,
                    color: Color(0xFF16A34A),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    is3DView
                        ? 'Interactive 3D Room Box'
                        : '2D Grid Layout Preview',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      is3DView ? '3D Interactive' : '2D Mode',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _openFullscreen(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Icon(
                        Icons.fullscreen_rounded,
                        size: 16,
                        color: widget.isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3D Box Canvas with Zoom & Rotation
          _build3DRoomBoxContent(),

          const SizedBox(height: 12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.hasSkirting) ...[
                _buildLegendItem('S: Skirting', const Color(0xFFD97706)),
                const SizedBox(width: 10),
              ],
              if (widget.hasHeight) ...[
                _buildLegendItem('D: Dark', const Color(0xFF1E3A8A)),
                const SizedBox(width: 10),
                _buildLegendItem('M: Motive', const Color(0xFF0D9488)),
                const SizedBox(width: 10),
              ],
              _buildLegendItem('L: Light / Floor', const Color(0xFF059669)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {double size = 10}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w600,
            color:
                widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
