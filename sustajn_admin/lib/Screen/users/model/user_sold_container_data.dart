class SoldContainerData {
  List<SoldDataList>? data;
  String? message;
  String? status;

  SoldContainerData({this.data, this.message, this.status});

  SoldContainerData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SoldDataList>[];
      json['data'].forEach((v) {
        data!.add(new SoldDataList.fromJson(v));
      });
    }
    message = json['message'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class SoldDataList {
  String? monthYear;
  int? monthWiseTotalSoldContainers;
  List<DateWiseSoldContainers>? dateWiseSoldContainers;

  SoldDataList(
      {this.monthYear,
        this.monthWiseTotalSoldContainers,
        this.dateWiseSoldContainers});

  SoldDataList.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'] ?? "";
    monthWiseTotalSoldContainers = json['monthWiseTotalSoldContainers'] ?? 0;
    if (json['dateWiseSoldContainers'] != null) {
      dateWiseSoldContainers = <DateWiseSoldContainers>[];
      json['dateWiseSoldContainers'].forEach((v) {
        dateWiseSoldContainers!.add(new DateWiseSoldContainers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['monthWiseTotalSoldContainers'] = this.monthWiseTotalSoldContainers;
    if (this.dateWiseSoldContainers != null) {
      data['dateWiseSoldContainers'] =
          this.dateWiseSoldContainers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateWiseSoldContainers {
  String? productIds;
  String? localDateTime;
  int? dateWiseTotalDamageContainers;
  List<Products>? products;

  DateWiseSoldContainers(
      {this.productIds,
        this.localDateTime,
        this.dateWiseTotalDamageContainers,
        this.products});

  DateWiseSoldContainers.fromJson(Map<String, dynamic> json) {
    productIds = json['productIds'] ?? "";
    localDateTime = json['LocalDateTime'] ?? "";
    dateWiseTotalDamageContainers = json['dateWiseTotalDamageContainers'] ?? 0;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productIds'] = this.productIds;
    data['LocalDateTime'] = this.localDateTime;
    data['dateWiseTotalDamageContainers'] = this.dateWiseTotalDamageContainers;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? productId;
  String? productName;
  String? productDescription;
  String? productImageUrl;
  int? capacity;
  String? productUniqueId;
  int? soldAmount;

  Products(
      {this.productId,
        this.productName,
        this.productDescription,
        this.productImageUrl,
        this.capacity,
        this.productUniqueId,
        this.soldAmount});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] ?? 0;
    productName = json['productName'] ?? "";
    productDescription = json['productDescription'] ?? "";
    productImageUrl = json['productImageUrl'] ?? "";
    capacity = json['capacity'] ?? 0;
    productUniqueId = json['productUniqueId'] ?? "";
    soldAmount = json['soldAmount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['productImageUrl'] = this.productImageUrl;
    data['capacity'] = this.capacity;
    data['productUniqueId'] = this.productUniqueId;
    data['soldAmount'] = this.soldAmount;
    return data;
  }
}
