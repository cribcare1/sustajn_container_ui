class UserSoldData {
  String? status;
  String? message;
  List<SoldDataList>? data;

  UserSoldData({this.status, this.message, this.data});

  UserSoldData.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? 0;
    if (json['data'] != null) {
      data = <SoldDataList>[];
      json['data'].forEach((v) {
        data!.add(new SoldDataList.fromJson(v));
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

class SoldDataList {
  String? monthYear;
  int? totalQuantity;
  List<UserItems>? items;

  SoldDataList({this.monthYear, this.totalQuantity, this.items});

  SoldDataList.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'] ?? "";
    totalQuantity = json['totalQuantity'] ?? 0;
    if (json['items'] != null) {
      items = <UserItems>[];
      json['items'].forEach((v) {
        items!.add(new UserItems.fromJson(v));
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

class UserItems {
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

  UserItems({
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

  UserItems.fromJson(Map<String, dynamic> json) {
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
