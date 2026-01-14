import '../../constants/imports_util.dart';

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
    'Instagram',
    Icons.camera_alt,
    Colors.pink,
  ),
  SocialMediaConfig(
    SocialMediaType.facebook,
    'Facebook',
    Icons.facebook,
    Colors.blue,
  ),
  SocialMediaConfig(
    SocialMediaType.snapchat,
    'Snapchat',
    Icons.snapchat,
    Colors.yellow,
  ),
  SocialMediaConfig(SocialMediaType.x, 'X', Icons.close, Colors.white),
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
    "speciality": speciality,
    "websiteDetails": websiteDetails,
    "cuisine": cuisine,
  };
}
