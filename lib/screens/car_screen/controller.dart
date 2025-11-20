import 'package:get/get.dart';
import 'package:renergy_app/common/models/car.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';

class CarController extends GetxController {
  bool isLoading = true;

  int defaultCarIndex = 0;

  List<Car> cars = [];

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> fetchCarIndex() async {
    isLoading = true;
    update();
    try {
      final res = await Api().get(Endpoints.vehicles);
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to fetch cars';
      }
      final data = res.data['data'];
      final vehicles = (data is Map && data['vehicles'] is List)
          ? List<Map<String, dynamic>>.from(data['vehicles'])
          : <Map<String, dynamic>>[];
      cars = vehicles.map((json) => Car.fromJson(json)).toList();
      update();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> toAddCarPage() async {
    final result = await Get.toNamed(AppRoutes.addCar);
    if (result == true) {
      await fetchCarIndex();
    }
  }

  Future<void> toEditCarPage(Car car) async {
    final result = await Get.toNamed(AppRoutes.editCar, arguments: car);

    if (result == true) {
      await fetchCarIndex();

    }
  }
}
