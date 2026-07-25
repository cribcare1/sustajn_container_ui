class SubscriptionData {
  List<SubscriptionDataList>? data;
  String? message;
  String? status;

  SubscriptionData({this.data, this.message, this.status});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SubscriptionDataList>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionDataList.fromJson(v));
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

class SubscriptionDataList {
  String? monthYear;
  double? monthWiseTotalSusbcriptionAmount;
  List<DateWiseSubscription>? dateWiseSubscription;

  SubscriptionDataList(
      {this.monthYear,
        this.monthWiseTotalSusbcriptionAmount,
        this.dateWiseSubscription});

  SubscriptionDataList.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'];
    monthWiseTotalSusbcriptionAmount = json['monthWiseTotalSusbcriptionAmount'];
    if (json['dateWiseSubscription'] != null) {
      dateWiseSubscription = <DateWiseSubscription>[];
      json['dateWiseSubscription'].forEach((v) {
        dateWiseSubscription!.add(new DateWiseSubscription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['monthWiseTotalSusbcriptionAmount'] =
        this.monthWiseTotalSusbcriptionAmount;
    if (this.dateWiseSubscription != null) {
      data['dateWiseSubscription'] =
          this.dateWiseSubscription!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateWiseSubscription {
  int? id;
  String? name;
  String? userType;
  String? restaurantAddress;
  String? planType;
  double? amount;
  String? formattedDate;

  DateWiseSubscription(
      {this.id,
        this.name,
        this.userType,
        this.restaurantAddress,
        this.planType,
        this.amount,
        this.formattedDate});

  DateWiseSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id']?? 0;
    name = json['name']?? '';
    userType = json['userType']?? '';
    restaurantAddress = json['restaurantAddress']?? '';
    planType = json['planType']?? '';
    amount = json['amount']?? 0.0;
    formattedDate = json['formattedDate']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['userType'] = this.userType;
    data['restaurantAddress'] = this.restaurantAddress;
    data['planType'] = this.planType;
    data['amount'] = this.amount;
    data['formattedDate'] = this.formattedDate;
    return data;
  }
}