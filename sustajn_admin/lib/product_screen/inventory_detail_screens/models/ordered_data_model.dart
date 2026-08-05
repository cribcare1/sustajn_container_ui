class OrderedData {
  String? monthYear;
  int? monthTotal;
  List<DailyOrderd>? dailyOrderd;

  OrderedData({this.monthYear, this.monthTotal, this.dailyOrderd});

  OrderedData.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear']??"";
    monthTotal = json['monthTotal']??0;
    if (json['dailyOrders'] != null) {
      dailyOrderd = <DailyOrderd>[];
      json['dailyOrders'].forEach((v) {
        dailyOrderd!.add(new DailyOrderd.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['monthTotal'] = this.monthTotal;
    if (this.dailyOrderd != null) {
      data['dailyOrders'] = this.dailyOrderd!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyOrderd {
  String? date;
  int? quantity;

  DailyOrderd({this.date, this.quantity});

  DailyOrderd.fromJson(Map<String, dynamic> json) {
    date = json['date']??"";
    quantity = json['quantity']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['quantity'] = this.quantity;
    return data;
  }
}
