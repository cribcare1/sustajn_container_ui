
class GetProfileData {
  Data? data;
  String? message;
  String? status;

  GetProfileData({this.data, this.message, this.status});

  GetProfileData.fromJson(Map<String, dynamic> json) {
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    _data["message"] = message;
    _data["status"] = status;
    return _data;
  }
}

class Data {
  int? id;
  String? fullName;
  String? mobileNumber;
  dynamic customerId;
  String? emailId;
  String? profileImageUrl;
  int? subscriptionPlanId;
  BankDetailsResponse? bankDetailsResponse;
  CardDetailsResponse? cardDetailsResponse;
  PaymentGetWayResponse? paymentGetWayResponse;
  List<AddressResponses>? addressResponses;
  SubscriptionResponse? subscriptionResponse;

  Data({this.id, this.fullName, this.mobileNumber, this.customerId, this.emailId, this.profileImageUrl, this.subscriptionPlanId, this.bankDetailsResponse, this.cardDetailsResponse, this.paymentGetWayResponse, this.addressResponses, this.subscriptionResponse});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["fullName"] is String) {
      fullName = json["fullName"];
    }
    if(json["mobileNumber"] is String) {
      mobileNumber = json["mobileNumber"];
    }
    customerId = json["customerId"];
    if(json["emailId"] is String) {
      emailId = json["emailId"];
    }
    profileImageUrl = json["profileImageUrl"];
    if(json["subscriptionPlanId"] is int) {
      subscriptionPlanId = json["subscriptionPlanId"];
    }
    if(json["bankDetailsResponse"] is Map) {
      bankDetailsResponse = json["bankDetailsResponse"] == null ? null : BankDetailsResponse.fromJson(json["bankDetailsResponse"]);
    }
    if(json["cardDetailsResponse"] is Map) {
      cardDetailsResponse = json["cardDetailsResponse"] == null ? null : CardDetailsResponse.fromJson(json["cardDetailsResponse"]);
    }
    if(json["paymentGetWayResponse"] is Map) {
      paymentGetWayResponse = json["paymentGetWayResponse"] == null ? null : PaymentGetWayResponse.fromJson(json["paymentGetWayResponse"]);
    }
    if(json["addressResponses"] is List) {
      addressResponses = json["addressResponses"] == null ? null : (json["addressResponses"] as List).map((e) => AddressResponses.fromJson(e)).toList();
    }
    if(json["subscriptionResponse"] is Map) {
      subscriptionResponse = json["subscriptionResponse"] == null ? null : SubscriptionResponse.fromJson(json["subscriptionResponse"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["fullName"] = fullName;
    _data["mobileNumber"] = mobileNumber;
    _data["customerId"] = customerId;
    _data["emailId"] = emailId;
    _data["profileImageUrl"] = profileImageUrl;
    _data["subscriptionPlanId"] = subscriptionPlanId;
    if(bankDetailsResponse != null) {
      _data["bankDetailsResponse"] = bankDetailsResponse?.toJson();
    }
    if(cardDetailsResponse != null) {
      _data["cardDetailsResponse"] = cardDetailsResponse?.toJson();
    }
    if(paymentGetWayResponse != null) {
      _data["paymentGetWayResponse"] = paymentGetWayResponse?.toJson();
    }
    if(addressResponses != null) {
      _data["addressResponses"] = addressResponses?.map((e) => e.toJson()).toList();
    }
    if(subscriptionResponse != null) {
      _data["subscriptionResponse"] = subscriptionResponse?.toJson();
    }
    return _data;
  }
}

class SubscriptionResponse {
  int? planId;
  String? planName;
  String? planType;
  String? description;
  String? partnerType;
  int? feeType;
  int? depositType;
  int? commissionPercentage;
  int? minContainers;
  int? maxContainers;
  int? totalContainers;
  bool? includesDelivery;
  bool? includesMarketing;
  bool? includesAnalytics;
  String? billingCycle;
  String? planStatus;

  SubscriptionResponse({this.planId, this.planName, this.planType, this.description, this.partnerType, this.feeType, this.depositType, this.commissionPercentage, this.minContainers, this.maxContainers, this.totalContainers, this.includesDelivery, this.includesMarketing, this.includesAnalytics, this.billingCycle, this.planStatus});

  SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    if(json["planId"] is int) {
      planId = json["planId"];
    }
    if(json["planName"] is String) {
      planName = json["planName"];
    }
    if(json["planType"] is String) {
      planType = json["planType"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["partnerType"] is String) {
      partnerType = json["partnerType"];
    }
    if(json["feeType"] is int) {
      feeType = json["feeType"];
    }
    if(json["depositType"] is int) {
      depositType = json["depositType"];
    }
    if(json["commissionPercentage"] is int) {
      commissionPercentage = json["commissionPercentage"];
    }
    if(json["minContainers"] is int) {
      minContainers = json["minContainers"];
    }
    if(json["maxContainers"] is int) {
      maxContainers = json["maxContainers"];
    }
    if(json["totalContainers"] is int) {
      totalContainers = json["totalContainers"];
    }
    if(json["includesDelivery"] is bool) {
      includesDelivery = json["includesDelivery"];
    }
    if(json["includesMarketing"] is bool) {
      includesMarketing = json["includesMarketing"];
    }
    if(json["includesAnalytics"] is bool) {
      includesAnalytics = json["includesAnalytics"];
    }
    if(json["billingCycle"] is String) {
      billingCycle = json["billingCycle"];
    }
    if(json["planStatus"] is String) {
      planStatus = json["planStatus"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["planId"] = planId;
    _data["planName"] = planName;
    _data["planType"] = planType;
    _data["description"] = description;
    _data["partnerType"] = partnerType;
    _data["feeType"] = feeType;
    _data["depositType"] = depositType;
    _data["commissionPercentage"] = commissionPercentage;
    _data["minContainers"] = minContainers;
    _data["maxContainers"] = maxContainers;
    _data["totalContainers"] = totalContainers;
    _data["includesDelivery"] = includesDelivery;
    _data["includesMarketing"] = includesMarketing;
    _data["includesAnalytics"] = includesAnalytics;
    _data["billingCycle"] = billingCycle;
    _data["planStatus"] = planStatus;
    return _data;
  }
}

class AddressResponses {
  int? id;
  String? addressType;
  String? flatDoorHouseDetails;
  String? areaStreetCityBlockDetails;
  String? poBoxOrPostalCode;

  AddressResponses({this.id, this.addressType, this.flatDoorHouseDetails, this.areaStreetCityBlockDetails, this.poBoxOrPostalCode});

  AddressResponses.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["addressType"] is String) {
      addressType = json["addressType"];
    }
    if(json["flatDoorHouseDetails"] is String) {
      flatDoorHouseDetails = json["flatDoorHouseDetails"];
    }
    if(json["areaStreetCityBlockDetails"] is String) {
      areaStreetCityBlockDetails = json["areaStreetCityBlockDetails"];
    }
    if(json["poBoxOrPostalCode"] is String) {
      poBoxOrPostalCode = json["poBoxOrPostalCode"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["addressType"] = addressType;
    _data["flatDoorHouseDetails"] = flatDoorHouseDetails;
    _data["areaStreetCityBlockDetails"] = areaStreetCityBlockDetails;
    _data["poBoxOrPostalCode"] = poBoxOrPostalCode;
    return _data;
  }
}

class PaymentGetWayResponse {
  int? id;
  String? paymentGatewayId;
  String? paymentGatewayName;

  PaymentGetWayResponse({this.id, this.paymentGatewayId, this.paymentGatewayName});

  PaymentGetWayResponse.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["paymentGatewayId"] is String) {
      paymentGatewayId = json["paymentGatewayId"];
    }
    if(json["paymentGatewayName"] is String) {
      paymentGatewayName = json["paymentGatewayName"];
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
      id = json["id"];
    }
    if(json["cardHolderName"] is String) {
      cardHolderName = json["cardHolderName"];
    }
    if(json["cardNumber"] is String) {
      cardNumber = json["cardNumber"];
    }
    if(json["expiryDate"] is String) {
      expiryDate = json["expiryDate"];
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

  BankDetailsResponse({this.id, this.userId, this.bankName, this.accountNumber, this.iBanNumber, this.taxNumber});

  BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["userId"] is int) {
      userId = json["userId"];
    }
    if(json["bankName"] is String) {
      bankName = json["bankName"];
    }
    if(json["accountNumber"] is String) {
      accountNumber = json["accountNumber"];
    }
    if(json["iBanNumber"] is String) {
      iBanNumber = json["iBanNumber"];
    }
    if(json["taxNumber"] is String) {
      taxNumber = json["taxNumber"];
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
    return _data;
  }
}