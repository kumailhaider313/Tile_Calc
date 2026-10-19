import 'package:flutter/material.dart';
import '../models/room_area_item.dart';
import '../models/exclusion_item.dart';
import 'common_input_field.dart';

class AreaInputSection extends StatelessWidget {
  final bool isDark;
  final List<RoomAreaItem> rooms;
  final int selectedRoomIndex;
  final ValueChanged<int> onRoomSelected;
  final VoidCallback onAddRoom;
  final ValueChanged<int> onDeleteRoom;
  final RoomAreaItem activeRoom;
  final VoidCallback onStateChanged;

  const AreaInputSection({
    super.key,
    required this.isDark,
    required this.rooms,
    required this.selectedRoomIndex,
    required this.onRoomSelected,
    required this.onAddRoom,
    required this.onDeleteRoom,
    required this.activeRoom,
    required this.onStateChanged,
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
              isActive: activeRoom.areaMode == 'dimensions',
              isDark: isDark,
              onTap: () {
                activeRoom.areaMode = 'dimensions';
                onStateChanged();
              },
            ),
            buildTabButton(
              title: 'Direct Area',
              isActive: activeRoom.areaMode == 'direct',
              isDark: isDark,
              onTap: () {
                activeRoom.areaMode = 'direct';
                onStateChanged();
              },
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room / Area Tabs Row with Add (+) Button
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Add Room Button (+)
                InkWell(
                  onTap: onAddRoom,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF064E3B)
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
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
                          size: 16,
                          color: isDark
                              ? const Color(0xFF34D399)
                              : const Color(0xFF15803D),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add Area (+)',
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
                // List of Room Tabs
                ...List.generate(rooms.length, (index) {
                  final room = rooms[index];
                  final isSelected = index == selectedRoomIndex;
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onRoomSelected(index),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF16A34A)
                                : (isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF16A34A)
                                  : (isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFCBD5E1)),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                room.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF475569)),
                                ),
                              ),
                              if (rooms.length > 1) ...[
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () => onDeleteRoom(index),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: isSelected
                                        ? Colors.white70
                                        : (isDark
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF64748B)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 14),
          Divider(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14),

          // Active Room Inputs
          activeRoom.areaMode == 'dimensions'
              ? Row(
                  children: [
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: '${activeRoom.name} Length',
                        controller: activeRoom.lengthController,
                        unitValue: activeRoom.unitLength,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: (val) {
                          if (val != null) {
                            activeRoom.unitLength = val;
                            activeRoom.unitWidth = val;
                            onStateChanged();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: '${activeRoom.name} Width',
                        controller: activeRoom.widthController,
                        unitValue: activeRoom.unitWidth,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: (val) {
                          if (val != null) {
                            activeRoom.unitWidth = val;
                            activeRoom.unitLength = val;
                            onStateChanged();
                          }
                        },
                      ),
                    ),
                  ],
                )
              : buildInputFieldWithUnit(
                  isDark: isDark,
                  label: '${activeRoom.name} Total Surface Area',
                  controller: activeRoom.directAreaController,
                  unitValue: activeRoom.unitDirectArea,
                  unitOptions: const ['m²', 'cm²', 'sq ft', 'sq in'],
                  onUnitChanged: (val) {
                    if (val != null) {
                      activeRoom.unitDirectArea = val;
                      onStateChanged();
                    }
                  },
                ),

          // Tile Skirting (Only shown in Floor tab)
          if (activeRoom.name.toLowerCase() == 'floor') ...[
            const SizedBox(height: 12),
            Divider(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.border_bottom_rounded,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  'Floor Tile Skirting',
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
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Skirting Height:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 12),
                ...[0, 4, 6].map((h) {
                  final isSelected = activeRoom.skirtingHeightInches == h;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        activeRoom.skirtingHeightInches = h;
                        onStateChanged();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? const Color(0xFF064E3B)
                                  : const Color(0xFFDCFCE7))
                              : (isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF16A34A)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          '$h inch',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
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
                  );
                }),
              ],
            ),
            if (activeRoom.skirtingHeightInches > 0) ...[
              const SizedBox(height: 10),
              buildInputFieldWithUnit(
                isDark: isDark,
                label: 'Skirting Cutout (Doors / Openings)',
                controller: activeRoom.skirtingCutoutController,
                unitValue: activeRoom.skirtingCutoutUnit,
                unitOptions: const ['ft', 'm', 'cm', 'in'],
                onUnitChanged: (val) {
                  if (val != null) {
                    activeRoom.skirtingCutoutUnit = val;
                    onStateChanged();
                  }
                },
              ),
            ],
          ],

          const SizedBox(height: 12),
          Divider(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 12),

          // Deductions / Exclusions Header
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 450;
              return isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Expanded(
                              child: Text(
                                '${activeRoom.name} Cutouts (Doors, Windows)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              final wC = TextEditingController(text: '0.0');
                              final hC = TextEditingController(text: '0.0');
                              wC.addListener(onStateChanged);
                              hC.addListener(onStateChanged);
                              activeRoom.exclusions.add(
                                ExclusionItem(
                                  id: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  widthController: wC,
                                  heightController: hC,
                                  unitWidth: activeRoom.unitWidth,
                                  unitHeight: activeRoom.unitWidth,
                                ),
                              );
                              onStateChanged();
                            },
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
                        ),
                      ],
                    )
                  : Row(
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
                              '${activeRoom.name} Cutouts (Doors, Windows)',
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
                          onTap: () {
                            final wC = TextEditingController(text: '0.0');
                            final hC = TextEditingController(text: '0.0');
                            wC.addListener(onStateChanged);
                            hC.addListener(onStateChanged);
                            activeRoom.exclusions.add(
                              ExclusionItem(
                                id: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                widthController: wC,
                                heightController: hC,
                                unitWidth: activeRoom.unitWidth,
                                unitHeight: activeRoom.unitWidth,
                              ),
                            );
                            onStateChanged();
                          },
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
                    );
            },
          ),

          const SizedBox(height: 12),

          // Exclusions List for Active Room
          Column(
            children: List.generate(activeRoom.exclusions.length, (index) {
              final item = activeRoom.exclusions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: activeRoom.exclusions.length > 1
                            ? 'Cutout #${index + 1} Width'
                            : 'Exclusion Width',
                        controller: item.widthController,
                        unitValue: item.unitWidth,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: (val) {
                          if (val != null) {
                            item.unitWidth = val;
                            item.unitHeight = val;
                            onStateChanged();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildInputFieldWithUnit(
                        isDark: isDark,
                        label: activeRoom.exclusions.length > 1
                            ? 'Cutout #${index + 1} Height'
                            : 'Exclusion Height',
                        controller: item.heightController,
                        unitValue: item.unitHeight,
                        unitOptions: const ['m', 'cm', 'ft', 'in'],
                        onUnitChanged: (val) {
                          if (val != null) {
                            item.unitHeight = val;
                            item.unitWidth = val;
                            onStateChanged();
                          }
                        },
                      ),
                    ),
                    if (activeRoom.exclusions.length > 1 ||
                        item.width > 0 ||
                        item.height > 0) ...[
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: IconButton(
                          onPressed: () {
                            setStateSafely() {
                              final rem = activeRoom.exclusions.removeAt(index);
                              rem.dispose();
                              onStateChanged();
                            }

                            setStateSafely();
                          },
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

          // Total Calculated Area Box (Summing all rooms or active room net area)
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
                        'TOTAL PROJECT NET AREA (${rooms.length > 1 ? '${rooms.length} Areas' : activeRoom.name})',
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
                            activeRoom.netArea.toStringAsFixed(2),
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
                              activeRoom.areaMode == 'dimensions'
                                  ? '(${activeRoom.lengthM.toStringAsFixed(2)}m × ${activeRoom.widthM.toStringAsFixed(2)}m)'
                                  : '(Direct Area)',
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
