class ExtendedFeeData {
  List<ExtendedFeeDataList>? data;
  String? message;
  String? status;

  ExtendedFeeData({this.data, this.message, this.status});

  ExtendedFeeData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ExtendedFeeDataList>[];
      json['data'].forEach((v) {
        data!.add(new ExtendedFeeDataList.fromJson(v));
      });
    }
    message = json['message']??"";
    status = json['status']??"";
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

class ExtendedFeeDataList {
  String? monthYear;
  int? monthWiseTotalDamageContainers;
  List<ExtendedFeeContainers>? extendedFeeContainers;

  ExtendedFeeDataList(
      {this.monthYear,
        this.monthWiseTotalDamageContainers,
        this.extendedFeeContainers});

  ExtendedFeeDataList.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear']?? "";
    monthWiseTotalDamageContainers = json['monthWiseTotalDamageContainers']??0;
    if (json['damageContainers'] != null) {
      extendedFeeContainers = <ExtendedFeeContainers>[];
      json['damageContainers'].forEach((v) {
        extendedFeeContainers!.add(new ExtendedFeeContainers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['monthWiseTotalDamageContainers'] =
        this.monthWiseTotalDamageContainers;
    if (this.extendedFeeContainers != null) {
      data['damageContainers'] =
          this.extendedFeeContainers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExtendedFeeContainers {
  String? productIds;
  String? localDateTime;
  int? dateWiseTotalDamageContainers;
  List<Products>? products;

  ExtendedFeeContainers(
      {this.productIds,
        this.localDateTime,
        this.dateWiseTotalDamageContainers,
        this.products});

  ExtendedFeeContainers.fromJson(Map<String, dynamic> json) {
    productIds = json['productIds']?? "";
    localDateTime = json['LocalDateTime']?? "";
    dateWiseTotalDamageContainers = json['dateWiseTotalDamageContainers']?? 0;
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
  Null? customerId;
  Null? restaurantName;
  int? productId;
  String? productName;
  String? productDescription;
  String? productImageUrl;
  int? capacity;
  String? productUniqueId;
  String? damageRemark;
  String? damageImagesUrls;

  Products(
      {this.customerId,
        this.restaurantName,
        this.productId,
        this.productName,
        this.productDescription,
        this.productImageUrl,
        this.capacity,
        this.productUniqueId,
        this.damageRemark,
        this.damageImagesUrls});

  Products.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    restaurantName = json['restaurantName'];
    productId = json['productId']?? 0;
    productName = json['productName']?? "";
    productDescription = json['productDescription']??"";
    productImageUrl = json['productImageUrl']?? "";
    capacity = json['capacity']?? 0;
    productUniqueId = json['productUniqueId']?? "";
    damageRemark = json['damageRemark']?? "";
    damageImagesUrls = json['damageImagesUrls']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['restaurantName'] = this.restaurantName;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['productImageUrl'] = this.productImageUrl;
    data['capacity'] = this.capacity;
    data['productUniqueId'] = this.productUniqueId;
    data['damageRemark'] = this.damageRemark;
    data['damageImagesUrls'] = this.damageImagesUrls;
    return data;
  }
}