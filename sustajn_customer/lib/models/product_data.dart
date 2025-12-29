class ProductData {
  String? message;
  List<Value>? value;
  String? status;

  ProductData({this.message, this.value, this.status});

  ProductData.fromJson(Map<String, dynamic> json) {
    message = json['message']??'';
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(new Value.fromJson(v));
      });
    }
    status = json['status']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Value {
  int? orderId;
  int? productId;
  String? productName;
  int? quantity;
  String? productImageUrl;
  int? daysLeft;
  String? productUniqueId;

  Value(
      {this.orderId,
        this.productId,
        this.productName,
        this.quantity,
        this.productImageUrl,
        this.daysLeft,
        this.productUniqueId});

  Value.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId']??0;
    productId = json['productId']??0;
    productName = json['productName']??'';
    quantity = json['quantity']??0;
    productImageUrl = json['productImageUrl']??'';
    daysLeft = json['daysLeft']??0;
    productUniqueId = json['productUniqueId']??'';
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
    return data;
  }
}
