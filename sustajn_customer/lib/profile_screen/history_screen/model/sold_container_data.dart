class SoldContainerData {
  List<SoldData>? data;
  String? message;
  String? status;

  SoldContainerData({this.data, this.message, this.status});

  SoldContainerData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SoldData>[];
      json['data'].forEach((v) {
        data!.add(new SoldData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
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

class SoldData {
  String? monthYear;
  int? monthWiseTotalSoldContainers;
  List<DateWiseSoldContainers>? dateWiseSoldContainers;

  SoldData(
      {this.monthYear,
        this.monthWiseTotalSoldContainers,
        this.dateWiseSoldContainers});

  SoldData.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'];
    monthWiseTotalSoldContainers = json['monthWiseTotalSoldContainers'];
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
  int? productId;
  String? productName;
  String? productDescription;
  String? productImageUrl;
  int? capacity;
  String? productUniqueId;
  int? soldAmount;
  int? soldQuantity;
  String? borrowedOn;
  String? dueOn;
  String? soldOn;

  DateWiseSoldContainers(
      {this.productId,
        this.productName,
        this.productDescription,
        this.productImageUrl,
        this.capacity,
        this.productUniqueId,
        this.soldAmount,
        this.soldQuantity,
        this.borrowedOn,
        this.dueOn,
        this.soldOn});

  DateWiseSoldContainers.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    productImageUrl = json['productImageUrl'];
    capacity = json['capacity'];
    productUniqueId = json['productUniqueId'];
    soldAmount = json['soldAmount'];
    soldQuantity = json['soldQuantity'];
    borrowedOn = json['borrowedOn'];
    dueOn = json['dueOn'];
    soldOn = json['soldOn'];
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
    data['soldQuantity'] = this.soldQuantity;
    data['borrowedOn'] = this.borrowedOn;
    data['dueOn'] = this.dueOn;
    data['soldOn'] = this.soldOn;
    return data;
  }
}
