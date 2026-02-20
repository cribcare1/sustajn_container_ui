class DamagedContainerData {
  List<Data>? data;
  String? message;
  String? status;

  DamagedContainerData({this.data, this.message, this.status});

  DamagedContainerData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? monthYear;
  int? monthWiseTotalDamageContainers;
  List<DamageContainers>? damageContainers;

  Data(
      {this.monthYear,
        this.monthWiseTotalDamageContainers,
        this.damageContainers});

  Data.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'] ?? "";
    monthWiseTotalDamageContainers = json['monthWiseTotalDamageContainers'] ?? 0;
    if (json['damageContainers'] != null) {
      damageContainers = <DamageContainers>[];
      json['damageContainers'].forEach((v) {
        damageContainers!.add(new DamageContainers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['monthWiseTotalDamageContainers'] =
        this.monthWiseTotalDamageContainers;
    if (this.damageContainers != null) {
      data['damageContainers'] =
          this.damageContainers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DamageContainers {
  String? productIds;
  String? localDateTime;
  int? dateWiseTotalDamageContainers;
  List<Products>? products;

  DamageContainers(
      {this.productIds,
        this.localDateTime,
        this.dateWiseTotalDamageContainers,
        this.products});

  DamageContainers.fromJson(Map<String, dynamic> json) {
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
  String? damageRemark;
  String? damageImagesUrls;

  Products(
      {this.productId,
        this.productName,
        this.productDescription,
        this.productImageUrl,
        this.capacity,
        this.productUniqueId,
        this.damageRemark,
        this.damageImagesUrls});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
