import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class FilterScreenView extends StatelessWidget {
  const FilterScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
      builder: (controller) {
        final red = const Color(0xFFE60012);
        final muted = Colors.grey.shade600;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Filter'),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Access Level',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _segButton(
                        'public',
                        controller.accessLevel == 'public',
                        onTap: () => controller.setAccessLevel('public'),
                      ),
                      const SizedBox(width: 12),
                      _segButton(
                        'restricted',
                        controller.accessLevel == 'restricted',
                        onTap: () => controller.setAccessLevel('restricted'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Power Supply',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _segButton(
                        'all',
                        controller.powerSupply == 'all',
                        label: 'All',
                        onTap: () => controller.setPowerSupply('all'),
                      ),
                      const SizedBox(width: 12),
                      _segButton(
                        'ac',
                        controller.powerSupply == 'ac',
                        label: 'AC',
                        onTap: () => controller.setPowerSupply('ac'),
                      ),
                      const SizedBox(width: 12),
                      _segButton(
                        'dc',
                        controller.powerSupply == 'dc',
                        label: 'DC',
                        onTap: () => controller.setPowerSupply('dc'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'kW',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${controller.minKw.toInt()} kW',
                        style: TextStyle(color: muted, fontSize: 14),
                      ),
                      Text(
                        '${controller.maxKw.toInt()} kW',
                        style: TextStyle(color: muted, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      // Colors
                      activeTrackColor: red,
                      inactiveTrackColor: Colors.red.shade100,
                      trackHeight: 8,
                      rangeThumbShape: const RoundRangeSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      thumbColor: Colors.white,

                      overlayShape: SliderComponentShape.noOverlay,
                      rangeValueIndicatorShape:
                          const PaddleRangeSliderValueIndicatorShape(),
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: RangeSlider(
                      values: RangeValues(controller.minKw, controller.maxKw),
                      min: 22,
                      max: 180,
                      onChanged: (v) => controller.setKwRange(v.start, v.end),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Specific Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: controller.locationTags.map((tag) {
                      final selected = controller.selectedTags.contains(tag);
                      return OutlinedButton(
                        onPressed: () => controller.toggleTag(tag),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: selected ? red : Colors.grey.shade300,
                          ),
                          backgroundColor: selected
                              ? Colors.red.shade50
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: selected ? red : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: controller.filteredStations),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Show ${controller.matchedCount} Locations'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _segButton(
  String key,
  bool selected, {
  String? label,
  required VoidCallback onTap,
}) {
  final text = label ?? key[0].toUpperCase() + key.substring(1);
  return Expanded(
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(
          color: selected ? const Color(0xFFE60012) : Colors.grey.shade300,
        ),
        backgroundColor: selected ? Colors.red.shade50 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (key == 'public')
            const Icon(Icons.public, size: 18, color: Color(0xFFE60012))
          else if (key == 'restricted')
            const Icon(Icons.shield, size: 18, color: Color(0xFFE60012))
          else
            const SizedBox.shrink(),
          if (key == 'public' || key == 'restricted')
            const SizedBox(width: 6)
          else
            const SizedBox.shrink(),
          Text(
            text,
            style: TextStyle(
              color: selected ? const Color(0xFFE60012) : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
