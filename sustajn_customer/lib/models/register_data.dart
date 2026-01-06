import 'dart:io';

class RegistrationData {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  File? profileImage;

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
  String? accountHolderName;
  String? iban;
  String? bic;

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
    this.accountHolderName,
    this.iban,
    this.bic,
  });

  bool get hasBankDetails {
    return (bankName != null && bankName!.trim().isNotEmpty) ||
        (accountHolderName != null && accountHolderName!.trim().isNotEmpty) ||
        (iban != null && iban!.trim().isNotEmpty) ||
        (bic != null && bic!.trim().isNotEmpty);
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
        "bankName": bankName ?? "",
        "accountHolderName": accountHolderName ?? "",
        "iban": iban ?? "",
        "bic": bic ?? "",
      };
    }

    return body;
  }
}
