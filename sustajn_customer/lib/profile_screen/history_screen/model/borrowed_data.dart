class BorrowedData {
  String? message;
  Value? value;
  String? status;

  BorrowedData({this.message, this.value, this.status});

  BorrowedData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (value != null) {
      data['value'] = value!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Value {
  List<December>? december;
  List<Null>? november;
  List<Null>? october;
  List<Null>? september;
  List<Null>? august;
  List<Null>? july;
  List<Null>? june;
  List<Null>? may;
  List<Null>? april;
  List<Null>? march;
  List<Null>? february;
  List<Null>? january;

  Value({
    this.december,
    this.november,
    this.october,
    this.september,
    this.august,
    this.july,
    this.june,
    this.may,
    this.april,
    this.march,
    this.february,
    this.january,
  });

  Value.fromJson(Map<String, dynamic> json) {
    // December has actual data
    if (json['December'] != null) {
      december = (json['December'] as List)
          .map((e) => December.fromJson(e))
          .toList();
    }

    november = json['November'] != null ? <Null>[] : null;
    october = json['October'] != null ? <Null>[] : null;
    september = json['September'] != null ? <Null>[] : null;
    august = json['August'] != null ? <Null>[] : null;
    july = json['July'] != null ? <Null>[] : null;
    june = json['June'] != null ? <Null>[] : null;
    may = json['May'] != null ? <Null>[] : null;
    april = json['April'] != null ? <Null>[] : null;
    march = json['March'] != null ? <Null>[] : null;
    february = json['February'] != null ? <Null>[] : null;
    january = json['January'] != null ? <Null>[] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (december != null) {
      data['December'] = december!.map((v) => v.toJson()).toList();
    }
    if (november != null) data['November'] = [];
    if (october != null) data['October'] = [];
    if (september != null) data['September'] = [];
    if (august != null) data['August'] = [];
    if (july != null) data['July'] = [];
    if (june != null) data['June'] = [];
    if (may != null) data['May'] = [];
    if (april != null) data['April'] = [];
    if (march != null) data['March'] = [];
    if (february != null) data['February'] = [];
    if (january != null) data['January'] = [];

    return data;
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
        this.productOrderListResponseList});

  December.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    restaurantId = json['restaurantId'];
    restaurantName = json['restaurantName'];
    restaurantAddress = json['restaurantAddress'];
    productCount = json['productCount'];
    totalContainerCount = json['totalContainerCount'];
    orderDate = json['orderDate'];
    orderTime = json['orderTime'];
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
    productId = json['productId'];
    productName = json['productName'];
    capacity = json['capacity'];
    containerCount = json['containerCount'];
    productImageUrl = json['productImageUrl'];
    productUniqueId = json['productUniqueId'];
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