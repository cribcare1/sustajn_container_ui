class UsersData {
  List<CustomersData>? customersData;
  int? size;
  int? totalPages;
  int? page;
  String? status;
  int? totalElements;

  UsersData(
      {this.customersData,
        this.size,
        this.totalPages,
        this.page,
        this.status,
        this.totalElements});

  UsersData.fromJson(Map<String, dynamic> json) {
    if (json['customersData'] != null) {
      customersData = <CustomersData>[];
      json['customersData'].forEach((v) {
        customersData!.add(new CustomersData.fromJson(v));
      });
    }
    size = json['size'];
    totalPages = json['totalPages'];
    page = json['page'];
    status = json['status'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customersData != null) {
      data['customersData'] =
          this.customersData!.map((v) => v.toJson()).toList();
    }
    data['size'] = this.size;
    data['totalPages'] = this.totalPages;
    data['page'] = this.page;
    data['status'] = this.status;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class CustomersData {
  int? id;
  String? email;
  String? mobile;
  String? fullName;
  String? profileImage;
  int? borrowedCount;
  int? returnedCount;
  int? pendingCount;
  SubscriptionPlan? subscriptionPlan;
  List<Addresses>? addresses;

  CustomersData(
      {this.id,
        this.email,
        this.mobile,
        this.fullName,
        this.profileImage,
        this.borrowedCount,
        this.returnedCount,
        this.pendingCount,
        this.subscriptionPlan,
        this.addresses});

  CustomersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    mobile = json['mobile'];
    fullName = json['fullName'];
    profileImage = json['profileImage'];
    borrowedCount = json['borrowedCount'];
    returnedCount = json['returnedCount'];
    pendingCount = json['pendingCount'];
    subscriptionPlan = json['subscriptionPlan'] != null
        ? new SubscriptionPlan.fromJson(json['subscriptionPlan'])
        : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['fullName'] = this.fullName;
    data['profileImage'] = this.profileImage;
    data['borrowedCount'] = this.borrowedCount;
    data['returnedCount'] = this.returnedCount;
    data['pendingCount'] = this.pendingCount;
    if (this.subscriptionPlan != null) {
      data['subscriptionPlan'] = this.subscriptionPlan!.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscriptionPlan {
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

  SubscriptionPlan(
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
        this.updatedAt});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
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

class Addresses {
  int? id;
  String? addressType;
  String? flatDoorHouseDetails;
  String? areaStreetCityBlockDetails;
  String? poBoxOrPostalCode;
  String? fullAddress;

  Addresses(
      {this.id,
        this.addressType,
        this.flatDoorHouseDetails,
        this.areaStreetCityBlockDetails,
        this.poBoxOrPostalCode});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['addressType']?? "";
    flatDoorHouseDetails = json['flatDoorHouseDetails']?? "";
    areaStreetCityBlockDetails = json['areaStreetCityBlockDetails']?? "";
    poBoxOrPostalCode = json['poBoxOrPostalCode']?? "";
    fullAddress = flatDoorHouseDetails! + areaStreetCityBlockDetails! + poBoxOrPostalCode!;
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
