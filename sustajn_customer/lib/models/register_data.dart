import 'dart:io';
enum PaymentMethodType { bank, card, upi }

class RegistrationData {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  File? profileImage;

  // Address
  String? flatDoorHouseDetails;
  String? areaStreetCityBlockDetails;
  String? poBoxOrPostalCode;
  String? addressType;
  String? addressStatus;

  double? latitude;
  double? longitude;

  int? subscriptionPlanId;
  String? dateOfBirth;
  String? gender;

  String? bankName;
  String? iban;
  String? accountHolderName;
  String? bic;
  String? cardHolderName;
  String? cardNumber;
  String? expiryDate;
  String? cvv;

  String? upiId;
  String? paymentMethod;
  String? paymentGatewayId;
  String? paymentGatewayName;


  RegistrationData({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.password,
    this.profileImage,

    this.flatDoorHouseDetails,
    this.areaStreetCityBlockDetails,
    this.poBoxOrPostalCode,
    this.addressType,
    this.addressStatus,

    this.latitude,
    this.longitude,
    this.subscriptionPlanId,
    this.dateOfBirth,
    this.gender,

    this.bankName,
    this.iban,
    this.accountHolderName,
    this.bic,
    this.cardHolderName,
    this.cardNumber,
    this.cvv,
    this.expiryDate,
    this.upiId,
    this.paymentMethod,
    this.paymentGatewayId,
    this.paymentGatewayName

  });

  bool get hasBankDetails {
    return (bankName?.trim().isNotEmpty ?? false) ||
        (iban?.trim().isNotEmpty ?? false) ||
          (accountHolderName?.trim().isNotEmpty ?? false) ||
        (bic?.trim().isNotEmpty ?? false);
  }

  Map<String, dynamic> toApiBody() {
    final Map<String, dynamic> body = {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "dateOfBirth": dateOfBirth,
      "gender":gender,

      "address": {
        "addressType": addressType ?? "HOME",
        "flatDoorHouseDetails": flatDoorHouseDetails,
        "areaStreetCityBlockDetails": areaStreetCityBlockDetails,
        "poBoxOrPostalCode": poBoxOrPostalCode,
        "status": addressStatus ?? "ACTIVE",
      },

      "latitude": latitude,
      "longitude": longitude,
      "subscriptionPlanId": subscriptionPlanId,
    };

    if (paymentMethod == "BANK") {
      body["bankDetails"] = {
        "bankName": bankName,
        "iban": iban,
        "accountHolderName": accountHolderName,
        "bic": bic,
      };
    }

    if (paymentMethod == "CARD") {
      body["cardDetails"] = {
        "cardHolderName": cardHolderName,
        "cardNumber": cardNumber,
        "expiryDate": expiryDate,
        "cvv": cvv,
      };
    }

    if (paymentMethod == "UPI") {
      body["paymentGetWay"] = {
        "paymentGatewayId": paymentGatewayId,
        "paymentGatewayName": paymentGatewayName,
      };
    }

    return body;
  }
}
