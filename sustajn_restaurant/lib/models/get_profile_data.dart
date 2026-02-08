class GetProfileData {
  Data? data;
  String? message;
  String? status;

  GetProfileData({this.data, this.message, this.status});

  GetProfileData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (data != null) {
      map['data'] = data!.toJson();
    }
    map['message'] = message;
    map['status'] = status;
    return map;
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

  Data({
    this.id,
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
    this.businessDetailsResponse,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    secondaryNumber = json['secondaryNumber'];
    dateOfBirth = json['dateOfBirth'];
    customerId = json['customerId'];
    emailId = json['emailId'];
    profileImageUrl = json['profileImageUrl'];
    subscriptionPlanId = json['subscriptionPlanId'];

    bankDetailsResponse = json['bankDetailsResponse'] != null
        ? BankDetailsResponse.fromJson(
        json['bankDetailsResponse'] as Map<String, dynamic>)
        : null;

    cardDetailsResponse = json['cardDetailsResponse'] != null
        ? CardDetailsResponse.fromJson(
        json['cardDetailsResponse'] as Map<String, dynamic>)
        : null;

    paymentGetWayResponse = json['paymentGetWayResponse'] != null
        ? PaymentGetWayResponse.fromJson(
        json['paymentGetWayResponse'] as Map<String, dynamic>)
        : null;

    if (json['addressResponses'] != null) {
      addressResponses = (json['addressResponses'] as List)
          .map((e) => AddressResponses.fromJson(e))
          .toList();
    }

    subscriptionResponse = json['subscriptionResponse'] != null
        ? SubscriptionResponse.fromJson(json['subscriptionResponse'])
        : null;

    contactAndRegistrationDetailsResponse =
    json['contactAndRegistrationDetailsResponse'] != null
        ? ContactAndRegistrationDetailsResponse.fromJson(
        json['contactAndRegistrationDetailsResponse'])
        : null;

    if (json['socialMediaResponse'] != null) {
      socialMediaResponse = (json['socialMediaResponse'] as List)
          .map((e) => SocialMediaResponse.fromJson(e))
          .toList();
    }

    businessDetailsResponse = json['businessDetailsResponse'] != null
        ? BusinessDetailsResponse.fromJson(json['businessDetailsResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['fullName'] = fullName;
    map['mobileNumber'] = mobileNumber;
    map['secondaryNumber'] = secondaryNumber;
    map['dateOfBirth'] = dateOfBirth;
    map['customerId'] = customerId;
    map['emailId'] = emailId;
    map['profileImageUrl'] = profileImageUrl;
    map['subscriptionPlanId'] = subscriptionPlanId;

    map['bankDetailsResponse'] = bankDetailsResponse?.toJson();
    map['cardDetailsResponse'] = cardDetailsResponse?.toJson();
    map['paymentGetWayResponse'] = paymentGetWayResponse?.toJson();

    if (addressResponses != null) {
      map['addressResponses'] =
          addressResponses!.map((e) => e.toJson()).toList();
    }

    map['subscriptionResponse'] = subscriptionResponse?.toJson();
    map['contactAndRegistrationDetailsResponse'] =
        contactAndRegistrationDetailsResponse?.toJson();

    if (socialMediaResponse != null) {
      map['socialMediaResponse'] =
          socialMediaResponse!.map((e) => e.toJson()).toList();
    }

    map['businessDetailsResponse'] = businessDetailsResponse?.toJson();
    return map;
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
        this.planStatus});

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

class BankDetailsResponse {
  int? id;
  int? userId;
  String? bankName;
  String? accountNumber;
  String? iBanNumber;
  String? taxNumber;
  String? emailId;

  BankDetailsResponse({this.id, this.userId, this.bankName, this.accountNumber, this.iBanNumber, this.taxNumber, this.emailId});

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
    if(json["accountNumber"] is String) {
      accountNumber = json["accountNumber"] ?? "";
    }
    if(json["iBanNumber"] is String) {
      iBanNumber = json["iBanNumber"] ?? "";
    }
    if(json["taxNumber"] is String) {
      taxNumber = json["taxNumber"] ?? "";
    }
    if(json["email"] is String) {
      emailId = json["email"] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["userId"] = userId;
    _data["bankName"] = bankName;
    _data["accountNumber"] = accountNumber;
    _data["iBanNumber"] = iBanNumber;
    _data["taxNumber"] = taxNumber;
    _data["email"] = emailId;
    return _data;
  }
}

