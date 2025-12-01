import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/float_bar.dart';
import 'package:renergy_app/global.dart';
import 'package:renergy_app/main.dart';
import 'package:renergy_app/screens/explorer_screen/explorer_screen.dart';

class ExplorerScreenView extends StatefulWidget {
  const ExplorerScreenView({super.key});

  @override
  State<ExplorerScreenView> createState() => _ExplorerScreenViewState();
}

class _ExplorerScreenViewState extends State<ExplorerScreenView> {
  GoogleMapController? mapController;
  late final CameraPosition _initialCameraPosition;
  GoogleMap? _map;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    Get.find<ExplorerController>().mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    final mapsImpl = GoogleMapsFlutterPlatform.instance;
    if (mapsImpl is GoogleMapsFlutterAndroid) {
      mapsImpl.useAndroidViewSurface = true;
    }
    _initialCameraPosition = CameraPosition(
      target: LatLng(
        Get.find<MainController>().position?.latitude ?? 0,
      Get.find<MainController>().position?.longitude ?? 0,
      ),
      zoom: 12.0,
    );
    _map = GoogleMap(
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      initialCameraPosition: _initialCameraPosition,
      mapToolbarEnabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              if (Global.isLoginValid)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          body: Stack(
            children: [
              // Map background and header
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    GetBuilder<ExplorerController>(
                      builder: (controller) {
                        final pos = Get.find<MainController>().position;
                        final self = pos == null ? null : LatLng(pos.latitude, pos.longitude);
                        return Positioned.fill(
                          child: GoogleMap(
                            initialCameraPosition: _initialCameraPosition,
                            onMapCreated: _onMapCreated,
                            mapType: MapType.normal,
                            mapToolbarEnabled: true,
                            markers: controller.buildMarkers(self),
                          ),
                        );
                      },
                    ),
                   
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
              // Draggable bottom sheet
              GetBuilder<ExplorerController>(
                builder: (controller) => _BottomSheetPanel(controller: controller),
              ),
            ],
          ),
          // Bottom navigation bar
          bottomNavigationBar: MainBottomNavBar(currentIndex: 0),
        );
  
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
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
  static const double _expandedSize = 0.80;

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
            snap: true,
            snapSizes: const [_collapsedSize, _expandedSize],
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
                  child: RefreshIndicator(
                    onRefresh: () => widget.controller.fetchStations(
                      onErrorCallback: (msg) {
                        Snackbar.showError(msg, context);
                      },
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _FixedHeaderDelegate(
                            minHeight: 150,
                            maxHeight: 150,
                            builder: (context) {
                              return Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        _toggleSheet();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 6,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _currentSize <=
                                                    (_collapsedSize +
                                                            _expandedSize) /
                                                        2
                                                ? Icons
                                                      .keyboard_arrow_up_rounded
                                                : Icons
                                                      .keyboard_arrow_down_rounded,
                                            color: Colors.red.shade700,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
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
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 44,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.grey.shade600,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: TextField(
                                                    controller: widget
                                                        .controller
                                                        .searchController,
                                                    onChanged: (value) {
                                                      widget.controller
                                                          .update();
                                                    },
                                                    style: theme
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.black87,
                                                        ),
                                                    decoration: InputDecoration(
                                                      hintText: 'Search',
                                                      hintStyle: theme
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: Colors
                                                                .grey
                                                                .shade600,
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
                                            final filteredStations =
                                                await Get.toNamed(
                                                  AppRoutes.filter,
                                                );
                                            if (filteredStations != null) {
                                              widget.controller.filteredList =
                                                  filteredStations
                                                      as List<Station>;
                                              widget
                                                      .controller
                                                      .searchController
                                                      .text =
                                                  '';
                                              widget.controller.update();
                                            }
                                          },
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.tune,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if (widget.controller.isLoading)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (widget.controller.filteredStations.isEmpty)
                          SliverToBoxAdapter(
                            child: Column(
                              children: const [
                                SizedBox(height: 60),
                                Center(
                                  child: Text(
                                    'No charging stations found',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 220,
                              child: PageView.builder(
                                itemCount: widget.controller.filteredStations.length,
                                controller: PageController(viewportFraction: 0.9),
                                onPageChanged: (index) {
                                  final station = widget.controller.filteredStations[index];
                                  widget.controller.setSelectedStation(station);
                                },
                                itemBuilder: (context, index) {
                                  final station = widget.controller.filteredStations[index];
                                  return _StationCarouselCard(
                                    station: station,
                                    controller: widget.controller,
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        GetBuilder<ExplorerController>(
          builder: (controller) {
            return controller.status == null
                ? SizedBox.shrink()
                : Positioned(
                    right: 0,
                    top: 0,
                    child: FloatBar(
                      title: OrderStatus.title(controller.status),
                      subtitle: OrderStatus.subtitle(controller.status),
                      onClick: () => {Get.toNamed(AppRoutes.charging)},
                    ),
                  );
          },
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
                final bookmarkIndex = controller.bookmarks.indexWhere(
                  (bookmark) => bookmark.stationId == station.id,
                );
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
                                if (bookmarkIndex >= 0) {
                                  final bookmarkId =
                                      controller.bookmarks[bookmarkIndex].id;
                                  await controller.removeBookmark(bookmarkId);
                                } else {
                                  await controller.storeBookmark(station);
                                }
                              } catch (e) {
                                Snackbar.showError(e.toString(), context);
                              }
                            },
                            child: Icon(
                              bookmarkIndex >= 0
                                  ? Icons.star
                                  : Icons.star_border,
                              color: bookmarkIndex >= 0
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
                      if (station.description != null &&
                          station.description!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          station.description!,
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.route, size: 14, color: muted),
                          const SizedBox(width: 4),
                          Text(
                            '3.9 km',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
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

class _StationCarouselCard extends StatelessWidget {
  final Station station;
  final ExplorerController controller;
  const _StationCarouselCard({required this.station, required this.controller});

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade600;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://picsum.photos/500/300',
              width: 96,
              height: 84,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MyBadge(
                      label: '${(station.type ?? 'Public')[0].toUpperCase()}${(station.type ?? 'Public').substring(1)}',
                      color: const Color(0xFF0BB07B),
                    ),
                    const SizedBox(width: 8),
                    MyBadge(
                      label: 'Showroom',
                      color: Colors.black87,
                      dark: true,
                    ),
                    const Spacer(),
                    Icon(Icons.star_border, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  station.name ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.route, size: 14, color: muted),
                    const SizedBox(width: 4),
                    Text('3.8 km', style: TextStyle(color: muted, fontSize: 12)),
                    const SizedBox(width: 8),
                    Icon(Icons.ev_station, size: 14, color: muted),
                    const SizedBox(width: 4),
                    Text((station.bays?.length ?? 0).toString(), style: TextStyle(color: muted, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text(
                      station.isActive ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: station.isActive ? Colors.green.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.openExternalNavigation(station);
                        },
                        child: const Text('Navigate'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.chargingStation, arguments: station.id);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                        child: const Text('Charge'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

class _FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget Function(BuildContext) builder;

  _FixedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context);
  }

  @override
  bool shouldRebuild(covariant _FixedHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        builder != oldDelegate.builder;
  }
}
