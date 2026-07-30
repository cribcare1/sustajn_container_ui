class ExtendedFeeData {
  String? status;
  String? message;
  List<ExtendedFeeDataList>? data;

  ExtendedFeeData({this.status, this.message, this.data});

  ExtendedFeeData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ExtendedFeeDataList>[];
      json['data'].forEach((v) {
        data!.add(new ExtendedFeeDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExtendedFeeDataList {
  String? monthYear;
  int? monthTotalAmount;
  List<Transactions>? transactions;

  ExtendedFeeDataList({this.monthYear, this.monthTotalAmount, this.transactions});

  ExtendedFeeDataList.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'];
    monthTotalAmount = json['monthTotalAmount'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['monthTotalAmount'] = this.monthTotalAmount;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  int? orderId;
  String? name;
  String? formattedDateTime;
  int? totalQuantity;
  int? totalAmount;

  Transactions(
      {this.orderId,
        this.name,
        this.formattedDateTime,
        this.totalQuantity,
        this.totalAmount});

  Transactions.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    name = json['name'];
    formattedDateTime = json['formattedDateTime'];
    totalQuantity = json['totalQuantity'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['name'] = this.name;
    data['formattedDateTime'] = this.formattedDateTime;
    data['totalQuantity'] = this.totalQuantity;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}
