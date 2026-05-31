class ChartModel {
  final int total;
  final int lease;
  final int receive;
  final int damage;
  final int available;
  final String monthYear;

  ChartModel({
    required this.total,
    required this.lease,
    required this.receive,
    required this.damage,
    required this.available,
    required this.monthYear,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      total: json['total'] ?? 0,
      lease: json['lease'] ?? 0,
      receive: json['receive'] ?? 0,
      damage: json['damage'] ?? 0,
      available: json['available'] ?? 0,
      monthYear: json['monthYear'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'lease': lease,
      'receive': receive,
      'damage': damage,
      'available': available,
      'monthYear': monthYear,
    };
  }
}