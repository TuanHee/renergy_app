import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/bookmark.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/global.dart';
import 'package:renergy_app/main.dart';

class ExplorerController extends GetxController {
  bool isLoading = true;
  List<Station> stations = [];
  List<Bookmark> bookmarks = [];
  Order? chargingOrder;
  String? status;
  Timer? chargingOrderTimer;
  bool isfetching = false;
  List<Station>? filteredList;
  TextEditingController searchController = TextEditingController();
  BitmapDescriptor? appMarkerIcon;
  BitmapDescriptor? stationMarkerIcon;
  GoogleMapController? mapController;
  int? selectedStationId;

  @override
  void onInit() async {
    super.onInit();
    await _loadAppMarkerIcon();
    await _loadStationMarkerIcon();
  }

  @override
  void onClose() {
    chargingOrderTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchStations({Function(String msg)? onErrorCallback}) async {
    try {
      final res = await Api().get(Endpoints.stations);

      if (res.data['status'] == 200) {
        final data = res.data['data'];

        if (data['stations'] is List) {
          stations = Station.listFromJson(res.data['data']['stations']);
        }
      } else {
        throw res.data['message'] ?? 'Failed to fetch stations';
      }
    } catch (e) {
      
      onErrorCallback?.call(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  int getAvailableBayCount(Station station) {
    return station.bays
            ?.where((bay) => bay.status == BayStatus.available)
            .length ??
        0;
  }

  Future<void> fetchBookmark({Function(String msg)? onErrorCallback}) async {
    if(!Global.isLoginValid){
      return;
    }
    try {
      final res = await Api().get(Endpoints.bookmarks);

      if (res.data['status'] != 200) {
        throw ('Failed to fetch Bookmark: ${res.data['message']}');
      }

      if (res.data['data']['bookmarks'] is! List) {
        throw ('Failed to fetch Bookmark: bookmarks is not a list');
      }

      bookmarks = (res.data['data']['bookmarks'] as List)
          .map((element) => Bookmark.fromJson(element))
          .toList();
    } catch (e) {
      onErrorCallback?.call(e.toString());
    }
  }

  Future<void> storeBookmark(Station station) async {
    if(!Global.isLoginValid){
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    final newBookmark = Bookmark(stationId: station.id, station: station);
    bookmarks.add(newBookmark);
    update();
    try {
      final res = await Api().post(
        Endpoints.bookmarks,
        data: {'station_id': station.id},
      );

      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to add bookmark';
      }

      bookmarks.last = Bookmark.fromJson(res.data['data']['bookmark']);
    } catch (e) {
      bookmarks.removeLast();
      update();
      rethrow;
    }
  }

  Future<void> removeBookmark(int? bookmarkId) async {
    if(!Global.isLoginValid){
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    if (bookmarkId == null) {
      throw 'Failed to remove bookmark: Try it Later';
    }
    final removed = bookmarks.firstWhereOrNull((e) => e.id == bookmarkId);

    if (removed == null) {
      throw 'Failed to remove bookmark: do not have this bookmark';
    }
    bookmarks.remove(removed);
    update();

    try {
      final res = await Api().delete(Endpoints.bookmark(bookmarkId));

      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to remove bookmark';
      }
    } catch (e) {
      bookmarks.add(removed);
      update();
      rethrow;
    }
  }

  Future<void> pollChargingOrder({Function(String msg)? onErrorCallback}) async {
    if(!Global.isLoginValid){
      return;
    }
    chargingOrderTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      try {
        if (isfetching) {
          return;
        }
        isfetching = true;
        final res = await Api().get(Endpoints.activeOrder);

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];
          final newStatus = data['status'];
          final newOrder = data['order'] != null ? Order.fromJson(data['order']) : null;
          final changedStatus = newStatus != null && status != newStatus;
          final changedOrder = (chargingOrder?.id ?? -1) != (newOrder?.id ?? -1);

          if (changedStatus || changedOrder) {
            status = newStatus ?? status;
            chargingOrder = newOrder;
            
            update();
          }
        }
      } catch (e, stackTrace) {
        onErrorCallback?.call('Error polling charging order: $e, $stackTrace');
      } finally {
        isfetching = false;
      }
    });
  }

  void stopPollingChargingOrder() {
    chargingOrderTimer?.cancel();
  }

  List<Station> get filteredStations {
    List<Station> returnStations = [];
    returnStations = filteredList == null ? stations : filteredList!;
    
    if(searchController.text.isNotEmpty){
      final query = searchController.text.toLowerCase();
      returnStations = returnStations.where((s) => (s.name ?? '').toLowerCase().contains(query)).toList();
    }

    final position = Get.find<MainController>().position;
    if(position != null){
      returnStations.sort((a, b) => a.distanceTo(position).compareTo(b.distanceTo(position)));
    }

    return returnStations;
  }

  Set<Marker> buildMarkers(LatLng? self) {
    final result = <Marker>{};
    if (self != null) {
      result.add(
        Marker(
          markerId: const MarkerId('self'),
          position: self,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          zIndex: 2,
        ),
      );
    }

    for (final station in filteredStations) {
      final lat = double.tryParse(station.latitude ?? '');
      final lon = double.tryParse(station.longitude ?? '');
      if (lat == null || lon == null) {
        continue;
      }
      result.add(
        Marker(
          markerId: MarkerId('station_${station.id ?? station.name ?? ''}'),
          position: LatLng(lat, lon),
          icon: stationMarkerIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: station.name ?? '',
            snippet: station.shortDescription ?? station.description ?? '',
          ),
          zIndex: (station.id != null && station.id == selectedStationId) ? 3 : 1,
        ),
      );
    }

    return result;
  }

  Future<void> _loadAppMarkerIcon() async {
    if (appMarkerIcon != null) return;
    try {
      appMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'assets/icons/app_icon.jpg',
      );
    } catch (_) {
      appMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  Future<void> _loadStationMarkerIcon() async {
    if (stationMarkerIcon != null) return;
    try {
      stationMarkerIcon = await _createPinIcon('assets/icons/app_icon.jpg');
    } catch (_) {
      stationMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  Future<BitmapDescriptor> _createPinIcon(String assetPath) async {
    const width = 120;
    const height = 140;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    final pinPaint = Paint()..color = Colors.red.shade700..isAntiAlias = true;
    final tipPaint = Paint()..color = Colors.red.shade800..isAntiAlias = true;
    final center = Offset(width / 2, 60);
    canvas.drawCircle(center, 40, pinPaint);
    final path = Path()
      ..moveTo(width / 2, height.toDouble())
      ..lineTo((width / 2) - 20, 90)
      ..lineTo((width / 2) + 20, 90)
      ..close();
    canvas.drawPath(path, tipPaint);
    final innerPaint = Paint()..color = Colors.white..isAntiAlias = true;
    canvas.drawCircle(center, 26, innerPaint);
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 44,
      targetHeight: 44,
    );
    final frame = await codec.getNextFrame();
    final img = frame.image;
    final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    final dst = Rect.fromCenter(center: center, width: 44, height: 44);
    canvas.drawImageRect(img, src, dst, Paint());
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void setSelectedStation(Station station) {
    selectedStationId = station.id;
    update();
    moveCameraToStation(station);
  }

  Future<void> moveCameraToStation(Station station) async {
    final lat = double.tryParse(station.latitude ?? '');
    final lon = double.tryParse(station.longitude ?? '');
    if (lat == null || lon == null) {
      return;
    }
    final target = CameraPosition(target: LatLng(lat, lon), zoom: 16);
    await mapController?.animateCamera(CameraUpdate.newCameraPosition(target));
  }

  Future<void> openExternalNavigation(Station station) async {
    final lat = double.tryParse(station.latitude ?? '');
    final lon = double.tryParse(station.longitude ?? '');
    if (lat == null || lon == null) {
      return;
    }
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lon');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
