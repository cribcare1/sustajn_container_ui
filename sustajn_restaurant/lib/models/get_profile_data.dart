class GetProfileData {
  Data? data;
  String? message;
  String? status;

  GetProfileData({this.data, this.message, this.status});

  GetProfileData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
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
  String? dateOfBirth;
  dynamic customerId;
  String? emailId;
  String? profileImageUrl;
  int? subscriptionPlanId;
  BankDetailsResponse? bankDetailsResponse;
  CardDetailsResponse? cardDetailsResponse;
  PaymentGetWayResponse? paymentGetWayResponse;
  List<AddressResponses>? addressResponses;
  SubscriptionResponse? subscriptionResponse;
  ContactAndRegistrationDetailsResponse? contactAndRegistrationDetailsResponse;
  List<SocialMediaResponse>? socialMediaResponse;
  BusinessDetailsResponse? businessDetailsResponse;

  Data(
      {this.id,
        this.fullName,
        this.mobileNumber,
        this.secondaryNumber,
        this.dateOfBirth,
        this.customerId,
        this.emailId,
        this.profileImageUrl,
        this.subscriptionPlanId,
        this.bankDetailsResponse,
        this.cardDetailsResponse,
        this.paymentGetWayResponse,
        this.addressResponses,
        this.subscriptionResponse,
        this.contactAndRegistrationDetailsResponse,
        this.socialMediaResponse,
        this.businessDetailsResponse});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    fullName = json['fullName'] ?? "";
    mobileNumber = json['mobileNumber'] ?? "";
    secondaryNumber = json['secondaryNumber'] ?? "";
    dateOfBirth = json['dateOfBirth'] ?? "";
    customerId = json['customerId'] ?? "";
    emailId = json['emailId'] ?? "";
    profileImageUrl = json['profileImageUrl'] ?? "";
    subscriptionPlanId = json['subscriptionPlanId'] ?? 0;
    bankDetailsResponse = json['bankDetailsResponse'] != null
        ? BankDetailsResponse.fromJson(json['bankDetailsResponse'])
        : null;

    cardDetailsResponse = json['cardDetailsResponse'] != null
        ? CardDetailsResponse.fromJson(json['cardDetailsResponse'])
        : null;

    paymentGetWayResponse = json['paymentGetWayResponse'] != null
        ? PaymentGetWayResponse.fromJson(json['paymentGetWayResponse'])
        : null;
    if (json['addressResponses'] != null) {
      addressResponses = <AddressResponses>[];
      json['addressResponses'].forEach((v) {
        addressResponses!.add(new AddressResponses.fromJson(v));
      });
    }
    subscriptionResponse = json['subscriptionResponse'] != null
        ? new SubscriptionResponse.fromJson(json['subscriptionResponse'])
        : null;
    contactAndRegistrationDetailsResponse =
    json['contactAndRegistrationDetailsResponse'] != null
        ? new ContactAndRegistrationDetailsResponse.fromJson(
        json['contactAndRegistrationDetailsResponse'])
        : null;
    if (json['socialMediaResponse'] != null) {
      socialMediaResponse = <SocialMediaResponse>[];
      json['socialMediaResponse'].forEach((v) {
        socialMediaResponse!.add(new SocialMediaResponse.fromJson(v));
      });
    }
    businessDetailsResponse = json['businessDetailsResponse'] != null
        ? new BusinessDetailsResponse.fromJson(json['businessDetailsResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['mobileNumber'] = this.mobileNumber;
    data['secondaryNumber'] = this.secondaryNumber;
    data['dateOfBirth'] = this.dateOfBirth;
    data['customerId'] = this.customerId;
    data['emailId'] = this.emailId;
    data['profileImageUrl'] = this.profileImageUrl;
    data['subscriptionPlanId'] = this.subscriptionPlanId;
    data['bankDetailsResponse'] = this.bankDetailsResponse;
    data['cardDetailsResponse'] = this.cardDetailsResponse;
    data['paymentGetWayResponse'] = this.paymentGetWayResponse;
    if (this.addressResponses != null) {
      data['addressResponses'] =
          this.addressResponses!.map((v) => v.toJson()).toList();
    }
    if (this.subscriptionResponse != null) {
      data['subscriptionResponse'] = this.subscriptionResponse!.toJson();
    }
    if (this.contactAndRegistrationDetailsResponse != null) {
      data['contactAndRegistrationDetailsResponse'] =
          this.contactAndRegistrationDetailsResponse!.toJson();
    }
    if (this.socialMediaResponse != null) {
      data['socialMediaResponse'] =
          this.socialMediaResponse!.map((v) => v.toJson()).toList();
    }
    if (this.businessDetailsResponse != null) {
      data['businessDetailsResponse'] = this.businessDetailsResponse!.toJson();
    }
    return data;
  }
}

class BankDetailsResponse {
  int? id;
  int? userId;
  String? bankName;
  String? accountHolderName;
  String? iBanNumber;
  String? bicNumber;

  BankDetailsResponse({this.id, this.userId, this.bankName, this.accountHolderName, this.iBanNumber, this.bicNumber});

  BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"] ?? 0;
    }
    if(json["userId"] is int) {
      userId = json["userId"] ?? 0;
    }
    if(json["bankName"] is String) {
      bankName = json["bankName"] ?? "";
    }
    if(json["accountHolderName"] is String) {
      accountHolderName = json["accountHolderName"] ?? "";
    }
    if(json["iBanNumber"] is String) {
      iBanNumber = json["iBanNumber"] ?? "";
    }
    if(json["bicNumber"] is String) {
      bicNumber = json["bicNumber"] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["userId"] = userId;
    _data["bankName"] = bankName;
    _data["accountHolderName"] = accountHolderName;
    _data["iBanNumber"] = iBanNumber;
    _data["bicNumber"] = bicNumber;
    return _data;
  }
}

class AddressResponses {
  int? id;
  String? addressType;
  String? flatDoorHouseDetails;
  String? areaStreetCityBlockDetails;
  String? poBoxOrPostalCode;

  AddressResponses(
      {this.id,
        this.addressType,
        this.flatDoorHouseDetails,
        this.areaStreetCityBlockDetails,
        this.poBoxOrPostalCode});

  AddressResponses.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    addressType = json['addressType'] ?? "";
    flatDoorHouseDetails = json['flatDoorHouseDetails'] ?? "";
    areaStreetCityBlockDetails = json['areaStreetCityBlockDetails'] ?? "";
    poBoxOrPostalCode = json['poBoxOrPostalCode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressType'] = this.addressType;
    data['flatDoorHouseDetails'] = this.flatDoorHouseDetails;
    data['areaStreetCityBlockDetails'] = this.areaStreetCityBlockDetails;
    data['poBoxOrPostalCode'] = this.poBoxOrPostalCode;
    return data;
  }
}

class SubscriptionResponse {
  int? planId;
  String? planName;
  String? planType;
  String? description;
  String? partnerType;
  double? feeType;
  double? depositType;
  double? commissionPercentage;
  int? minContainers;
  int? maxContainers;
  int? totalContainers;
  bool? includesDelivery;
  bool? includesMarketing;
  bool? includesAnalytics;
  String? billingCycle;
  String? planStatus;
  String? userType;
  String? createdAt;
  String? updatedAt;

  SubscriptionResponse(
      {this.planId,
        this.planName,
        this.planType,
        this.description,
        this.partnerType,
        this.feeType,
        this.depositType,
        this.commissionPercentage,
        this.minContainers,
        this.maxContainers,
        this.totalContainers,
        this.includesDelivery,
        this.includesMarketing,
        this.includesAnalytics,
        this.billingCycle,
        this.planStatus,
        this.userType,
        this.createdAt,
        this.updatedAt
      });

  SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    planId = json['planId'] ?? 0;
    planName = json['planName'] ?? "";
    planType = json['planType'] ?? "";
    description = json['description'] ?? "";
    partnerType = json['partnerType'] ?? "";
    feeType = json['feeType'] ?? 0.0;
    depositType = json['depositType'] ?? 0.0;
    commissionPercentage = json['commissionPercentage'] ?? 0.0;
    minContainers = json['minContainers'] ?? 0;
    maxContainers = json['maxContainers'] ?? 0;
    totalContainers = json['totalContainers'] ?? 0;
    includesDelivery = json['includesDelivery'] ?? false;
    includesMarketing = json['includesMarketing'] ?? false;
    includesAnalytics = json['includesAnalytics'] ?? false;
    billingCycle = json['billingCycle'] ?? "";
    planStatus = json['planStatus'] ?? "";
    userType = json['userType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planId'] = this.planId;
    data['planName'] = this.planName;
    data['planType'] = this.planType;
    data['description'] = this.description;
    data['partnerType'] = this.partnerType;
    data['feeType'] = this.feeType;
    data['depositType'] = this.depositType;
    data['commissionPercentage'] = this.commissionPercentage;
    data['minContainers'] = this.minContainers;
    data['maxContainers'] = this.maxContainers;
    data['totalContainers'] = this.totalContainers;
    data['includesDelivery'] = this.includesDelivery;
    data['includesMarketing'] = this.includesMarketing;
    data['includesAnalytics'] = this.includesAnalytics;
    data['billingCycle'] = this.billingCycle;
    data['planStatus'] = this.planStatus;
    data['userType'] = this.userType;
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
    contactPersonName = json['contactPersonName'] ?? "";
    contactEmail = json['contactEmail'] ?? "";
    treadLicenseNumber = json['treadLicenseNumber'] ?? "";
    vatNumber = json['vatNumber'] ?? "";
    contactNumber = json['contactNumber'] ?? "";
    registrationNumber = json['registrationNumber'] ?? "";
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

class SocialMediaResponse {
  int? id;
  String? socialMediaType;
  String? link;

  SocialMediaResponse({this.id, this.socialMediaType, this.link});

  SocialMediaResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    socialMediaType = json['socialMediaType'] ?? "";
    link = json['link'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['socialMediaType'] = this.socialMediaType;
    data['link'] = this.link;
    return data;
  }
}

class BusinessDetailsResponse {
  int? id;
  String? businessType;
  String? website;

  BusinessDetailsResponse({this.id, this.businessType, this.website});

  BusinessDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    businessType = json['businessType'] ?? "";
    website = json['website'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['businessType'] = this.businessType;
    data['website'] = this.website;
    return data;
  }
}
class PaymentGetWayResponse {
  int? id;
  String? paymentGatewayId;
  String? paymentGatewayName;

  PaymentGetWayResponse({this.id, this.paymentGatewayId, this.paymentGatewayName});

  PaymentGetWayResponse.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"] ?? 0;
    }
    if(json["paymentGatewayId"] is String) {
      paymentGatewayId = json["paymentGatewayId"] ?? "";
    }
    if(json["paymentGatewayName"] is String) {
      paymentGatewayName = json["paymentGatewayName"] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["paymentGatewayId"] = paymentGatewayId;
    _data["paymentGatewayName"] = paymentGatewayName;
    return _data;
  }
}

class CardDetailsResponse {
  int? id;
  String? cardHolderName;
  String? cardNumber;
  String? expiryDate;

  CardDetailsResponse({this.id, this.cardHolderName, this.cardNumber, this.expiryDate});

  CardDetailsResponse.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"] ?? 0;
    }
    if(json["cardHolderName"] is String) {
      cardHolderName = json["cardHolderName"] ?? "";
    }
    if(json["cardNumber"] is String) {
      cardNumber = json["cardNumber"] ?? "";
    }
    if(json["expiryDate"] is String) {
      expiryDate = json["expiryDate"] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["cardHolderName"] = cardHolderName;
    _data["cardNumber"] = cardNumber;
    _data["expiryDate"] = expiryDate;
    return _data;
  }
}