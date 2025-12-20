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

  String? speciality;
  String? websiteDetails;
  String? cuisine;

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
    this.speciality,
    this.websiteDetails,
    this.cuisine,
    this.bankName,
    this.accountNumber,
    this.taxNumber,
    List<Map<String, dynamic>>? socialMediaList,
  }) {
    if (socialMediaList != null) {
      this.socialMediaList = socialMediaList;
    }
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
      "basicDetails": {
        "speciality": speciality,
        "websiteDetails": websiteDetails,
        "cuisine": cuisine,
      },
      "bankDetails": {
        "bankName": bankName,
        "accountNumber": accountNumber,
        "taxNumber": taxNumber,
      },
      "socialMediaList": socialMediaList,
    };
  }
}
