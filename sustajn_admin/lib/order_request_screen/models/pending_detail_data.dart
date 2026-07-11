class PendingDetailsData {
  PendingDetailData? data;
  String? message;
  String? status;

  PendingDetailsData({this.data, this.message, this.status});

  PendingDetailsData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new PendingDetailData.fromJson(json['data'])
        : null;
    message = json['message'] ?? "";
    status = json['status'] ?? "";
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

class PendingDetailData {
  int? id;
  String? orderId;
  String? restaurantName;
  String? restaurantAddress;
  String? partnerRemark;
  String? sustajnRemark;
  String? orderedOnDate;
  String? orderedOnTime;
  String? availableQty;
  List<Items>? items;

  PendingDetailData({
    this.id,
    this.orderId,
    this.restaurantName,
    this.restaurantAddress,
    this.partnerRemark,
    this.sustajnRemark,
    this.orderedOnDate,
    this.orderedOnTime,
    this.availableQty,
    this.items,
  });

  PendingDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    orderId = json['orderId'] ?? "";
    restaurantName = json['restaurantName'] ?? "";
    restaurantAddress = json['restaurantAddress'] ?? "";
    partnerRemark = json['partnerRemark'] ?? "";
    sustajnRemark = json['sustajnRemark'] ?? "";
    orderedOnDate = json['orderedOnDate'] ?? "";
    orderedOnTime = json['orderedOnTime'] ?? "";
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
    data['orderedOnDate'] = this.orderedOnDate;
    data['orderedOnTime'] = this.orderedOnTime;
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
  bool? isClicked;
  int? approvequantity;

  Items({
    this.itemId,
    this.containerName,
    this.productCode,
    this.capacity,
    this.imageUrl,
    this.orderedQty,
    this.isClicked = false,
    this.approvequantity = 0,
  });

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'] ?? 0;
    containerName = json['containerName'] ?? "";
    productCode = json['productCode'] ?? "";
    capacity = json['capacity'] ?? "";
    imageUrl = json['imageUrl'] ?? "";
    orderedQty = json['orderedQty'] ?? 0;
    isClicked = json['isClicked'] ?? false;
    approvequantity = json['approvequantity'] ?? 0;
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
