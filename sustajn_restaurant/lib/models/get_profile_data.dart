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
  String? customerId;
  String? emailId;
  String? profileImageUrl;
  int? subscriptionPlanId;
  BankDetailsResponse? bankDetailsResponse;
  CardDetailsResponse? cardDetailsResponse;
  PaymentGetWayResponse? paymentGetWayResponse;
  List<AddressResponses>? addressResponses;
  SubscriptionResponse? subscriptionResponse;

  Data(
      {this.id,
        this.fullName,
        this.mobileNumber,
        this.customerId,
        this.emailId,
        this.profileImageUrl,
        this.subscriptionPlanId,
        this.bankDetailsResponse,
        this.cardDetailsResponse,
        this.paymentGetWayResponse,
        this.addressResponses,
        this.subscriptionResponse});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    customerId = json['customerId'];
    emailId = json['emailId'];
    profileImageUrl = json['profileImageUrl'];
    subscriptionPlanId = json['subscriptionPlanId'];
    bankDetailsResponse = json['bankDetailsResponse'] != null
        ? new BankDetailsResponse.fromJson(json['bankDetailsResponse'])
        : null;
    cardDetailsResponse = json['cardDetailsResponse'] != null
        ? new CardDetailsResponse.fromJson(json['cardDetailsResponse'])
        : null;
    paymentGetWayResponse = json['paymentGetWayResponse'] != null
        ? new PaymentGetWayResponse.fromJson(json['paymentGetWayResponse'])
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['mobileNumber'] = this.mobileNumber;
    data['customerId'] = this.customerId;
    data['emailId'] = this.emailId;
    data['profileImageUrl'] = this.profileImageUrl;
    data['subscriptionPlanId'] = this.subscriptionPlanId;
    if (this.bankDetailsResponse != null) {
      data['bankDetailsResponse'] = this.bankDetailsResponse!.toJson();
    }
    if (this.cardDetailsResponse != null) {
      data['cardDetailsResponse'] = this.cardDetailsResponse!.toJson();
    }
    if (this.paymentGetWayResponse != null) {
      data['paymentGetWayResponse'] = this.paymentGetWayResponse!.toJson();
    }
    if (this.addressResponses != null) {
      data['addressResponses'] =
          this.addressResponses!.map((v) => v.toJson()).toList();
    }
    if (this.subscriptionResponse != null) {
      data['subscriptionResponse'] = this.subscriptionResponse!.toJson();
    }
    return data;
  }
}

class BankDetailsResponse {
  int? id;
  int? userId;
  String? bankName;
  String? accountNumber;
  String? iBanNumber;
  String? taxNumber;

  BankDetailsResponse(
      {this.id,
        this.userId,
        this.bankName,
        this.accountNumber,
        this.iBanNumber,
        this.taxNumber});

  BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    iBanNumber = json['iBanNumber'];
    taxNumber = json['taxNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['iBanNumber'] = this.iBanNumber;
    data['taxNumber'] = this.taxNumber;
    return data;
  }
}

class CardDetailsResponse {
  int? id;
  String? cardHolderName;
  String? cardNumber;
  String? expiryDate;

  CardDetailsResponse(
      {this.id, this.cardHolderName, this.cardNumber, this.expiryDate});

  CardDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardHolderName = json['cardHolderName'];
    cardNumber = json['cardNumber'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cardHolderName'] = this.cardHolderName;
    data['cardNumber'] = this.cardNumber;
    data['expiryDate'] = this.expiryDate;
    return data;
  }
}

class PaymentGetWayResponse {
  int? id;
  String? paymentGatewayId;
  String? paymentGatewayName;

  PaymentGetWayResponse(
      {this.id, this.paymentGatewayId, this.paymentGatewayName});

  PaymentGetWayResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentGatewayId = json['paymentGatewayId'];
    paymentGatewayName = json['paymentGatewayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentGatewayId'] = this.paymentGatewayId;
    data['paymentGatewayName'] = this.paymentGatewayName;
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
    id = json['id'];
    addressType = json['addressType'];
    flatDoorHouseDetails = json['flatDoorHouseDetails'];
    areaStreetCityBlockDetails = json['areaStreetCityBlockDetails'];
    poBoxOrPostalCode = json['poBoxOrPostalCode'];
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
    planId = json['planId'];
    planName = json['planName'];
    planType = json['planType'];
    description = json['description'];
    partnerType = json['partnerType'];
    feeType = json['feeType'];
    depositType = json['depositType'];
    commissionPercentage = json['commissionPercentage'];
    minContainers = json['minContainers'];
    maxContainers = json['maxContainers'];
    totalContainers = json['totalContainers'];
    includesDelivery = json['includesDelivery'];
    includesMarketing = json['includesMarketing'];
    includesAnalytics = json['includesAnalytics'];
    billingCycle = json['billingCycle'];
    planStatus = json['planStatus'];
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