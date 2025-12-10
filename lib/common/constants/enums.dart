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

  static Future<void> page(
    ChargingStats? chargingStat,
    chargingProcessPage page,
  ) async {
    print('chargingStat?.status: ${chargingStat?.status}');
    print('chargingStat?.order?.status: ${chargingStat?.order?.status}');

    if (chargingStat?.status == null && chargingStat?.order == null) {
      await Get.offNamed(AppRoutes.charging);
    }

    switch (chargingStat?.status) {
      case ChargingStatsStatus.open:
        if (page == chargingProcessPage.plugIn) {
          return;
        }

        await Get.offNamed(
          AppRoutes.plugInLoading,
          arguments: chargingStat!.order!,
        );
        break;
      case ChargingStatsStatus.charging:
        if (page == chargingProcessPage.chargingProcessing) {
          return;
        }

        await Get.offNamed(
          AppRoutes.chargeProcessing,
          arguments: chargingStat!.order!,
        );
        break;

      case ChargingStatsStatus.completed:
        if (OrderStatus.fromString(chargingStat!.order!.status) == OrderStatus.completed) {
          await Get.offNamed(
            AppRoutes.paymentResult,
            arguments: chargingStat.order!,
          );
        }
        if (page == chargingProcessPage.recharge) {
          return;
        }
        await Get.offNamed(AppRoutes.recharge, arguments: chargingStat.order!);
        break;
      case ChargingStatsStatus.cancelled:
        if (OrderStatus.fromString(chargingStat!.order!.status) == OrderStatus.cancelled ||
            OrderStatus.fromString(chargingStat.order!.status) == OrderStatus.unpaid) {
          await Get.offAllNamed(AppRoutes.charging);
        } else if (OrderStatus.fromString(chargingStat.order!.status) == OrderStatus.restarting ||
            OrderStatus.fromString(chargingStat.order!.status) == OrderStatus.pending) {
          await Get.offNamed(
            AppRoutes.recharge,
            arguments: {'order': chargingStat.order, 'canRecharge': false},
          );
        }
      default:
        break;
    }
  }
}

enum chargingProcessPage { charging, plugIn, chargingProcessing, recharge }

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

enum OperationStatus {
  open('Open'),
  close('Close');

  const OperationStatus(this.value);
  final String value;

  static OperationStatus? fromString(String? value) {
    if (value == null) return null;
    for (OperationStatus status in OperationStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return null;
  }
}
