class Endpoints {
  static const String login = 'login';
  static const String stations = 'stations';
  static String station(int id) => '$stations/$id';
  static String orders = 'orders';
  static String order(int id) => '$orders/$id';
  static String chargingStats(int id) => '$orders/$id/charging-stats';
  static String stopCharging(int id) => '$orders/$id/stop-charging';
}