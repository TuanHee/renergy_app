import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/routes/app_routes.dart';

class ExplorerScreenView extends StatelessWidget {
  const ExplorerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map background and header
          Column(
            children: [
              // Header bar
              Container(
                height: 110,
                color: const Color(0xFFD32F2F),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Logo placeholder
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'R',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'RECHARGE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_none, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Map area
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: const Color(0xFFE9EEF4),
                      child: const Center(
                        child: Text(
                          'Map Placeholder',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    // Map floating controls (right side)
                    Positioned(
                      right: 12,
                      top: 20,
                      child: Column(
                        children: [
                          _circleIconButton(Icons.refresh),
                          const SizedBox(height: 12),
                          _circleIconButton(Icons.settings),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Draggable bottom sheet
          _BottomSheetPanel(),
        ],
      ),
      // Bottom navigation bar
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: 0,
      ),
    );
  }
}

class _BottomSheetPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.70,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    children: const [
                      TextSpan(text: 'Welcome to '),
                      TextSpan(
                        text: 'Renergy',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Charge anytime, anywhere',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // Search bar with filter icon
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Search',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.tune, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Station list
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    itemCount: 5,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      return _StationItem(index: index);
                    },
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

class _StationItem extends StatelessWidget {
  final int index;
  
  const _StationItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade600;

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.chargingStation);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 90,
                height: 70,
                color: const Color(0xFFE6F0FF),
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Colors.blue),
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _chip(label: 'Public', color: const Color(0xFF0BB07B)),
                      const SizedBox(width: 8),
                      _chip(label: 'Showroom', color: Colors.black87, dark: true),
                      const Spacer(),
                      const Icon(Icons.star_border, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crest Austin Sales Gallery',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inside Crest@Austin Sales Gallery Car Park',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.route, size: 16, color: muted),
                      const SizedBox(width: 4),
                      Text('3.9 km', style: TextStyle(color: muted)),
                      const SizedBox(width: 12),
                      Icon(Icons.ev_station, size: 16, color: muted),
                      const SizedBox(width: 4),
                      Text('2', style: TextStyle(color: muted)),
                      const SizedBox(width: 12),
                      Text('Available', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      const Icon(Icons.bolt, size: 16, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.green),
                      const SizedBox(width: 6),
                      Text('Open', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('12:00am - 11:59pm', style: TextStyle(color: muted)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _chip({required String label, required Color color, bool dark = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: dark ? Colors.black : color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: dark ? Colors.black : color.withOpacity(0.2)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: dark ? Colors.white : color,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _circleIconButton(IconData icon) {
  return Container(
    width: 44,
    height: 44,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
      ],
    ),
    child: IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black87),
    ),
  );
}
