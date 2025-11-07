class Endpoints {
  static const String login = 'login';
  static const String stations = 'stations';
  static String station(int id) => '$stations/$id';
  static String order = 'orders';
  static String chargingStats(int id) => '$order/$id/charging-stats';
  static String stopCharging(int id) => '$order/$id/stop-charging';
}