class CardDetails {
  String? cardHolderName;
  String? cardNumber;
  String? expiryDate;
  String? cvv;

  CardDetails({
    this.cardHolderName = "",
    this.cardNumber = "",
    this.expiryDate = "",
    this.cvv = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'cardHolderName': cardHolderName??"",
      'cardNumber': cardNumber??"",
      "expiryDate": expiryDate??"",
      "cvv": cvv??"",
    };
  }
}

class BankDetailsModel {
  String? bankName;
  String? bicNumber;
  String? accountHolderName;
  String? ibanNumber;

  BankDetailsModel({
    this.bankName = "",
    this.bicNumber = "",
    this.accountHolderName = "",
    this.ibanNumber = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "bankName": bankName ?? "",
      "bicNumber": bicNumber ?? "",
      "accountHolderName": accountHolderName ?? "",
      "iBanNumber": ibanNumber ?? "",
    };
  }
}

class PaymentGatewayModel {
   String? name;
   String? id;
   String? asset;

  PaymentGatewayModel({
     this.name ="",
     this.id ="",
     this.asset ="",
  });
  Map<String, dynamic> toJson() {
    return {
      'paymentGatewayId': name??"",
      "paymentGatewayName": id??"",
      'asset': asset??"",
    };
  }
}
