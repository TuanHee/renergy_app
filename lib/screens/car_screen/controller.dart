import 'package:get/get.dart';
import 'package:renergy_app/common/models/car.dart';


class CarController extends GetxController {
  bool isLoading = true;
  String? errorMessage;

  int defaultCarIndex = 0;

  List<Car> cars = [];


  @override
  void onInit() async {
    super.onInit();
    cars = [
      Car(
        id: '1',
        model: 'TESLA MODEL Y',
        plate: 'JDE 5533',
      ),
    ];
  }
}

