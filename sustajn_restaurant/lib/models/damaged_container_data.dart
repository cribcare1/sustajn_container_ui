class DamagedContainerData {
  List<DamageContainerModel>? data;
  String? message;
  String? status;

  DamagedContainerData({
    this.data,
    this.message,
    this.status,
  });

  DamagedContainerData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DamageContainerModel>[];
      json['data'].forEach((v) {
        data!.add(DamageContainerModel.fromJson(v));
      });
    }

    message = json['message'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    dataMap['message'] = message;
    dataMap['status'] = status;

    return dataMap;
  }
}

class DamageContainerModel {
  String? monthYear;
  int? monthWiseTotalDamageContainers;
  List<DamageContainers>? damageContainers;

  DamageContainerModel({
    this.monthYear,
    this.monthWiseTotalDamageContainers,
    this.damageContainers,
  });

  DamageContainerModel.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'] ?? "";

    monthWiseTotalDamageContainers =
        json['monthWiseTotalDamageContainers'] ?? 0;

    if (json['damageContainers'] != null) {
      damageContainers = <DamageContainers>[];

      json['damageContainers'].forEach((v) {
        damageContainers!.add(DamageContainers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['monthYear'] = monthYear;

    data['monthWiseTotalDamageContainers'] =
        monthWiseTotalDamageContainers;

    if (damageContainers != null) {
      data['damageContainers'] =
          damageContainers!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class DamageContainers {
  String? productIds;
  String? localDateTime;
  int? dateWiseTotalDamageContainers;
  List<Products>? products;

  DamageContainers({
    this.productIds,
    this.localDateTime,
    this.dateWiseTotalDamageContainers,
    this.products,
  });

  DamageContainers.fromJson(Map<String, dynamic> json) {
    productIds = json['productIds'] ?? "";

    localDateTime = json['LocalDateTime'] ?? "";

    dateWiseTotalDamageContainers =
        json['dateWiseTotalDamageContainers'] ?? 0;

    if (json['products'] != null) {
      products = <Products>[];

      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['productIds'] = productIds;
    data['LocalDateTime'] = localDateTime;

    data['dateWiseTotalDamageContainers'] =
        dateWiseTotalDamageContainers;

    if (products != null) {
      data['products'] =
          products!.map((v) => v.toJson()).toList();
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
  String? damageRemark;
  String? damageImagesUrls;

  Products({
    this.productId,
    this.productName,
    this.productDescription,
    this.productImageUrl,
    this.capacity,
    this.productUniqueId,
    this.damageRemark,
    this.damageImagesUrls,
  });

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] ?? 0;
    productName = json['productName'] ?? "";
    productDescription = json['productDescription'] ?? "";
    productImageUrl = json['productImageUrl'] ?? "";
    capacity = json['capacity'] ?? 0;
    productUniqueId = json['productUniqueId'] ?? "";
    damageRemark = json['damageRemark'] ?? "";
    damageImagesUrls = json['damageImagesUrls'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['productImageUrl'] = productImageUrl;
    data['capacity'] = capacity;
    data['productUniqueId'] = productUniqueId;
    data['damageRemark'] = damageRemark;
    data['damageImagesUrls'] = damageImagesUrls;

    return data;
  }
}