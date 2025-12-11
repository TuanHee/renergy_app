import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/models/bay.dart';
import 'package:renergy_app/common/models/order.dart';

class StationReport {
  final int? id;
  final int? customerId;
  final String? type; // e.g. Station
  final int? stationId;
  final int? bayId;
  final int? chargerPortId;
  final int? orderId;
  final String? reason;
  final String? description;
  final String? status; // e.g. Pending, Completed
  final String? remark;
  final String? createdAt;
  final String? updatedAt;

  final Station? station;
  final Bay? bay;
  final Order? order;

  // Optional fallback names when nested objects are missing
  final String? _stationName;
  final String? _bayName;

  StationReport({
    this.id,
    this.customerId,
    this.type,
    this.stationId,
    this.bayId,
    this.chargerPortId,
    this.orderId,
    this.reason,
    this.description,
    this.status,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.station,
    this.bay,
    this.order,
    String? stationName,
    String? bayName,
  })  : _stationName = stationName,
        _bayName = bayName;

  // Convenience getters matching previous usage
  String? get stationName => station?.name ?? _stationName;
  String? get bayName => bay?.name ?? _bayName ?? (bayId != null ? 'BAY$bayId' : null);

  factory StationReport.fromJson(Map<String, dynamic> json) {
    final stationJson = json['station'] as Map<String, dynamic>?;
    final bayJson = json['bay'] as Map<String, dynamic>?;
    final orderJson = json['order'] as Map<String, dynamic>?;
    final station = stationJson == null ? null : Station.fromJson(stationJson);
    final bay = bayJson == null ? null : Bay.fromJson(bayJson);
    final order = orderJson == null ? null : Order.fromJson(orderJson);

    return StationReport(
      id: _asInt(json['id']),
      customerId: _asInt(json['customer_id']),
      type: json['type']?.toString(),
      stationId: _asInt(json['station_id']) ?? _asInt(station?.id),
      bayId: _asInt(json['bay_id']) ?? _asInt(bay?.id),
      chargerPortId: _asInt(json['charger_port_id']),
      orderId: _asInt(json['order_id']),
      reason: json['reason']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      remark: json['remark']?.toString(),
      createdAt: (json['created_at'] ?? json['createdAt'])?.toString(),
      updatedAt: (json['updated_at'] ?? json['updatedAt'])?.toString(),
      station: station,
      bay: bay,
      order: order,
      stationName: (json['station_name'] ?? station?.name)?.toString(),
      bayName: (json['bay_name'] ?? bay?.name)?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'type': type,
        'station_id': stationId,
        'bay_id': bayId,
        'charger_port_id': chargerPortId,
        'order_id': orderId,
        'reason': reason,
        'description': description,
        'status': status,
        'remark': remark,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'station': station?.toJson(),
        'bay': bay?.toJson(),
        'order': order?.toJson(),
        'station_name': stationName,
        'bay_name': bayName,
      };

  static List<StationReport> listFromJson(dynamic json) {
    if (json == null) return [];
    // If the incoming payload is already a list
    if (json is List) {
      return List<StationReport>.from(json.map((e) => StationReport.fromJson(_asMap(e))));
    }
    // If it's a map, check common keys
    if (json is Map<String, dynamic>) {
      // Common shape: { data: { reports: [...] } }
      final data = json['data'];
      if (data is Map<String, dynamic> && data['reports'] is List) {
        return List<StationReport>.from(
          (data['reports'] as List).map((e) => StationReport.fromJson(_asMap(e))),
        );
      }
      // Alternate: { reports: [...] }
      if (json['reports'] is List) {
        return List<StationReport>.from(
          (json['reports'] as List).map((e) => StationReport.fromJson(_asMap(e))),
        );
      }
      // Fallback: { data: [...] }
      if (data is List) {
        return List<StationReport>.from(data.map((e) => StationReport.fromJson(_asMap(e))));
      }
    }
    return [];
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    return Map<String, dynamic>.from(v as Map);
  }

  String formattedDate() {
    if (createdAt == null) return '';
    try {
      final dt = DateTime.parse(createdAt!).toLocal();
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      final monthName = months[dt.month - 1];
      final day = dt.day.toString().padLeft(2, '0');
      final year = dt.year;
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'pm' : 'am';
      return '$day $monthName $year, $hour:$minute $ampm';
    } catch (_) {
      return createdAt!;
    }
  }
}