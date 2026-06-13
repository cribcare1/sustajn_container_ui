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