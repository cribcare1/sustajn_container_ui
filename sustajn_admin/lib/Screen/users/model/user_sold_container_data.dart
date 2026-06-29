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
    monthYear = json['monthYear']??"";
    monthWiseTotalSoldContainers = json['monthWiseTotalSoldContainers']??0;
    if (json['dateWiseSoldContainers'] != null) {
      dateWiseSoldContainers = <DateWiseSoldContainers>[];
      json['dateWiseSoldContainers'].forEach((v) {
        dateWiseSoldContainers!.add(new DateWiseSoldContainers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = monthYear;
    data['monthWiseTotalSoldContainers'] = monthWiseTotalSoldContainers;
    if (dateWiseSoldContainers != null) {
      data['dateWiseSoldContainers'] =
          dateWiseSoldContainers!.map((v) => v.toJson()).toList();
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
    productId = json['productId']??0;
    productName = json['productName']??"";
    productDescription = json['productDescription']??"";
    productImageUrl = json['productImageUrl']??"";
    capacity = json['capacity']??0;
    productUniqueId = json['productUniqueId']??"";
    soldAmount = json['soldAmount']??0;
    soldQuantity = json['soldQuantity']??0;
    borrowedOn = json['borrowedOn']??"";
    dueOn = json['dueOn']??"";
    soldOn = json['soldOn']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['productImageUrl'] = productImageUrl;
    data['capacity'] = capacity;
    data['productUniqueId'] = productUniqueId;
    data['soldAmount'] = soldAmount;
    data['soldQuantity'] = soldQuantity;
    data['borrowedOn'] = borrowedOn;
    data['dueOn'] = dueOn;
    data['soldOn'] = soldOn;
    return data;
  }
}
