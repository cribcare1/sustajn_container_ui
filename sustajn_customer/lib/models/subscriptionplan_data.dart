class SubscriptionModel {
  List<SubscriptionData>? data;
  String? message;
  String? status;

  SubscriptionModel({this.data, this.message, this.status});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SubscriptionData>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class SubscriptionData {
  String? billingCycle;
  double? commissionPercentage;
  String? createdAt;
  double? depositType;
  String? description;
  double? feeType;
  bool? includesAnalytics;
  bool? includesDelivery;
  bool? includesMarketing;
  int? maxContainers;
  int? minContainers;
  String? partnerType;
  String? planFor;
  int? planId;
  String? planName;
  String? planStatus;
  String? planType;
  int? totalContainers;
  String? updatedAt;

  SubscriptionData(
      {this.billingCycle,
        this.commissionPercentage,
        this.createdAt,
        this.depositType,
        this.description,
        this.feeType,
        this.includesAnalytics,
        this.includesDelivery,
        this.includesMarketing,
        this.maxContainers,
        this.minContainers,
        this.partnerType,
        this.planFor,
        this.planId,
        this.planName,
        this.planStatus,
        this.planType,
        this.totalContainers,
        this.updatedAt});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    billingCycle = json['billingCycle'];
    commissionPercentage = json['commissionPercentage'];
    createdAt = json['createdAt'];
    depositType = json['depositType'];
    description = json['description'];
    feeType = json['feeType'];
    includesAnalytics = json['includesAnalytics'];
    includesDelivery = json['includesDelivery'];
    includesMarketing = json['includesMarketing'];
    maxContainers = json['maxContainers'];
    minContainers = json['minContainers'];
    partnerType = json['partnerType'];
    planFor = json['planFor'];
    planId = json['planId'] is int
        ? json['planId']
        : (json['planId'] as num?)?.toInt();
    planName = json['planName'];
    planStatus = json['planStatus'];
    planType = json['planType'];
    totalContainers = json['totalContainers'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billingCycle'] = this.billingCycle;
    data['commissionPercentage'] = this.commissionPercentage;
    data['createdAt'] = this.createdAt;
    data['depositType'] = this.depositType;
    data['description'] = this.description;
    data['feeType'] = this.feeType;
    data['includesAnalytics'] = this.includesAnalytics;
    data['includesDelivery'] = this.includesDelivery;
    data['includesMarketing'] = this.includesMarketing;
    data['maxContainers'] = this.maxContainers;
    data['minContainers'] = this.minContainers;
    data['partnerType'] = this.partnerType;
    data['planFor'] = this.planFor;
    data['planId'] = this.planId;
    data['planName'] = this.planName;
    data['planStatus'] = this.planStatus;
    data['planType'] = this.planType;
    data['totalContainers'] = this.totalContainers;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
