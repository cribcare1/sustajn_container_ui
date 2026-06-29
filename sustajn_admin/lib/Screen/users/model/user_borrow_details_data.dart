class BorrowedData {
  String? message;
  Value? value;
  String? status;

  BorrowedData({this.message, this.value, this.status});

  BorrowedData.fromJson(Map<String, dynamic> json) {
    message = json['message']??"";
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
    status = json['status']??"";
  }


}

class Value {
  List<December>? december;
  List<December>? november;
  List<December>? october;
  List<December>? september;
  List<December>? august;
  List<December>? july;
  List<December>? june;
  List<December>? may;
  List<December>? april;
  List<December>? march;
  List<December>? february;
  List<December>? january;

  Value.fromJson(Map<String, dynamic> json) {
    if (json['December'] != null) {
      december = (json['December'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['November'] != null) {
      november = (json['November'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['October'] != null) {
      october = (json['October'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['September'] != null) {
      september = (json['September'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['August'] != null) {
      august = (json['August'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['July'] != null) {
      july = (json['July'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['June'] != null) {
      june = (json['June'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['May'] != null) {
      may = (json['May'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['April'] != null) {
      april = (json['April'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['March'] != null) {
      march = (json['March'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['February'] != null) {
      february = (json['February'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
    if (json['January'] != null) {
      january = (json['January'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }
  }
}


class December {
  int? orderId;
  int? restaurantId;
  String? restaurantName;
  String? restaurantAddress;
  int? productCount;
  int? totalContainerCount;
  String? orderDate;
  String? orderTime;
  String? returnedDate;
  String? returnedTime;
  List<ProductOrderListResponseList>? productOrderListResponseList;

  December(
      {this.orderId,
        this.restaurantId,
        this.restaurantName,
        this.restaurantAddress,
        this.productCount,
        this.totalContainerCount,
        this.orderDate,
        this.orderTime,
        this.returnedDate,
        this.returnedTime,
        this.productOrderListResponseList});

  December.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId']??0;
    restaurantId = json['restaurantId']??0;
    restaurantName = json['restaurantName']??"";
    restaurantAddress = json['restaurantAddress']??"";
    productCount = json['productCount']??0;
    totalContainerCount = json['totalContainerCount']??0;
    orderDate = json['orderDate']??"";
    orderTime = json['orderTime']??"";
    returnedDate = json['returnedDate']??"";
    returnedTime = json['returnedTime']??"";
    if (json['productOrderListResponseList'] != null) {
      productOrderListResponseList = <ProductOrderListResponseList>[];
      json['productOrderListResponseList'].forEach((v) {
        productOrderListResponseList!
            .add(new ProductOrderListResponseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['restaurantId'] = this.restaurantId;
    data['restaurantName'] = this.restaurantName;
    data['restaurantAddress'] = this.restaurantAddress;
    data['productCount'] = this.productCount;
    data['totalContainerCount'] = this.totalContainerCount;
    data['orderDate'] = this.orderDate;
    data['orderTime'] = this.orderTime;
    data['returnedDate'] = this.returnedDate;
    data['returnedTime'] = this.returnedTime;
    if (this.productOrderListResponseList != null) {
      data['productOrderListResponseList'] =
          this.productOrderListResponseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductOrderListResponseList {
  int? productId;
  String? productName;
  int? capacity;
  int? containerCount;
  String? productImageUrl;
  String? productUniqueId;

  ProductOrderListResponseList(
      {this.productId,
        this.productName,
        this.capacity,
        this.containerCount,
        this.productImageUrl,
        this.productUniqueId});

  ProductOrderListResponseList.fromJson(Map<String, dynamic> json) {
    productId = json['productId']??0;
    productName = json['productName']??"";
    capacity = json['capacity']??0;
    containerCount = json['containerCount']??0;
    productImageUrl = json['productImageUrl']??"";
    productUniqueId = json['productUniqueId']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['capacity'] = this.capacity;
    data['containerCount'] = this.containerCount;
    data['productImageUrl'] = this.productImageUrl;
    data['productUniqueId'] = this.productUniqueId;
    return data;
  }
}