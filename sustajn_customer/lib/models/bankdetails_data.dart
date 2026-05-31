class BankDetailData {
  BankData? data;
  String? message;
  String? status;

  BankDetailData({this.data, this.message, this.status});

  BankDetailData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new BankData.fromJson(json['data']) : null;
    message = json['message']??"";
    status = json['status']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class BankData {
  int? id;
  int? userId;
  String? bankName;
  String? accountNumber;
  String? iBanNumber;
  String? taxNumber;
  String? cardHolderName;
  String? cardNumber;
  String? expiryDate;
  String? cvv;
  String? paymentGatewayId;
  String? paymentGatewayName;
  String? status;
  String? createdAt;
  String? updatedAt;

  BankData(
      {this.id,
        this.userId,
        this.bankName,
        this.accountNumber,
        this.iBanNumber,
        this.taxNumber,
        this.cardHolderName,
        this.cardNumber,
        this.expiryDate,
        this.cvv,
        this.paymentGatewayId,
        this.paymentGatewayName,
        this.status,
        this.createdAt,
        this.updatedAt});

  BankData.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    userId = json['userId']??0;
    bankName = json['bankName']??"";
    accountNumber = json['accountNumber']??"";
    iBanNumber = json['iBanNumber']??"";
    taxNumber = json['taxNumber']??"";
    cardHolderName = json['cardHolderName']??"";
    cardNumber = json['cardNumber']??"";
    expiryDate = json['expiryDate']??"";
    cvv = json['cvv']??"";
    paymentGatewayId = json['paymentGatewayId']??"";
    paymentGatewayName = json['paymentGatewayName']??"";
    status = json['status']??"";
    createdAt = json['createdAt']??"";
    updatedAt = json['updatedAt']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['iBanNumber'] = this.iBanNumber;
    data['taxNumber'] = this.taxNumber;
    data['cardHolderName'] = this.cardHolderName;
    data['cardNumber'] = this.cardNumber;
    data['expiryDate'] = this.expiryDate;
    data['cvv'] = this.cvv;
    data['paymentGatewayId'] = this.paymentGatewayId;
    data['paymentGatewayName'] = this.paymentGatewayName;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
