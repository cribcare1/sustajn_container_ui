class DeliverDetailData {
  DeliveredData? data;
  String? message;
  String? status;

  DeliverDetailData({this.data, this.message, this.status});

  DeliverDetailData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DeliveredData.fromJson(json['data']) : null;
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

class DeliveredData {
  int? id;
  String? orderId;
  String? restaurantName;
  String? restaurantAddress;
  String? orderedDate;
  String? orderedTime;
  String? confirmedDate;
  String? confirmedTime;
  String? deliveredDate;
  String? deliveredTime;
  List<Items>? items;

  DeliveredData(
      {this.id,
        this.orderId,
        this.restaurantName,
        this.restaurantAddress,
        this.orderedDate,
        this.orderedTime,
        this.confirmedDate,
        this.confirmedTime,
        this.deliveredDate,
        this.deliveredTime,
        this.items});

  DeliveredData.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    orderId = json['orderId']??"";
    restaurantName = json['restaurantName']??"";
    restaurantAddress = json['restaurantAddress']??"";
    orderedDate = json['orderedDate']??"";
    orderedTime = json['orderedTime']??"";
    confirmedDate = json['confirmedDate']??"";
    confirmedTime = json['confirmedTime']??"";
    deliveredDate = json['deliveredDate']??"";
    deliveredTime = json['deliveredTime']??"";
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
    data['confirmedDate'] = this.confirmedDate;
    data['confirmedTime'] = this.confirmedTime;
    data['deliveredDate'] = this.deliveredDate;
    data['deliveredTime'] = this.deliveredTime;
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
  int? deliveredQty;

  Items(
      {this.itemId,
        this.containerName,
        this.productCode,
        this.capacity,
        this.imageUrl,
        this.deliveredQty});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId']??0;
    containerName = json['containerName']??"";
    productCode = json['productCode']??"";
    capacity = json['capacity']??"";
    imageUrl = json['imageUrl']??"";
    deliveredQty = json['deliveredQty']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['containerName'] = this.containerName;
    data['productCode'] = this.productCode;
    data['capacity'] = this.capacity;
    data['imageUrl'] = this.imageUrl;
    data['deliveredQty'] = this.deliveredQty;
    return data;
  }
}
