enum ChargingStatus {
  none('None'),
  pending('Pending'),
  charging('Charging'),
  stopped('Stopped'),
  completed('Completed'),
  cancelled('Cancelled');

  const ChargingStatus(this.value);
  final String value;

  static ChargingStatus? fromString(String? value) {
    if (value == null) return null;
    for (ChargingStatus status in ChargingStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return null;
  }
}

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
  open('Open'),
  charging('Charging'),
  accepted('Accepted'),
  rejected('Rejected'),
  completed('Completed');

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
      case ChargingStatsStatus.accepted: return 'the charge process was started soon';
      case ChargingStatsStatus.charging: return 'charging in progress';
      case ChargingStatsStatus.completed: return 'leave the parking to completed the whole process';
      case ChargingStatsStatus.rejected: return 'your request was rejected, please try it later';
      
      default: return '';
    }
  }

  static String title(String? value){
    switch(ChargingStatsStatus.fromString(value)){
      case ChargingStatsStatus.open: return 'Ready To Charge';
      case ChargingStatsStatus.accepted: return 'Accepted';
      case ChargingStatsStatus.charging: return 'Charging';
      case ChargingStatsStatus.completed: return 'Leave Parking';
      case ChargingStatsStatus.rejected: return 'Rejected';
      
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
