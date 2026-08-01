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
  List<DateWiseSoldContainers>? items;

  SoldData({this.monthYear, this.items});

  SoldData.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'];
    if (json['items'] != null) {
      items = <DateWiseSoldContainers>[];
      json['items'].forEach((v) {
        items!.add(new DateWiseSoldContainers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateWiseSoldContainers {
  String? productName;
  String? productUniqueId;
  String? capacity;
  String? imageUrl;
  int? soldQuantity;
  int? totalAmount;
  String? borrowedOn;
  String? dueOn;
  String? soldOn;

  DateWiseSoldContainers(
      {this.productName,
        this.productUniqueId,
        this.capacity,
        this.imageUrl,
        this.soldQuantity,
        this.totalAmount,
        this.borrowedOn,
        this.dueOn,
        this.soldOn});

  DateWiseSoldContainers.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    productUniqueId = json['productUniqueId'];
    capacity = json['capacity'];
    imageUrl = json['imageUrl'];
    soldQuantity = json['soldQuantity'];
    totalAmount = json['totalAmount'];
    borrowedOn = json['borrowedOn'];
    dueOn = json['dueOn'];
    soldOn = json['soldOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['productUniqueId'] = this.productUniqueId;
    data['capacity'] = this.capacity;
    data['imageUrl'] = this.imageUrl;
    data['soldQuantity'] = this.soldQuantity;
    data['totalAmount'] = this.totalAmount;
    data['borrowedOn'] = this.borrowedOn;
    data['dueOn'] = this.dueOn;
    data['soldOn'] = this.soldOn;
    return data;
  }
}
