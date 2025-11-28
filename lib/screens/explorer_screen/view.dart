import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/float_bar.dart';
import 'package:renergy_app/screens/explorer_screen/explorer_screen.dart';

class ExplorerScreenView extends StatelessWidget {
  const ExplorerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExplorerController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'RECHARGE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.white),
              ),
            ],
          ),
          body: Stack(
            children: [
              // Map background and header
              Column(
                children: [
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
                              _circleIconButton(Icons.gps_fixed),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Draggable bottom sheet
              _BottomSheetPanel(controller: controller),
            ],
          ),
          // Bottom navigation bar
          bottomNavigationBar: MainBottomNavBar(currentIndex: 0),
        );
      },
    );
  }
}

class _BottomSheetPanel extends StatefulWidget {
  final ExplorerController controller;

  const _BottomSheetPanel({required this.controller});

  @override
  State<_BottomSheetPanel> createState() => _BottomSheetPanelState();
}

class _BottomSheetPanelState extends State<_BottomSheetPanel> {
  static const double _collapsedSize = 0.35;
  static const double _expandedSize = 0.99;

  late final DraggableScrollableController _sheetController;
  double _currentSize = _collapsedSize;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(_handleSheetSizeChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = widget.controller;
      await Future.wait([
          controller.fetchBookmark(
            onErrorCallback: (msg) {
              if (mounted) Snackbar.showError(msg, context);
            },
          ),
          controller.pollChargingOrder(
            onErrorCallback: (msg) {
              if (mounted) Snackbar.showError(msg, context);
            },
          ),
          controller.fetchStations(
            onErrorCallback: (msg) {
              if (mounted) Snackbar.showError(msg, context);
            },
          ),
        ]);
    });
  }

  @override
  void dispose() {
    _sheetController.removeListener(_handleSheetSizeChanged);
    _sheetController.dispose();
    widget.controller.stopPollingChargingOrder();
    super.dispose();
  }

  void _handleSheetSizeChanged() {
    final sheetSize = _sheetController.size;
    if ((sheetSize - _currentSize).abs() > 0.001) {
      setState(() {
        _currentSize = sheetSize;
      });
    }
  }

  Future<void> _toggleSheet() async {
    final targetSize = _currentSize < (_collapsedSize + _expandedSize) / 2
        ? _expandedSize
        : _collapsedSize;
    await _sheetController.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _collapsedSize,
            minChildSize: _collapsedSize,
            maxChildSize: _expandedSize,
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
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          _toggleSheet();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 6),
                          child: Center(
                            child: Icon(
                              _currentSize <=
                                      (_collapsedSize + _expandedSize) / 2
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: Colors.red.shade700,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20
                          ),
                          children: const [
                            TextSpan(text: 'Welcome to '),
                            TextSpan(
                              text: 'Renergy',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Charge anytime, anywhere',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
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
                                    child: TextField(
                                      controller: widget.controller.searchController,
                                      onChanged: (value) {
                                        widget.controller.update();
                                      },
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () async {
                              final filteredStations = await Get.toNamed(AppRoutes.filter);
                              if(filteredStations != null){
                                widget.controller.filteredList = filteredStations as List<Station>;
                                widget.controller.searchController.text = '';
                                widget.controller.update();
                              }
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Station list
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => widget.controller.fetchStations(onErrorCallback: (msg){
                            Snackbar.showError(msg, context);
                          },),
                          child: widget.controller.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : widget.controller.filteredStations.isEmpty
                              ? ListView(
                                  padding: EdgeInsets.zero,
                                  controller: scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    SizedBox(height: 60),
                                    Center(
                                      child: Text(
                                        'No charging stations found',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.zero,
                                  controller: scrollController,
                                  itemCount: widget.controller.filteredStations.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  itemBuilder: (context, index) {
                                    return _StationItem(
                                      station: widget.controller.filteredStations[index],
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        GetBuilder<ExplorerController>(
          builder: (controller) {
            return controller.status == null ? SizedBox.shrink():
            Positioned(
              right: 0,
              top: 0,
              child: FloatBar(
                title: ChargingStatsStatus.title(controller.status),
                subtitle: ChargingStatsStatus.subtitle(controller.status),
                onClick: () => {Get.toNamed(AppRoutes.charging)},
              ),
            );
          }
        ),
      ],
    );
  }
}

class _StationItem extends StatelessWidget {
  final Station station;
  const _StationItem({required this.station});

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade600;

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.chargingStation, arguments: station.id);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://picsum.photos/500/300',
              width: 72,
              height: 54,
              fit: BoxFit.cover,
            ),
            
            const SizedBox(width: 8),

            // Details
            GetBuilder<ExplorerController>(
              builder: (controller) {
                final bookmarkIndex = controller.bookmarks.indexWhere((bookmark) => bookmark.stationId == station.id);
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          MyBadge(
                            label:
                                '${station.type![0].toUpperCase()}${station.type!.substring(1)}',
                            color: const Color(0xFF0BB07B),
                          ),
                          const SizedBox(width: 8),
                          MyBadge(
                            label: 'Showroom',
                            color: Colors.black87,
                            dark: true,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () async {
                              try {
                                if (bookmarkIndex >=0) {
                                  final bookmarkId = controller.bookmarks[bookmarkIndex].id;
                                  await controller.removeBookmark(bookmarkId);
                                } else {
                                  await controller.storeBookmark(station);
                                }
                              } catch (e) {
                                Snackbar.showError(e.toString(), context);
                              }
                            },
                            child: Icon(
                              bookmarkIndex >=0 ? Icons.star : Icons.star_border,
                              color: bookmarkIndex >=0
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        station.name ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        station.shortDescription ?? '',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.route, size: 14, color: muted),
                          const SizedBox(width: 4),
                          Text('3.9 km', style: TextStyle(color: muted, fontSize: 12)),
                          const SizedBox(width: 8),
                          Icon(Icons.ev_station, size: 14, color: muted),
                          const SizedBox(width: 4),
                          Text(
                            station.bays!.length.toString(),
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            station.isActive ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.bolt, size: 14, color: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
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
