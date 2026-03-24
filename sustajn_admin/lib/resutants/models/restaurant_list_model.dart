class RestaurantListData {
  Data? data;
  String? message;
  String? status;

  RestaurantListData({this.data, this.message, this.status});

  RestaurantListData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? fullName;
  String? mobileNumber;
  String? secondaryNumber;
  String? planId;
  String? subscriptionType;
  BasicRestaurantDetails? basicRestaurantDetails;
  ContactAndRegistrationDetailsResponse? contactAndRegistrationDetailsResponse;
  List<SocialMediaDetailsList>? socialMediaDetailsList;

  Data(
      {this.id,
        this.fullName,
        this.mobileNumber,
        this.secondaryNumber,
        this.planId,
        this.subscriptionType,
        this.basicRestaurantDetails,
        this.contactAndRegistrationDetailsResponse,
        this.socialMediaDetailsList});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    fullName = json['fullName'] ?? '';
    mobileNumber = json['mobileNumber'] ?? '';
    secondaryNumber = json['secondaryNumber'] ?? '';
    planId = json['planId'] ?? '';
    subscriptionType = json['subscriptionType'] ?? '';
    basicRestaurantDetails = json['basicRestaurantDetails'] != null
        ? new BasicRestaurantDetails.fromJson(json['basicRestaurantDetails'])
        : null;
    contactAndRegistrationDetailsResponse =
    json['contactAndRegistrationDetailsResponse'] != null
        ? new ContactAndRegistrationDetailsResponse.fromJson(
        json['contactAndRegistrationDetailsResponse'])
        : null;
    if (json['socialMediaDetailsList'] != null) {
      socialMediaDetailsList = <SocialMediaDetailsList>[];
      json['socialMediaDetailsList'].forEach((v) {
        socialMediaDetailsList!.add(new SocialMediaDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['mobileNumber'] = this.mobileNumber;
    data['secondaryNumber'] = this.secondaryNumber;
    data['planId'] = this.planId;
    data['subscriptionType'] = this.subscriptionType;
    if (this.basicRestaurantDetails != null) {
      data['basicRestaurantDetails'] = this.basicRestaurantDetails!.toJson();
    }
    if (this.contactAndRegistrationDetailsResponse != null) {
      data['contactAndRegistrationDetailsResponse'] =
          this.contactAndRegistrationDetailsResponse!.toJson();
    }
    if (this.socialMediaDetailsList != null) {
      data['socialMediaDetailsList'] =
          this.socialMediaDetailsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BasicRestaurantDetails {
  int? id;
  int? restaurantId;
  String? businessType;
  String? websiteDetails;
  String? cuisine;
  String? createdAt;
  String? updatedAt;

  BasicRestaurantDetails(
      {this.id,
        this.restaurantId,
        this.businessType,
        this.websiteDetails,
        this.cuisine,
        this.createdAt,
        this.updatedAt});

  BasicRestaurantDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    restaurantId = json['restaurantId'] ?? 0;
    businessType = json['businessType'] ?? '';
    websiteDetails = json['websiteDetails'] ?? '';
    cuisine = json['cuisine'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantId'] = this.restaurantId;
    data['businessType'] = this.businessType;
    data['websiteDetails'] = this.websiteDetails;
    data['cuisine'] = this.cuisine;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ContactAndRegistrationDetailsResponse {
  int? id;
  String? contactPersonName;
  String? contactEmail;
  String? treadLicenseNumber;
  String? vatNumber;
  String? contactNumber;
  String? registrationNumber;

  ContactAndRegistrationDetailsResponse(
      {this.id,
        this.contactPersonName,
        this.contactEmail,
        this.treadLicenseNumber,
        this.vatNumber,
        this.contactNumber,
        this.registrationNumber});

  ContactAndRegistrationDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    contactPersonName = json['contactPersonName'] ?? '';
    contactEmail = json['contactEmail'] ?? '';
    treadLicenseNumber = json['treadLicenseNumber'] ?? '';
    vatNumber = json['vatNumber'] ?? '';
    contactNumber = json['contactNumber'] ?? '';
    registrationNumber = json['registrationNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contactPersonName'] = this.contactPersonName;
    data['contactEmail'] = this.contactEmail;
    data['treadLicenseNumber'] = this.treadLicenseNumber;
    data['vatNumber'] = this.vatNumber;
    data['contactNumber'] = this.contactNumber;
    data['registrationNumber'] = this.registrationNumber;
    return data;
  }
}

class SocialMediaDetailsList {
  int? id;
  int? restaurantId;
  String? socialMediaType;
  String? link;
  String? createdAt;
  String? updatedAt;

  SocialMediaDetailsList(
      {this.id,
        this.restaurantId,
        this.socialMediaType,
        this.link,
        this.createdAt,
        this.updatedAt});

  SocialMediaDetailsList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    restaurantId = json['restaurantId'] ?? 0;
    socialMediaType = json['socialMediaType'] ?? '';
    link = json['link'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurantId'] = this.restaurantId;
    data['socialMediaType'] = this.socialMediaType;
    data['link'] = this.link;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
