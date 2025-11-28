import 'package:get/get.dart';

import '../models/charging_stats.dart';
import '../routes/app_routes.dart';

enum BayStatus {
  available('Available'),
  reserved('Reserved'),
  unavailable('Unavailable');

  const BayStatus(this.value);
  final String value;

  static BayStatus? fromString(String? value) {
    if (value == null) return null;
    for (BayStatus status in BayStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return null;
  }
}

enum OrderStatus {
  pending('Pending'),
  charging('Charging'),
  finishing('Finishing'),
  restarting('Restarting'),
  cancelled('Cancelled'),
  paymentPending('Payment Pending'),
  completed('Completed'),
  unpaid('Unpaid'),
  error('Error');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus? fromString(String? value) {
    if (value == null) return null;
    for (final status in OrderStatus.values) {
      if (status.value == value) return status;
    }
    return null;
  }

  static String subtitle(String? value) {
    switch (OrderStatus.fromString(value)) {
      case OrderStatus.pending:
        return 'your request is pending';
      case OrderStatus.charging:
        return 'charging in progress';
      case OrderStatus.finishing:
        return 'customer is leaving the parking';
      case OrderStatus.restarting:
        return 'waiting for rechange';
      case OrderStatus.paymentPending:
        return 'payment pending';
      case OrderStatus.unpaid:
        return 'unpaid';
      case OrderStatus.completed:
        return 'leave the parking to completed the whole process';
      case OrderStatus.cancelled:
        return 'cancelled';

      default:
        return '';
    }
  }

  static String title(String? value) {
    switch (OrderStatus.fromString(value)) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.charging:
        return 'Charging';
      case OrderStatus.finishing:
        return 'Finishing';
      case OrderStatus.restarting:
        return 'Recharging';
      case OrderStatus.paymentPending:
        return 'Payment Pending';
      case OrderStatus.unpaid:
        return 'Unpaid';
      case OrderStatus.completed:
        return 'Leave Parking';
      case OrderStatus.cancelled:
        return 'Cancelled';

      default:
        return '';
    }
  }
}

enum ChargingStatsStatus {
  none('None'),
  open('Open'),
  charging('Charging'),
  completed('Completed'),
  cancelled('Cancelled');

  const ChargingStatsStatus(this.value);
  final String value;

  static ChargingStatsStatus? fromString(String? value) {
    if (value == null) return null;
    for (ChargingStatsStatus status in ChargingStatsStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return null;
  }

  static Future<void> page(ChargingStats? chargingStat, chargingProcessPage page) async {
    if (chargingStat?.status == null) throw 'Charging stats status is null';
    if (chargingStat?.order == null) throw 'Charging stats order is null';

          print('chargingStat?.status: ${chargingStat?.status}');
          print('chargingStat?.order?.status: ${chargingStat?.order?.status}');

    switch (chargingStat?.status) {
      case ChargingStatsStatus.open:
        if (page == chargingProcessPage.plugIn) {
          return;
        }

        Get.back();
        await Get.toNamed(AppRoutes.plugInLoading, arguments: chargingStat!.order!);
        break;
      case ChargingStatsStatus.charging:
        if (page == chargingProcessPage.chargingProcessing) {
          return;
        }
        Get.back();
        await Get.toNamed(
          AppRoutes.chargeProcessing,
          arguments: chargingStat!.order!,
        );
        break;

      case ChargingStatsStatus.completed:
        if (chargingStat!.order!.status == OrderStatus.completed.value) {
          Get.back();
          await Get.toNamed(AppRoutes.paymentResult, arguments: chargingStat.order!);
        }
        if (page == chargingProcessPage.recharge) {
          return;
        }
        Get.back();
        await Get.toNamed(AppRoutes.recharge, arguments: chargingStat.order!);
        break;
      case ChargingStatsStatus.cancelled:
        if (chargingStat!.order!.status == OrderStatus.cancelled) {
          Get.back();
          await Get.toNamed(AppRoutes.charging);
        } else if (chargingStat.order!.status == OrderStatus.restarting.value ||
            chargingStat.order!.status == OrderStatus.pending.value) {
          await Get.toNamed(
            AppRoutes.recharge,
            arguments: {'order': chargingStat.order, 'canRecharge': false},
          );
        }
      default:
        break;
    }
  }
}

enum chargingProcessPage { charging,plugIn, chargingProcessing, recharge }

enum ParkingStatus {
  available('Available'),
  reserved('Reserved'),
  unavailable('Unavailable');

  const ParkingStatus(this.value);
  final String value;

  static ParkingStatus? fromString(String? value) {
    if (value == null) return null;
    for (ParkingStatus status in ParkingStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return null;
  }
}
