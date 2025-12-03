import 'package:get/get.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/screens/explorer_screen/controller.dart';

class FilterController extends GetxController {
  String accessLevel = 'public';
  String powerSupply = 'all';
  double minKw = 22;
  double maxKw = 180;
  final List<String> locationTags = [
    'Bookmark',
    'Commercial',
    'Golf Course',
    'Grocery',
    'Homestay',
    'Hotel',
    'Medical',
    'Residential Condo',
    'Restaurant',
    'Service Centre',
    'Shopping Mall',
    'Showroom',
    'Sports Centre',
  ];
  final Set<String> selectedTags = {};

  void setAccessLevel(String level) {
    accessLevel = level;
    update();
  }

  void setPowerSupply(String value) {
    powerSupply = value;
    update();
  }

  void setKwRange(double start, double end) {
    minKw = start;
    maxKw = end;
    update();
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    update();
  }

  void reset() {
    accessLevel = 'public';
    powerSupply = 'all';
    minKw = 22;
    maxKw = 180;
    selectedTags.clear();
    update();
  }

  List<Station> filterStations() {
    final explorer = Get.isRegistered<ExplorerController>()
        ? Get.find<ExplorerController>()
        : null;
    List<Station> returnStations = explorer?.stations ?? [];

    returnStations = returnStations.where((station) {
      final t = station.type?.trim().toLowerCase();
      return t != null && t == accessLevel.trim().toLowerCase();
    }).toList();

    returnStations = returnStations
        .where(
          (station) =>
              (powerSupply == 'all' ||
              (station.bays != null &&
                  station.bays!
                      .where(
                        (b) =>
                            b.port?.currentType?.trim().toLowerCase() ==
                            powerSupply.trim().toLowerCase(),
                      )
                      .isNotEmpty)),
        )
        .toList();

    returnStations = returnStations.where((station) {
      final bays = station.bays;
      if (bays == null) return false;

      final hasBayWithinMax = bays.any((bay) {
        final outputCurrent = bay.port?.outputCurrent;
        return outputCurrent != null && double.parse(outputCurrent) <= maxKw;
      });

      final hasBayWithinMin = bays.any((bay) {
        final outputCurrent = bay.port?.outputCurrent;
        return outputCurrent != null && double.parse(outputCurrent) >= minKw;
      });

      return hasBayWithinMax && hasBayWithinMin;
    }).toList();

    returnStations = returnStations
        .where(
          (station) =>
              (selectedTags.isEmpty ||
                      selectedTags.any((tag) => station.category?.toLowerCase().contains(tag.toLowerCase()) ?? false)),
        )
        .toList();

    return returnStations;
  }

  int get matchedCount {
    final list = filterStations();
    return list.length;
  }

  List<Station> get filteredStations => filterStations();
}
