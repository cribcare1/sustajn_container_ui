class PartnerSoldData {
  String? status;
  String? message;
  List<PartnerDataLists>? data;

  PartnerSoldData({this.status, this.message, this.data});

  PartnerSoldData.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    message = json['message'] ?? "";
    if (json['data'] != null) {
      data = <PartnerDataLists>[];
      json['data'].forEach((v) {
        data!.add(new PartnerDataLists.fromJson(v));
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

class PartnerDataLists {
  String? monthYear;
  int? totalQuantity;
  List<PartnerItems>? items;

  PartnerDataLists({this.monthYear, this.totalQuantity, this.items});

  PartnerDataLists.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'] ?? "";
    totalQuantity = json['totalQuantity'] ?? 0;
    if (json['items'] != null) {
      items = <PartnerItems>[];
      json['items'].forEach((v) {
        items!.add(new PartnerItems.fromJson(v));
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

class PartnerItems {
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

  PartnerItems({
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

  PartnerItems.fromJson(Map<String, dynamic> json) {
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
