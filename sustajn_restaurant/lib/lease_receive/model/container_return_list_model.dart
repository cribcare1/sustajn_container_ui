class ContainerReturnListModel {
  String message;
  String status;
  List<ProductOrderListResponseList> productList;

  ContainerReturnListModel({
    required this.message,
    required this.status,
    required this.productList,
  });

  factory ContainerReturnListModel.fromJson(Map<String, dynamic> json) {
    List<ProductOrderListResponseList> tempList = [];

    if (json["value"] != null && json["value"] is Map) {
      Map<String, dynamic> monthMap = json["value"];

      // Dynamic month handling
      monthMap.forEach((month, orderList) {
        if (orderList != null && orderList is List) {
          for (var order in orderList) {
            if (order["productOrderListResponseList"] != null &&
                order["productOrderListResponseList"] is List) {
              for (var product in order["productOrderListResponseList"]) {
                tempList.add(
                  ProductOrderListResponseList.fromJson(product),
                );
              }
            }
          }
        }
      });
    }

    return ContainerReturnListModel(
      message: json["message"] ?? "",
      status: json["status"] ?? "",
      productList: tempList,
    );
  }
}

class ProductOrderListResponseList {
  String productId;
  String productName;
  String capacity;
  String containerCount;
  String productImageUrl;
  String productUniqueId;
  int? quantity;

  ProductOrderListResponseList({
    required this.productId,
    required this.productName,
    required this.capacity,
    required this.containerCount,
    required this.productImageUrl,
    required this.productUniqueId,
    this.quantity = 1,
  });

  factory ProductOrderListResponseList.fromJson(Map<String, dynamic> json) {
    return ProductOrderListResponseList(
      productId: json["productId"]?.toString() ?? "",
      productName: json["productName"] ?? "",
      capacity: json["capacity"]?.toString() ?? "",
      containerCount: json["containerCount"]?.toString() ?? "",
      productImageUrl: json["productImageUrl"] ?? "",
      productUniqueId: json["productUniqueId"] ?? "",
      quantity: json["quantity"] ?? "",
    );
  }
}
