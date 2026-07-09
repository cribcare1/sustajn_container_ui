class RejectDetailsData {
  RejectedData? data;
  String? message;
  String? status;

  RejectDetailsData({this.data, this.message, this.status});

  RejectDetailsData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new RejectedData.fromJson(json['data']) : null;
    message = json['message']??"";
    status = json['status']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class RejectedData {
  int? id;
  String? orderId;
  String? restaurantName;
  String? restaurantAddress;
  String? orderedDate;
  String? orderedTime;
  String? rejectedDate;
  String? rejectedTime;
  String? rejectedRemark;
  List<Items>? items;

  RejectedData(
      {this.id,
        this.orderId,
        this.restaurantName,
        this.restaurantAddress,
        this.orderedDate,
        this.orderedTime,
        this.rejectedDate,
        this.rejectedTime,
        this.rejectedRemark,
        this.items});

  RejectedData.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    orderId = json['orderId']??"";
    restaurantName = json['restaurantName']??"";
    restaurantAddress = json['restaurantAddress']??"";
    orderedDate = json['orderedDate']??"";
    orderedTime = json['orderedTime']??"";
    rejectedDate = json['rejectedDate']??"";
    rejectedTime = json['rejectedTime']??"";
    rejectedRemark = json['rejectedRemark']??"";
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['restaurantName'] = this.restaurantName;
    data['restaurantAddress'] = this.restaurantAddress;
    data['orderedDate'] = this.orderedDate;
    data['orderedTime'] = this.orderedTime;
    data['rejectedDate'] = this.rejectedDate;
    data['rejectedTime'] = this.rejectedTime;
    data['rejectedRemark'] = this.rejectedRemark;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? itemId;
  String? containerName;
  String? productCode;
  String? capacity;
  String? imageUrl;
  int? requestedQty;

  Items(
      {this.itemId,
        this.containerName,
        this.productCode,
        this.capacity,
        this.imageUrl,
        this.requestedQty});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId']??0;
    containerName = json['containerName']??"";
    productCode = json['productCode']??"";
    capacity = json['capacity']??"";
    imageUrl = json['imageUrl']??"";
    requestedQty = json['requestedQty']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['containerName'] = this.containerName;
    data['productCode'] = this.productCode;
    data['capacity'] = this.capacity;
    data['imageUrl'] = this.imageUrl;
    data['requestedQty'] = this.requestedQty;
    return data;
  }
}
