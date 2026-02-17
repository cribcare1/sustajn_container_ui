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
  final int userId;
  final int orderId;
  final int productId;
  final String productName;
  final int quantity;
  final String productImageUrl;
  final int daysLeft;
  final String productUniqueId;
  final int containerQuantity;
  final String dueDate;
  int containerCount;

  ProductOrderListResponseList({
    required this.userId,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.productImageUrl,
    required this.daysLeft,
    required this.productUniqueId,
    required this.containerQuantity,
    required this.dueDate,
    this.containerCount = 1,
  });

  factory ProductOrderListResponseList.fromJson(Map<String, dynamic> json) {
    return ProductOrderListResponseList(
      userId: json['userId'] ?? 0,
      orderId: json['orderId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      productImageUrl: json['productImageUrl'] ?? '',
      daysLeft: json['daysLeft'] ?? 0,
      productUniqueId: json['productUniqueId'] ?? '',
      containerQuantity: json['containerQuantity'] ?? 0,
      dueDate: json['dueDate'] ?? '',
      containerCount: json['containerCount'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'productImageUrl': productImageUrl,
      'daysLeft': daysLeft,
      'productUniqueId': productUniqueId,
      'containerQuantity': containerQuantity,
      'dueDate': dueDate,
      'containerCount': containerCount,
    };
  }
}
