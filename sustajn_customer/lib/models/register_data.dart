import 'dart:io';

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

  String? bankName;
  String? taxNumber;
  String? accountNumber;
  String? iban;

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

    this.bankName,
    this.taxNumber,
    this.accountNumber,
    this.iban,
  });

  bool get hasBankDetails {
    return (bankName?.trim().isNotEmpty ?? false) ||
        (taxNumber?.trim().isNotEmpty ?? false) ||
        (accountNumber?.trim().isNotEmpty ?? false) ||
        (iban?.trim().isNotEmpty ?? false);
  }

  Map<String, dynamic> toApiBody() {
    final Map<String, dynamic> body = {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,

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

    if (hasBankDetails) {
      body["bankDetails"] = {
        "bankName": bankName,
        "taxNumber": taxNumber,
        "accountNumber": accountNumber,
        "iban": iban,
      };
    }

    return body;
  }
}
