class LeaseBarrowData {
  String? status;
  String? message;
  Data? leaseBarrowData;

  LeaseBarrowData({this.status, this.message, this.leaseBarrowData});

  LeaseBarrowData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    leaseBarrowData = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.leaseBarrowData != null) {
      data['data'] = this.leaseBarrowData!.toJson();
    }
    return data;
  }
}

class Data {
  String? monthYear;
  List<DailyStats>? dailyStats;

  Data({this.monthYear, this.dailyStats});

  Data.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'];
    if (json['dailyStats'] != null) {
      dailyStats = <DailyStats>[];
      json['dailyStats'].forEach((v) {
        dailyStats!.add(new DailyStats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    if (this.dailyStats != null) {
      data['dailyStats'] = this.dailyStats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyStats {
  int? day;
  String? dayName;
  int? leased;
  int? returned;

  DailyStats({this.day, this.dayName, this.leased, this.returned});

  DailyStats.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dayName = json['dayName'];
    leased = json['leased'];
    returned = json['returned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['dayName'] = this.dayName;
    data['leased'] = this.leased;
    data['returned'] = this.returned;
    return data;
  }
}