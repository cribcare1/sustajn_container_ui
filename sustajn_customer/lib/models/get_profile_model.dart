class GetProfileModel {
  ProfileData? data;
  String? message;
  String? status;

  GetProfileModel({this.data, this.message, this.status});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
    message = json['message']??"";
    status = json['status']??"";
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

class ProfileData {
  int? id;
  String? fullName;
  String? mobileNumber;
  String? secondaryNumber;
  String? dateOfBirth;
  String? customerId;
  String? emailId;
  String? profileImageUrl;
  int? subscriptionPlanId;

  BankDetailsResponse? bankDetailsResponse;
  dynamic cardDetailsResponse;
  dynamic paymentGetWayResponse;

  List<AddressResponses>? addressResponses;
  SubscriptionResponse? subscriptionResponse;

  ProfileData({
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
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    fullName = json['fullName']??"";
    mobileNumber = json['mobileNumber']??"";
    secondaryNumber = json['secondaryNumber']??"";
    dateOfBirth = json['dateOfBirth']??"";
    customerId = json['customerId']??"";
    emailId = json['emailId']??"";
    profileImageUrl = json['profileImageUrl']??"";
    subscriptionPlanId = json['subscriptionPlanId']??0;

    bankDetailsResponse = json['bankDetailsResponse'] != null
        ? BankDetailsResponse.fromJson(json['bankDetailsResponse'])
        : null;

    cardDetailsResponse = json['cardDetailsResponse'];
    paymentGetWayResponse = json['paymentGetWayResponse'];

    if (json['addressResponses'] != null) {
      addressResponses = <AddressResponses>[];
      json['addressResponses'].forEach((v) {
        addressResponses!.add(AddressResponses.fromJson(v));
      });
    }

    subscriptionResponse = json['subscriptionResponse'] != null
        ? SubscriptionResponse.fromJson(json['subscriptionResponse'])
        : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['fullName'] = fullName;
    data['mobileNumber'] = mobileNumber;
    data['secondaryNumber'] = secondaryNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['customerId'] = customerId;
    data['emailId'] = emailId;
    data['profileImageUrl'] = profileImageUrl;
    data['subscriptionPlanId'] = subscriptionPlanId;

    if (bankDetailsResponse != null) {
      data['bankDetailsResponse'] = bankDetailsResponse!.toJson();
    }

    if (cardDetailsResponse != null) {
      data['cardDetailsResponse'] = cardDetailsResponse!.toJson();
    }

    if (paymentGetWayResponse != null) {
      data['paymentGetWayResponse'] = paymentGetWayResponse!.toJson();
    }

    if (addressResponses != null) {
      data['addressResponses'] =
          addressResponses!.map((v) => v.toJson()).toList();
    }

    if (subscriptionResponse != null) {
      data['subscriptionResponse'] = subscriptionResponse!.toJson();
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

  BankDetailsResponse(
      {this.id,
        this.userId,
        this.bankName,
        this.accountHolderName,
        this.iBanNumber,
        this.bicNumber});

  BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    userId = json['userId']??0;
    bankName = json['bankName']??"";
    accountHolderName = json['accountHolderName']??"";
    iBanNumber = json['iBanNumber']??"";
    bicNumber = json['bicNumber']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['bankName'] = this.bankName;
    data['accountHolderName'] = this.accountHolderName;
    data['iBanNumber'] = this.iBanNumber;
    data['bicNumber'] = this.bicNumber;
    return data;
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
    id = json['id']??0;
    addressType = json['addressType']??"";
    flatDoorHouseDetails = json['flatDoorHouseDetails']??"";
    areaStreetCityBlockDetails = json['areaStreetCityBlockDetails']??"";
    poBoxOrPostalCode = json['poBoxOrPostalCode']??"";
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
    planId = json['planId']??0;
    planName = json['planName']??"";
    planType = json['planType']??"";
    description = json['description']??"";
    partnerType = json['partnerType']??"";
    feeType = json['feeType']??0;
    depositType = json['depositType']??0;
    commissionPercentage = json['commissionPercentage']??0;
    minContainers = json['minContainers']??0;
    maxContainers = json['maxContainers']??0;
    totalContainers = json['totalContainers']??0;
    includesDelivery = json['includesDelivery']??false;
    includesMarketing = json['includesMarketing']??false;
    includesAnalytics = json['includesAnalytics']??false;
    billingCycle = json['billingCycle']??"";
    planStatus = json['planStatus']??"";
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
