class CustomerBorrowedData {
  String? status;
  String? message;
  List<ProductOrderListResponseList>? data;

  CustomerBorrowedData({this.status, this.message, this.data});

  CustomerBorrowedData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductOrderListResponseList>[];
      json['data'].forEach((v) {
        data!.add(new ProductOrderListResponseList.fromJson(v));
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

class ProductOrderListResponseList {
  int? userId;
  int? orderId;
  int? productId;
  String? productName;
  int? quantity;
  String? productImageUrl;
  int? daysLeft;
  String? productUniqueId;
  int? containerQuantity;
  String? dueDate;
  int? containerCount;

  ProductOrderListResponseList(
      {this.userId,
        this.orderId,
        this.productId,
        this.productName,
        this.quantity,
        this.productImageUrl,
        this.daysLeft,
        this.productUniqueId,
        this.containerQuantity,
        this.dueDate,
      this.containerCount});

  ProductOrderListResponseList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    orderId = json['orderId'];
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    productImageUrl = json['productImageUrl'];
    daysLeft = json['daysLeft'];
    productUniqueId = json['productUniqueId'];
    containerQuantity = json['containerQuantity'];
    dueDate = json['dueDate'];
    containerCount =json['containerCount']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['orderId'] = this.orderId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['productImageUrl'] = this.productImageUrl;
    data['daysLeft'] = this.daysLeft;
    data['productUniqueId'] = this.productUniqueId;
    data['containerQuantity'] = this.containerQuantity;
    data['dueDate'] = this.dueDate;
    data['containerCount'] = this.containerCount;
    return data;
  }
}