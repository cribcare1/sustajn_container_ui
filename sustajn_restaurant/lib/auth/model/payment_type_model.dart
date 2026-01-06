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
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      "expiryDate": expiryDate,
      "cvv": cvv,
    };
  }
}

class BankDetailsModel {
  String? bankName;
  String? accountNo;
  String? taxNumber;
  String? ibanNumber;

  BankDetailsModel({
    this.bankName = "",
    this.accountNo = "",
    this.taxNumber = "",
    this.ibanNumber = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      "accountNumber": accountNo,
      'taxNumber': taxNumber,
      "iBanNumber": ibanNumber,
    };
  }
}
class PaymentGatewayModel {
  final String name;
  final String id;
  final String asset;

  PaymentGatewayModel({
    required this.name,
    required this.id,
    required this.asset,
  });
}
