class ProductData {
  String? status;
  String? message;
  List<Data>? data;

  ProductData({this.status, this.message, this.data});

  ProductData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? orderId;
  int? productId;
  String? productName;
  int? quantity;
  String? productImageUrl;
  int? daysLeft;
  String? productUniqueId;
  int? containerQuantity;
  String? dueDate;

  Data(
      {this.orderId,
        this.productId,
        this.productName,
        this.quantity,
        this.productImageUrl,
        this.daysLeft,
        this.productUniqueId,
        this.containerQuantity,
        this.dueDate});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId']??0;
    productId = json['productId']??0;
    productName = json['productName']??"";
    quantity = json['quantity']??0;
    productImageUrl = json['productImageUrl']??"";
    daysLeft = json['daysLeft']??0;
    productUniqueId = json['productUniqueId']??"";
    containerQuantity = json['containerQuantity']??0;
    dueDate = json['dueDate']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['productImageUrl'] = this.productImageUrl;
    data['daysLeft'] = this.daysLeft;
    data['productUniqueId'] = this.productUniqueId;
    data['containerQuantity'] = this.containerQuantity;
    data['dueDate'] = this.dueDate;
    return data;
  }
}
