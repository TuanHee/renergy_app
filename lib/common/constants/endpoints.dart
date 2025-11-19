class Endpoints {
  static const String login = 'login';
  static const String stations = 'stations';
  static String station(int id) => '$stations/$id';
  static String orders = 'orders';
  static String order(int id) => '$orders/$id';
  static String chargingStats(int id) => '$orders/$id/charging-stats';
  static String stopCharging(int id) => '$orders/$id/stop-charging';
  static String restart(int id) => '$orders/$id/restart';
  static String isChanging = 'user/isChanging';
  static String storeBookmark = 'bookmarks';
  static String bookmarkIndex = 'bookmarks';
  static String deleteBookmark(int id) => '$bookmarkIndex/$id';
  static String paymentMethods = 'payment-methods';
}