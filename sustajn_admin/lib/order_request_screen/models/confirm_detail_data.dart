class ConfirmDetailsData {
  ConfirmDetailData? data;
  String? message;
  String? status;

  ConfirmDetailsData({this.data, this.message, this.status});

  ConfirmDetailsData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ConfirmDetailData.fromJson(json['data']) : null;
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

class ConfirmDetailData {
  int? id;
  String? orderId;
  String? restaurantName;
  String? restaurantAddress;
  String? partnerRemark;
  String? sustajnRemark;
  Null? orderDate;
  Null? orderTime;
  String? orderedOnDate;
  String? orderedOnTime;
  String? confirmedOnDate;
  String? confirmedOnTime;
  List<Items>? items;

  ConfirmDetailData(
      {this.id,
        this.orderId,
        this.restaurantName,
        this.restaurantAddress,
        this.partnerRemark,
        this.sustajnRemark,
        this.orderDate,
        this.orderTime,
        this.orderedOnDate,
        this.orderedOnTime,
        this.confirmedOnDate,
        this.confirmedOnTime,
        this.items});

  ConfirmDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    orderId = json['orderId']??"";
    restaurantName = json['restaurantName']??"";
    restaurantAddress = json['restaurantAddress']??"";
    partnerRemark = json['partnerRemark']??"";
    sustajnRemark = json['sustajnRemark']??"";
    orderDate = json['orderDate'];
    orderTime = json['orderTime'];
    orderedOnDate = json['orderedOnDate']??"";
    orderedOnTime = json['orderedOnTime']??"";
    confirmedOnDate = json['confirmedOnDate']??"";
    confirmedOnTime = json['confirmedOnTime']??"";
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
    data['partnerRemark'] = this.partnerRemark;
    data['sustajnRemark'] = this.sustajnRemark;
    data['orderDate'] = this.orderDate;
    data['orderTime'] = this.orderTime;
    data['orderedOnDate'] = this.orderedOnDate;
    data['orderedOnTime'] = this.orderedOnTime;
    data['confirmedOnDate'] = this.confirmedOnDate;
    data['confirmedOnTime'] = this.confirmedOnTime;
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
  int? orderedQty;

  Items(
      {this.itemId,
        this.containerName,
        this.productCode,
        this.capacity,
        this.imageUrl,
        this.orderedQty});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId']??0;
    containerName = json['containerName']??"";
    productCode = json['productCode']??"";
    capacity = json['capacity']??"";
    imageUrl = json['imageUrl']??"";
    orderedQty = json['orderedQty']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['containerName'] = this.containerName;
    data['productCode'] = this.productCode;
    data['capacity'] = this.capacity;
    data['imageUrl'] = this.imageUrl;
    data['orderedQty'] = this.orderedQty;
    return data;
  }
}
