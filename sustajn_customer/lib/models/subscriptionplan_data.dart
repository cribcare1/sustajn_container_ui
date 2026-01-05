class SubscriptionModel {
  List<Data>? data;
  String? message;
  String? status;

  SubscriptionModel({this.data, this.message, this.status});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? planId;
  String? planName;
  String? planStatus;
  int? totalContainers;
  String? billingCycle;

  Data(
      {this.planId,
        this.planName,
        this.planStatus,
        this.totalContainers,
        this.billingCycle});

  Data.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    planName = json['planName'];
    planStatus = json['planStatus'];
    totalContainers = json['totalContainers'];
    billingCycle = json['billingCycle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planId'] = this.planId;
    data['planName'] = this.planName;
    data['planStatus'] = this.planStatus;
    data['totalContainers'] = this.totalContainers;
    data['billingCycle'] = this.billingCycle;
    return data;
  }
}
