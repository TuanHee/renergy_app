class AppNotification {
  String? title;
  String? message;
  String? goto;
  dynamic data;
  DateTime? readAt;

  AppNotification({
    this.title,
    this.message,
    this.goto,
    this.data,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['data']['title'],
      message: json['data']['message'],
      goto: json['data']['goto'],
      data: json['data']['data'],
      readAt: json['read_at'] == null ? null : DateTime.parse(json['read_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'goto': goto,
      'data': data,
      'read_at': readAt?.toIso8601String(),
    };
  }

  static List<AppNotification> listFromJson(dynamic json) {
    return json == null
        ? []
        : List<AppNotification>.from(json.map((x) => AppNotification.fromJson(x)));
  }
}