enum ChargingStatus {
  none('None'),
  pending('Pending'),
  charging('Charging'),
  stopped('Stopped'),
  completed('Completed');

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
