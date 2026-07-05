class ContainerHistoryData {
  String? status;
  String? message;
  ConfirmDataList? data;

  ContainerHistoryData({this.status, this.message, this.data});

  ContainerHistoryData.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    message = json['message'] ?? "";
    data = json['data'] != null ? new ConfirmDataList.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ConfirmDataList {
  List<LeasedResponses>? leasedResponses;
  List<ReceivedResponses>? receivedResponses;
  List<OrderedResponses>? orderedResponses;

  ConfirmDataList({this.leasedResponses, this.receivedResponses, this.orderedResponses});

  ConfirmDataList.fromJson(Map<String, dynamic> json) {
    if (json['leasedResponses'] != null) {
      leasedResponses = <LeasedResponses>[];
      json['leasedResponses'].forEach((v) {
        leasedResponses!.add(new LeasedResponses.fromJson(v));
      });
    }
    if (json['receivedResponses'] != null) {
      receivedResponses = <ReceivedResponses>[];
      json['receivedResponses'].forEach((v) {
        receivedResponses!.add(new ReceivedResponses.fromJson(v));
      });
    }
    if (json['orderedResponses'] != null) {
      orderedResponses = <OrderedResponses>[];
      json['orderedResponses'].forEach((v) {
        orderedResponses!.add(new OrderedResponses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leasedResponses != null) {
      data['leasedResponses'] =
          this.leasedResponses!.map((v) => v.toJson()).toList();
    }
    if (this.receivedResponses != null) {
      data['receivedResponses'] =
          this.receivedResponses!.map((v) => v.toJson()).toList();
    }
    if (this.orderedResponses != null) {
      data['orderedResponses'] =
          this.orderedResponses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeasedResponses {
  String? productsName;
  int? orderId;
  String? transactionId;
  String? leasedStartDateTime;
  int? leasedQuantity;
  List<ProductOrderListResponses>? productOrderListResponses;

  LeasedResponses(
      {this.productsName,
        this.orderId,
        this.transactionId,
        this.leasedStartDateTime,
        this.leasedQuantity,
        this.productOrderListResponses});

  LeasedResponses.fromJson(Map<String, dynamic> json) {
    productsName = json['productsName'] ?? "";
    orderId = json['orderId'] ?? 0;
    transactionId = json['transactionId'] ?? "";
    leasedStartDateTime = json['leasedStartDateTime'] ?? "";
    leasedQuantity = json['leasedQuantity'] ?? 0;
    if (json['productOrderListResponses'] != null) {
      productOrderListResponses = <ProductOrderListResponses>[];
      json['productOrderListResponses'].forEach((v) {
        productOrderListResponses!
            .add(new ProductOrderListResponses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productsName'] = this.productsName;
    data['orderId'] = this.orderId;
    data['transactionId'] = this.transactionId;
    data['leasedStartDateTime'] = this.leasedStartDateTime;
    data['leasedQuantity'] = this.leasedQuantity;
    if (this.productOrderListResponses != null) {
      data['productOrderListResponses'] =
          this.productOrderListResponses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductOrderListResponses {
  int? productId;
  String? productName;
  int? capacity;
  int? containerCount;
  String? productImageUrl;
  String? productUniqueId;

  ProductOrderListResponses(
      {this.productId,
        this.productName,
        this.capacity,
        this.containerCount,
        this.productImageUrl,
        this.productUniqueId});

  ProductOrderListResponses.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] ?? 0;
    productName = json['productName'] ?? "";
    capacity = json['capacity'] ?? 0;
    containerCount = json['containerCount'] ?? 0;
    productImageUrl = json['productImageUrl'] ?? "";
    productUniqueId = json['productUniqueId'] ?? "";
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

class ReceivedResponses {
  String? productsName;
  int? orderId;
  String? transactionId;
  String? returnDateTime;
  int? returnedQuantity;
  List<ProductOrderListResponses>? productOrderListResponses;

  ReceivedResponses(
      {this.productsName,
        this.orderId,
        this.transactionId,
        this.returnDateTime,
        this.returnedQuantity,
        this.productOrderListResponses});

  ReceivedResponses.fromJson(Map<String, dynamic> json) {
    productsName = json['productsName'] ?? "";
    orderId = json['orderId'] ?? "";
    transactionId = json['transactionId'] ?? "";
    returnDateTime = json['returnDateTime'] ?? "";
    returnedQuantity = json['returnedQuantity'] ?? "";
    if (json['productOrderListResponses'] != null) {
      productOrderListResponses = <ProductOrderListResponses>[];
      json['productOrderListResponses'].forEach((v) {
        productOrderListResponses!
            .add(new ProductOrderListResponses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productsName'] = this.productsName;
    data['orderId'] = this.orderId;
    data['transactionId'] = this.transactionId;
    data['returnDateTime'] = this.returnDateTime;
    data['returnedQuantity'] = this.returnedQuantity;
    if (this.productOrderListResponses != null) {
      data['productOrderListResponses'] =
          this.productOrderListResponses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderedResponses {
  String? productName;
  String? orderId;
  String? orderDate;
  String? type;
  String? status;
  String? restaurantRemark;
  String? adminRemark;
  String? decisionAt;
  int? requestedQty;
  int? approvedQty;

  OrderedResponses(
      {this.productName,
        this.orderId,
        this.orderDate,
        this.type,
        this.status,
        this.restaurantRemark,
        this.adminRemark,
        this.decisionAt,
        this.requestedQty,
        this.approvedQty});

  OrderedResponses.fromJson(Map<String, dynamic> json) {
    productName = json['productName'] ?? "";
    orderId = json['orderId'] ?? "";
    orderDate = json['orderDate'] ?? "";
    type = json['type'] ?? "";
    status = json['status'] ?? "";
    restaurantRemark = json['restaurantRemark'] ?? "";
    adminRemark = json['adminRemark'] ?? "";
    decisionAt = json['decisionAt'] ?? "";
    requestedQty = json['requestedQty'] ?? 0;
    approvedQty = json['approvedQty'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['orderId'] = this.orderId;
    data['orderDate'] = this.orderDate;
    data['type'] = this.type;
    data['status'] = this.status;
    data['restaurantRemark'] = this.restaurantRemark;
    data['adminRemark'] = this.adminRemark;
    data['decisionAt'] = this.decisionAt;
    data['requestedQty'] = this.requestedQty;
    data['approvedQty'] = this.approvedQty;
    return data;
  }
}
