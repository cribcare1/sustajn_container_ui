class ReturnedData {
  String? status;
  String? message;
  List<ReturnDataList>? data;

  ReturnedData({this.status, this.message, this.data});

  ReturnedData.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    message = json['message'] ?? "";
    if (json['data'] != null) {
      data = <ReturnDataList>[];
      json['data'].forEach((v) {
        data!.add(new ReturnDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnDataList {
  String? monthYear;
  int? totalQuantity;
  List<ReturnItems>? items;

  ReturnDataList({this.monthYear, this.totalQuantity, this.items});

  ReturnDataList.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'] ?? "";
    totalQuantity = json['totalQuantity'] ?? 0;
    if (json['items'] != null) {
      items = <ReturnItems>[];
      json['items'].forEach((v) {
        items!.add(new ReturnItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['totalQuantity'] = this.totalQuantity;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnItems {
  int? id;
  int? userId;
  String? customerId;
  int? restaurantId;
  String? restaurantName;
  int? productId;
  String? containerCode;
  int? soldQuantity;
  String? soldDate;
  String? soldTime;
  String? fullDateTime;
  String? reason;

  ReturnItems({
    this.id,
    this.userId,
    this.customerId,
    this.restaurantId,
    this.restaurantName,
    this.productId,
    this.containerCode,
    this.soldQuantity,
    this.soldDate,
    this.soldTime,
    this.fullDateTime,
    this.reason,
  });

  ReturnItems.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['userId'] ?? 0;
    customerId = json['customerId'] ?? "";
    restaurantId = json['restaurantId'] ?? 0;
    restaurantName = json['restaurantName'] ?? "";
    productId = json['productId'] ?? 0;
    containerCode = json['containerCode'] ?? "";
    soldQuantity = json['soldQuantity'] ?? 0;
    soldDate = json['soldDate'] ?? "";
    soldTime = json['soldTime'] ?? "";
    fullDateTime = json['fullDateTime'] ?? "";
    reason = json['reason'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['customerId'] = this.customerId;
    data['restaurantId'] = this.restaurantId;
    data['restaurantName'] = this.restaurantName;
    data['productId'] = this.productId;
    data['containerCode'] = this.containerCode;
    data['soldQuantity'] = this.soldQuantity;
    data['soldDate'] = this.soldDate;
    data['soldTime'] = this.soldTime;
    data['fullDateTime'] = this.fullDateTime;
    data['reason'] = this.reason;
    return data;
  }
}
