class MonthWiseHistoryModel {
  String status;
  String message;
  List<MonthWiseData> data;

  MonthWiseHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MonthWiseHistoryModel.fromJson(Map<String, dynamic> json) {
    return MonthWiseHistoryModel(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      data: json['data'] is List
          ? (json['data'] as List)
          .map((e) => MonthWiseData.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthWiseData {
  String monthYear;
  int totalLeasedOrReturnCount;
  List<DateLeasedReturnCounts> dateLeasedReturnCounts;

  MonthWiseData({
    required this.monthYear,
    required this.totalLeasedOrReturnCount,
    required this.dateLeasedReturnCounts,
  });

  factory MonthWiseData.fromJson(Map<String, dynamic> json) {
    return MonthWiseData(
      monthYear: json['monthYear'] ?? "",
      totalLeasedOrReturnCount:
      _parseInt(json['totalLeasedOrReturnCount']),
      dateLeasedReturnCounts:
      json['dateLeasedReturnCounts'] is List
          ? (json['dateLeasedReturnCounts'] as List)
          .map((e) =>
          DateLeasedReturnCounts.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "monthYear": monthYear,
      "totalLeasedOrReturnCount": totalLeasedOrReturnCount,
      "dateLeasedReturnCounts":
      dateLeasedReturnCounts.map((e) => e.toJson()).toList(),
    };
  }
}

class DateLeasedReturnCounts {
  String date;
  int leasedReturnedCount;

  DateLeasedReturnCounts({
    required this.date,
    required this.leasedReturnedCount,
  });

  factory DateLeasedReturnCounts.fromJson(
      Map<String, dynamic> json) {
    return DateLeasedReturnCounts(
      date: json['date'] ?? "",
      leasedReturnedCount:
      _parseInt(json['leasedReturnedCount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "leasedReturnedCount": leasedReturnedCount,
    };
  }
}

/// 🔥 Safe int parser (handles int, string, null)
int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
