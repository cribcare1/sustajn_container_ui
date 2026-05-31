class HistoryGraphModel {
  String status;
  String message;
  List<HistoryGraphData> data;

  HistoryGraphModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HistoryGraphModel.fromJson(Map<String, dynamic> json) {
    return HistoryGraphModel(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => HistoryGraphData.fromJson(e))
          .toList() ??
          [],
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
class HistoryGraphData {
  int leasedReturnedCount;
  String time;

  HistoryGraphData({
    required this.leasedReturnedCount,
    required this.time,
  });

  factory HistoryGraphData.fromJson(Map<String, dynamic> json) {
    return HistoryGraphData(
      leasedReturnedCount: json['leasedReturnedCount'] ?? 0,
      time: json['time'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "leasedReturnedCount": leasedReturnedCount,
      "time": time,
    };
  }
}
