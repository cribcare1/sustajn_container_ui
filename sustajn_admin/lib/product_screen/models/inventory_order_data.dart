class InventoryOrderData {
  String? monthYear;
  int? monthTotal;
  List<DailyOrders>? dailyOrders;

  InventoryOrderData({this.monthYear, this.monthTotal, this.dailyOrders});

  InventoryOrderData.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear']??"";
    monthTotal = json['monthTotal']??0;
    if (json['dailyOrders'] != null) {
      dailyOrders = <DailyOrders>[];
      json['dailyOrders'].forEach((v) {
        dailyOrders!.add(new DailyOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['monthTotal'] = this.monthTotal;
    if (this.dailyOrders != null) {
      data['dailyOrders'] = this.dailyOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyOrders {
  String? date;
  int? quantity;

  DailyOrders({this.date, this.quantity});

  DailyOrders.fromJson(Map<String, dynamic> json) {
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
