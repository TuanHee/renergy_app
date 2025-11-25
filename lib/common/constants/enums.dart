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

enum ChargingStatsStatus {
  none('None'),
  open('Open'),
  pending('Pending'),
  charging('Charging'),
  finishing('Finishing'),
  restarting('Restarting'),
  paymentPending('Payment Pending'),
  unPaid('Unpaid'),
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

  static String subtitle(String? value){
    switch(ChargingStatsStatus.fromString(value)){
      case ChargingStatsStatus.open: return 'plug in the charger to start the process';
      case ChargingStatsStatus.pending: return 'your request is pending';
      case ChargingStatsStatus.charging: return 'charging in progress';
      case ChargingStatsStatus.finishing: return 'customer is leaving the parking';
      case ChargingStatsStatus.restarting: return 'waiting for rechange';
      case ChargingStatsStatus.paymentPending: return 'payment pending';
      case ChargingStatsStatus.unPaid: return 'unpaid';
      case ChargingStatsStatus.completed: return 'leave the parking to completed the whole process';
      case ChargingStatsStatus.cancelled: return 'cancelled';
      
      default: return '';
    }
  }

  static String title(String? value){
    switch(ChargingStatsStatus.fromString(value)){
      case ChargingStatsStatus.open: return 'Ready To Charge';
       case ChargingStatsStatus.pending: return 'Pending';
      case ChargingStatsStatus.charging: return 'Charging';
      case ChargingStatsStatus.finishing: return 'Finishing';
      case ChargingStatsStatus.restarting: return 'Recharging';
      case ChargingStatsStatus.paymentPending: return 'Payment Pending';
      case ChargingStatsStatus.unPaid: return 'Unpaid';
      case ChargingStatsStatus.completed: return 'Leave Parking';
      case ChargingStatsStatus.cancelled: return 'Cancelled';
      
      default: return '';
    }
  }


}

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
