import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/bay.dart';
import 'package:renergy_app/common/models/credit_card.dart';
import 'package:renergy_app/common/models/idle_times.dart';
import 'package:renergy_app/common/models/operation_times.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/main.dart';
import 'package:renergy_app/screens/station_screen/station_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class StationScreenView extends StatefulWidget {
  const StationScreenView({super.key});

  @override
  State<StationScreenView> createState() => _StationScreenViewState();
}

class _StationScreenViewState extends State<StationScreenView> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;
  // PageView controller and index for image carousel dots
  final PageController _imagePageController = PageController(
    viewportFraction: 1.0,
  );
  int _imagePageIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final imageHeight = 250.0;

    // Gradually increase opacity as user scrolls past the image
    final newOpacity = (scrollOffset / imageHeight).clamp(0.0, 1.0);
    if (_opacity != newOpacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StationController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Color(0xFFD32F2F).withValues(alpha: _opacity),
            elevation: _opacity > 0 ? 4 : 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Colors.white),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Charging station image
                SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      (controller.station.imageUrls == null ||
                              controller.station.imageUrls!.isEmpty)
                          ? Image.network(
                              controller.station.mainImageUrl ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: double.infinity,
                                    height: 250,
                                    color: Colors.grey[300],
                                  ),
                            )
                          : PageView.builder(
                              itemCount: controller.station.imageUrls!.length,
                              controller: _imagePageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _imagePageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final img =
                                    controller.station.imageUrls![index];
                                return Image.network(
                                  img,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                      if ((controller.station.imageUrls?.length ?? 0) > 1)
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              controller.station.imageUrls!.length,
                              (i) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i == _imagePageIndex
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Status bar overlay at bottom of image
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusItem(Icons.check_circle, 'Open', Colors.green),
                      _statusItem(
                        Icons.location_on,
                        '${controller.station.distanceTo(position: Get.find<MainController>().position!)?.toStringAsFixed(2) ?? 'N/A'} km',
                        Colors.black,
                      ),
                      _statusItemImage(
                        'assets/images/plug.png',
                        '${controller.station.bays!.length}',
                        Colors.black,
                      ),
                      _statusItem(
                        controller.station.isActive &&
                                controller.station.bays?.any(
                                      (bay) => bay.isAvailable == true,
                                    ) ==
                                    true
                            ? Icons.check_circle
                            : Icons.cancel,
                        controller.station.isActive &&
                                controller.station.bays?.any(
                                      (bay) => bay.isAvailable == true,
                                    ) ==
                                    true
                            ? 'Available'
                            : 'Unavailable',
                        controller.station.isActive &&
                                controller.station.bays?.any(
                                      (bay) => bay.isAvailable == true,
                                    ) ==
                                    true
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ),

                // Station information
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tags
                      Row(
                        children: [
                          MyBadge(
                            label:
                                '${controller.station.type![0].toUpperCase()}${controller.station.type!.substring(1)}',
                            color: const Color(0xFF0BB07B),
                          ),
                          const SizedBox(width: 8),
                          MyBadge(label: 'Showroom', color: Colors.black87),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        key: controller.stationNameKey,
                        controller.station.name!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Address
                      Text(
                        '${controller.station.address1!} ${controller.station.address2!}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Charging Bay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Refresh bays list
                          controller.isRefreshing
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    iconSize: 20,
                                    onPressed: () async {
                                      await controller.initStation();
                                      controller.update();
                                    },
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      for (Bay bay in controller.station.bays!) ...[
                        _chargingBayCard(controller, bay),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 16),

                      // Promo Code Section
                      const Text(
                        'Do You Have Any Promo Code?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Promo Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Select My Car Section
                      const Text(
                        'Select My Car',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: controller.selectedCar,
                        decoration: InputDecoration(
                          hintText: 'No car selected',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        items: controller.vehicles.map((car) {
                          return DropdownMenuItem<int>(
                            value: car.id,
                            child: Text(car.plate),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectCar(value);
                          }
                        },
                      ),

                      if (controller.vehicles.isEmpty)
                        Row(
                          children: [
                            Text(
                              'No car available',
                              style: TextStyle(color: Colors.red),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Get.toNamed(AppRoutes.car);
                                controller.initCar();
                              },
                              child: const Text(
                                'Add car here',
                                style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 24),

                      // Pricing Section
                      const Text(
                        'Pricing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check out our Renergy\'s pricing details below.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => Get.toNamed(AppRoutes.priceList),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View Price List'),
                      ),
                      const SizedBox(height: 24),

                      // Schedule Idle Section
                      const Text(
                        'Schedule Idle',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Idle fee will be charged during these hours.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      _scheduleIdle(controller.station.idleTimes),
                      const SizedBox(height: 24),

                      // Operation Info Section
                      const Text(
                        'Operation Info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _infoItem(Icons.phone, 'Hotline'),
                      const SizedBox(height: 12),
                      _infoItem(Icons.schedule, 'Business Hour'),
                      _scheduleOperation(controller.station.operationTimes),
                      const SizedBox(height: 24),

                      // Report Station
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.report,
                            arguments: controller.station,
                          );
                        },
                        icon: const Icon(Icons.flag),
                        label: const Text('Report this station'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.red.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Nearby Station Section
                      controller.nearbyStations.isNotEmpty?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nearby Station',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  controller.nearbyStations.length,
                                  (index) => SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: _nearbyStationItem(
                                      station: controller.nearbyStations[index],
                                      stations: controller.stations,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      :
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Nearby Station',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Icon(
                              Icons.location_off,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            const Text('No nearby station'),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Find more charging station on map',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  controller.selectedCard == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add card to proceed with payment.',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.card);
                              },
                              child: const Text('+ Add Card'),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pay with Card ',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 13,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '**** **** **** ${controller.selectedCard?.last4 ?? 'Unknown'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  AppRoutes.card,
                                  arguments: {'isSelectingCard': true},
                                );
                                if (result != null && result is CreditCard) {
                                  controller.selectedCard = result;
                                  controller.update();
                                }
                              },
                              child: const Text('Change'),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (ctx) {
                                return SafeArea(
                                  top: false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Open with',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.map,
                                            color: Colors.redAccent,
                                          ),
                                          title: const Text('Google Maps'),
                                          onTap: () async {
                                            Navigator.of(ctx).pop();
                                            final lat = double.tryParse(
                                              controller.station.latitude ?? '',
                                            );
                                            final lon = double.tryParse(
                                              controller.station.longitude ??
                                                  '',
                                            );
                                            if (lat == null || lon == null)
                                              return;
                                            final url = Uri.parse(
                                              'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon',
                                            );
                                            await launchUrl(
                                              url,
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.navigation,
                                            color: Colors.blueAccent,
                                          ),
                                          title: const Text('Waze'),
                                          onTap: () async {
                                            Navigator.of(ctx).pop();
                                            final lat = double.tryParse(
                                              controller.station.latitude ?? '',
                                            );
                                            final lon = double.tryParse(
                                              controller.station.longitude ??
                                                  '',
                                            );
                                            if (lat == null || lon == null)
                                              return;
                                            final url = Uri.parse(
                                              'https://waze.com/ul?ll=$lat,$lon&navigate=yes',
                                            );
                                            await launchUrl(
                                              url,
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.navigation),
                          label: const Text('Navigate'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.unlockBay,
                          icon: const Icon(Icons.lock_open),
                          label: const Text('Unlock Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade500,
                            disabledForegroundColor: Colors.grey.shade200,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  Widget _statusItemImage(String assetPath, String label, Color color) {
    return Row(
      children: [
        Image.asset(assetPath, width: 16, height: 16),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  Widget _chargingBayCard(StationController controller, Bay bay) {
    final isSelected = controller.selectedBay == bay.id!;

    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => bay.status == BayStatus.available
          ? controller.selectBay(bay.id!)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      bay.name ?? '-',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${bay.port?.outputPower ?? '-'}kW ${bay.port?.currentType ?? '-'}',
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: bay.status == BayStatus.available
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  // bay.status?.value.toUpperCase() ?? '',
                  bay.status == BayStatus.reserved
                      ? 'OCCUPIED'
                      : bay.status?.value.toUpperCase() ?? '',
                  style: TextStyle(
                    color: bay.status == BayStatus.available
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scheduleIdle(List<IdleTimes>? idleTimes) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: days.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final idleTime = idleTimes?.firstWhere(
            (element) => element.getDay() - 1 == index,
            orElse: () => IdleTimes(),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  days[index],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  idleTime!.idleStart != null && idleTime.idleEnd != null
                      ? '${idleTime.idleStart ?? 'N/A'} - ${idleTime.idleEnd ?? 'N/A'}'
                      : '-',
                  style: TextStyle(
                    color: idleTime.getDay() == DateTime.now().weekday
                        ? Colors.black
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _scheduleOperation(List<OperationTimes>? operationTimes) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: days.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final operationTime = operationTimes?.firstWhere(
            (element) => element.getDay() - 1 == index,
            orElse: () => OperationTimes(),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  days[index],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  operationTime!.operationStart != null &&
                          operationTime.operationEnd != null
                      ? '${operationTime.operationStart ?? 'N/A'} - ${operationTime.operationEnd ?? 'N/A'}'
                      : '-',
                  style: TextStyle(
                    color: operationTime.getDay() == DateTime.now().weekday
                        ? Colors.black
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _nearbyStationItem extends StatelessWidget {
  final Station station;
  final List<Station> stations;
  const _nearbyStationItem({required this.station, required this.stations});

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade600;
    final operationTime = station.operationTimes != null && station.operationTimes!.isNotEmpty ? station.operationTimes!.firstWhere((ot) => ot.getDay() == DateTime.now().weekday ) : null;

    return InkWell(
      onTap: () async{
        Get.back();
        await Future.delayed(const Duration(milliseconds: 400));
        Get.toNamed(AppRoutes.chargingStation, arguments: {'stationId': station.id, 'stations': stations});
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.only(bottom: 14, top: 6),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  station.mainImageUrl ?? '',
                  width: 108,
                  height: 81,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 108,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: Image.asset(
                      'assets/images/image_placeholder.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Details
                Expanded(
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
                          const SizedBox(width: 6),
                          if (station.category != null)
                            MyBadge(
                              label: station.category!,
                              color: Colors.black87,
                              dark: true,
                            ),
                          const Spacer(),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 12.0, 12.0, 0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        // Distance
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                '${station.distanceTo(position: Get.find<MainController>().position!)?.toStringAsFixed(2) ?? 'N/A'} km',
                                style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        // Bays count
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/plug.png',
                                width: 13,
                                height: 13,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${station.bays?.where((bay) => bay.isAvailable == true).length ?? 0}',
                                style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        // Availability
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                station.isActive && station.bays?.any((bay) => bay.isAvailable == true) == true  ? Icons.check_circle : Icons.cancel,
                                size: 14,
                                color: station.isActive && station.bays?.any((bay) => bay.isAvailable == true) == true  ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                station.isActive && station.bays?.any((bay) => bay.isAvailable == true) == true ? 'Available' : 'Unavailable',
                                style: TextStyle(
                                  color: station.isActive && station.bays?.any((bay) => bay.isAvailable == true) == true  ? Colors.green.shade700 : Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Schedule (simplified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.schedule, size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                '${operationTime?.operationStatus} | ${operationTime?.operationStart ?? 'N/A'}–${operationTime?.operationEnd ?? 'N/A'}',
                                style: TextStyle(
                                  color: (DateTime.now().weekday == DateTime.monday && DateTime.now().hour < 9)
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: OutlinedButton(
            //         onPressed: () async {
            //           await showModalBottomSheet(
            //             context: context,
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.vertical(
            //                 top: Radius.circular(16),
            //               ),
            //             ),
            //             builder: (ctx) {
            //               return SafeArea(
            //                 top: false,
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                     horizontal: 16,
            //                     vertical: 12,
            //                   ),
            //                   child: Column(
            //                     mainAxisSize: MainAxisSize.min,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       const Text(
            //                         'Open with',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       const SizedBox(height: 8),
            //                       ListTile(
            //                         leading: const Icon(
            //                           Icons.map,
            //                           color: Colors.redAccent,
            //                         ),
            //                         title: const Text('Google Maps'),
            //                         onTap: () async {
            //                           Navigator.of(ctx).pop();
            //                           final lat = double.tryParse(
            //                             station.latitude ?? '',
            //                           );
            //                           final lon = double.tryParse(
            //                             station.longitude ?? '',
            //                           );
            //                           if (lat == null || lon == null) return;
            //                           final url = Uri.parse(
            //                             'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon',
            //                           );
            //                           await launchUrl(
            //                             url,
            //                             mode: LaunchMode.externalApplication,
            //                           );
            //                         },
            //                       ),
            //                       ListTile(
            //                         leading: const Icon(
            //                           Icons.navigation,
            //                           color: Colors.blueAccent,
            //                         ),
            //                         title: const Text('Waze'),
            //                         onTap: () async {
            //                           Navigator.of(ctx).pop();
            //                           final lat = double.tryParse(
            //                             station.latitude ?? '',
            //                           );
            //                           final lon = double.tryParse(
            //                             station.longitude ?? '',
            //                           );
            //                           if (lat == null || lon == null) return;
            //                           final url = Uri.parse(
            //                             'https://waze.com/ul?ll=$lat,$lon&navigate=yes',
            //                           );
            //                           await launchUrl(
            //                             url,
            //                             mode: LaunchMode.externalApplication,
            //                           );
            //                         },
            //                       ),
            //                       const SizedBox(height: 8),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         },
            //         child: const Text('Navigate'),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           Get.toNamed(
            //             AppRoutes.chargingStation,
            //             arguments: station.id,
            //           );
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.red.shade700,
            //           foregroundColor: Colors.white,
            //         ),
            //         child: const Text('Charge'),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}