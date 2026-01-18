
class ContainerHistoryData {
  String? status;
  String? message;
  Data? data;

  ContainerHistoryData({this.status, this.message, this.data});

  ContainerHistoryData.fromJson(Map<String, dynamic> json) {
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  List<LeasedResponses>? leasedResponses;
  List<ReceivedResponses>? receivedResponses;
  List<OrderedResponses>? orderedResponses;

  Data({this.leasedResponses, this.receivedResponses, this.orderedResponses});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["leasedResponses"] is List) {
      leasedResponses = json["leasedResponses"] == null ? null : (json["leasedResponses"] as List).map((e) => LeasedResponses.fromJson(e)).toList();
    }
    if(json["receivedResponses"] is List) {
      receivedResponses = json["receivedResponses"] == null ? null : (json["receivedResponses"] as List).map((e) => ReceivedResponses.fromJson(e)).toList();
    }
    if(json["orderedResponses"] is List) {
      orderedResponses = json["orderedResponses"] == null ? null : (json["orderedResponses"] as List).map((e) => OrderedResponses.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(leasedResponses != null) {
      _data["leasedResponses"] = leasedResponses?.map((e) => e.toJson()).toList();
    }
    if(receivedResponses != null) {
      _data["receivedResponses"] = receivedResponses?.map((e) => e.toJson()).toList();
    }
    if(orderedResponses != null) {
      _data["orderedResponses"] = orderedResponses?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class OrderedResponses {
  String? productName;
  String? orderId;
  String? orderDate;
  String? type;
  String? status;
  String? restaurantRemark;
  dynamic adminRemark;
  dynamic decisionAt;
  int? requestedQty;
  int? approvedQty;

  OrderedResponses({this.productName, this.orderId, this.orderDate, this.type, this.status, this.restaurantRemark, this.adminRemark, this.decisionAt, this.requestedQty, this.approvedQty});

  OrderedResponses.fromJson(Map<String, dynamic> json) {
    if(json["productName"] is String) {
      productName = json["productName"];
    }
    if(json["orderId"] is String) {
      orderId = json["orderId"];
    }
    if(json["orderDate"] is String) {
      orderDate = json["orderDate"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["restaurantRemark"] is String) {
      restaurantRemark = json["restaurantRemark"];
    }
    adminRemark = json["adminRemark"];
    decisionAt = json["decisionAt"];
    if(json["requestedQty"] is int) {
      requestedQty = json["requestedQty"];
    }
    if(json["approvedQty"] is int) {
      approvedQty = json["approvedQty"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["productName"] = productName;
    _data["orderId"] = orderId;
    _data["orderDate"] = orderDate;
    _data["type"] = type;
    _data["status"] = status;
    _data["restaurantRemark"] = restaurantRemark;
    _data["adminRemark"] = adminRemark;
    _data["decisionAt"] = decisionAt;
    _data["requestedQty"] = requestedQty;
    _data["approvedQty"] = approvedQty;
    return _data;
  }
}

class ReceivedResponses {
  String? productsName;
  int? orderId;
  String? transactionId;
  String? returnDateTime;
  int? returnedQuantity;

  ReceivedResponses({this.productsName, this.orderId, this.transactionId, this.returnDateTime, this.returnedQuantity});

  ReceivedResponses.fromJson(Map<String, dynamic> json) {
    if(json["productsName"] is String) {
      productsName = json["productsName"];
    }
    if(json["orderId"] is int) {
      orderId = json["orderId"];
    }
    if(json["transactionId"] is String) {
      transactionId = json["transactionId"];
    }
    if(json["returnDateTime"] is String) {
      returnDateTime = json["returnDateTime"];
    }
    if(json["returnedQuantity"] is int) {
      returnedQuantity = json["returnedQuantity"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["productsName"] = productsName;
    _data["orderId"] = orderId;
    _data["transactionId"] = transactionId;
    _data["returnDateTime"] = returnDateTime;
    _data["returnedQuantity"] = returnedQuantity;
    return _data;
  }
}

class LeasedResponses {
  String? productsName;
  int? orderId;
  String? transactionId;
  String? leasedStartDateTime;
  int? leasedQuantity;

  LeasedResponses({this.productsName, this.orderId, this.transactionId, this.leasedStartDateTime, this.leasedQuantity});

  LeasedResponses.fromJson(Map<String, dynamic> json) {
    if(json["productsName"] is String) {
      productsName = json["productsName"];
    }
    if(json["orderId"] is int) {
      orderId = json["orderId"];
    }
    if(json["transactionId"] is String) {
      transactionId = json["transactionId"];
    }
    if(json["leasedStartDateTime"] is String) {
      leasedStartDateTime = json["leasedStartDateTime"];
    }
    if(json["leasedQuantity"] is int) {
      leasedQuantity = json["leasedQuantity"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["productsName"] = productsName;
    _data["orderId"] = orderId;
    _data["transactionId"] = transactionId;
    _data["leasedStartDateTime"] = leasedStartDateTime;
    _data["leasedQuantity"] = leasedQuantity;
    return _data;
  }
}