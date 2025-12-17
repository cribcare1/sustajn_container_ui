import 'dart:io';

class RegistrationData {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  File? profileImage;

  String? address;
  double? latitude;
  double? longitude;


  String? bankName;
  String? accountNumber;
  String? taxNumber;

  List<Map<String, dynamic>> socialMediaList = [];

  RegistrationData({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.password,
    this.profileImage,
    this.address,
    this.latitude,
    this.longitude,
    this.bankName,
    this.accountNumber,
    this.taxNumber,
  }) {
  }

  Map<String, dynamic> toApiBody() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "bankDetails": {
        "bankName": bankName,
        "accountNumber": accountNumber,
        "taxNumber": taxNumber,
      },
    };
  }
}