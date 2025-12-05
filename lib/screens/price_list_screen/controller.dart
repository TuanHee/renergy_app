import 'package:get/get.dart';
import 'package:renergy_app/common/models/fee_set.dart';

class PriceListController extends GetxController {
  bool isLoading = false;
  FeeSet? feeSet;

  @override
  void onInit() {
    super.onInit();
    // Temporary: Initialize from provided JSON snippet to demonstrate binding.
    feeSet = FeeSet.fromJson({
      "id": 3,
      "name": "Commercial Fee Promo",
      "country": null,
      "default_ac_price": "0.77",
      "default_dc_price": "0.88",
      "usage_per_unit": 1000,
      "uom_label": "kWh",
      "idle_fee_price": "1.00",
      "idle_fee_minutes_per_unit": 5,
      "high_occupancy_fee": null,
      "high_occupancy_percentage": null,
      "high_occupancy_max_amount": null,
      "platform_charge_type": null,
      "platform_charge_percentage": "70.00",
      "minimum_charge_amount": "5.00",
      "minimum_charging_minutes": 1,
      "created_at": "2025-12-04T09:59:10.000000Z",
      "updated_at": "2025-12-04T09:59:10.000000Z",
      "tiers": {
        "AC": [
          {
            "id": 7,
            "fee_set_id": 3,
            "type": "AC",
            "max_usage": 22000,
            "price": "0.77",
            "created_at": "2025-12-04T09:59:10.000000Z",
            "updated_at": "2025-12-04T09:59:10.000000Z"
          }
        ],
        "DC": [
          {
            "id": 8,
            "fee_set_id": 3,
            "type": "DC",
            "max_usage": 80000,
            "price": "0.88",
            "created_at": "2025-12-04T09:59:10.000000Z",
            "updated_at": "2025-12-04T09:59:10.000000Z"
          },
          {
            "id": 9,
            "fee_set_id": 3,
            "type": "DC",
            "max_usage": 120000,
            "price": "1.19",
            "created_at": "2025-12-04T09:59:10.000000Z",
            "updated_at": "2025-12-04T09:59:10.000000Z"
          }
        ]
      }
    });
  }

  void setFeeSet(FeeSet value) {
    feeSet = value;
    update();
  }

  void setFeeSetFromJson(Map<String, dynamic> json) {
    feeSet = FeeSet.fromJson(json);
    update();
  }

  List<dynamic> get acTiers => feeSet?.tiersAc ?? [];
  List<dynamic> get dcTiers => feeSet?.tiersDc ?? [];
}