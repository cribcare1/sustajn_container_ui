import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/imports_util.dart';
import '../../constants/string_utils.dart';

enum SocialMediaType { instagram, facebook, snapchat, x }

class SocialMediaModel {
  final SocialMediaType socialMediaType;
  final TextEditingController controller;

  SocialMediaModel({required this.socialMediaType, required this.controller});

  Map<String, dynamic> toJson() {
    return {
      "socialMediaType": socialMediaType.name.toUpperCase(),
      "link": controller.text,
    };
  }
}

class SocialMediaConfig {
  final SocialMediaType type;
  final String label;
  final IconData icon;
  final Color color;

  SocialMediaConfig(this.type, this.label, this.icon, this.color);
}

final socialMediaOptions = [
  SocialMediaConfig(
    SocialMediaType.instagram,
    Strings.INSTAGRAM,
    FontAwesomeIcons.instagram,
    Colors.pink,
  ),
  SocialMediaConfig(
    SocialMediaType.facebook,
    Strings.FACEBOOK,
    FontAwesomeIcons.facebook,
    Colors.blue,
  ),
  SocialMediaConfig(
    SocialMediaType.snapchat,
    Strings.SNAPCHAT,
    FontAwesomeIcons.snapchat,
    Colors.yellow,
  ),
  SocialMediaConfig(
    SocialMediaType.x,
    Strings.TWITTER,
    FontAwesomeIcons.xTwitter,
    Colors.white,
  ),
];


class BusinessModel {
  final String speciality;
  final String websiteDetails;
  final String cuisine;

  BusinessModel({
    this.speciality = "",
    this.websiteDetails = "",
    this.cuisine = "",
  });

  Map<String, dynamic> toJson() => {
    "businessType": speciality,
    "websiteDetails": websiteDetails,
    "cuisine": cuisine,
  };
}
class ContactAndRegistrationDetails {
  String? contactPersonName;
  String? contactEmail;
  String? treadLicenseNumber;
  String? vatNumber;
  String? contactNumber;
  String? registrationNumber;

  ContactAndRegistrationDetails({
    this.contactPersonName="",
    this.contactEmail="",
    this.treadLicenseNumber="",
    this.vatNumber="",
    this.contactNumber="",
    this.registrationNumber="",
  });

  Map<String, dynamic> toJson() {
    return {
      "contactPersonName": contactPersonName ?? "",
      "contactEmail": contactEmail ?? "",
      "treadLicenseNumber": treadLicenseNumber ?? "",
      "vatNumber": vatNumber ?? "",
      "contactNumber": contactNumber ?? "",
      "registrationNumber": registrationNumber ?? "",
    };
  }
}
