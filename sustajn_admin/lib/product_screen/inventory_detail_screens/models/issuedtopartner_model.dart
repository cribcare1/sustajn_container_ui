class IssuedToPartnerData {
  String? monthYear;
  int? totalQuantity;
  List<IssuedList>? issuances;

  IssuedToPartnerData({this.monthYear, this.totalQuantity, this.issuances});

  IssuedToPartnerData.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear']??"";
    totalQuantity = json['totalQuantity']??0;
    if (json['issuances'] != null) {
      issuances = <IssuedList>[];
      json['issuances'].forEach((v) {
        issuances!.add(new IssuedList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['totalQuantity'] = this.totalQuantity;
    if (this.issuances != null) {
      data['issuances'] = this.issuances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IssuedList {
  int? orderId;
  int? restaurantId;
  String? restaurantName;
  String? restaurantAddress;
  String? containerCode;
  int? quantity;
  String? orderedDate;
  String? deliveredDate;

  IssuedList(
      {this.orderId,
        this.restaurantId,
        this.restaurantName,
        this.restaurantAddress,
        this.containerCode,
        this.quantity,
        this.orderedDate,
        this.deliveredDate});

  IssuedList.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId']??0;
    restaurantId = json['restaurantId']??0;
    restaurantName = json['restaurantName']??"";
    restaurantAddress = json['restaurantAddress']??"";
    containerCode = json['containerCode']??"";
    quantity = json['quantity']??0;
    orderedDate = json['orderedDate']??"";
    deliveredDate = json['deliveredDate']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['restaurantId'] = this.restaurantId;
    data['restaurantName'] = this.restaurantName;
    data['restaurantAddress'] = this.restaurantAddress;
    data['containerCode'] = this.containerCode;
    data['quantity'] = this.quantity;
    data['orderedDate'] = this.orderedDate;
    data['deliveredDate'] = this.deliveredDate;
    return data;
  }
}
