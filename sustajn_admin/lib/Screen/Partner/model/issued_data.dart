class IssuedData {
  List<Data>? data;
  String? message;
  String? status;

  IssuedData({this.data, this.message, this.status});

  IssuedData.fromJson(Map<String, dynamic> json) {
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
  String? monthYear;
  int? totalIssuedQuantity;
  List<DateWiseIssuedDetails>? dateWiseIssuedDetails;

  Data({this.monthYear, this.totalIssuedQuantity, this.dateWiseIssuedDetails});

  Data.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'];
    totalIssuedQuantity = json['totalIssuedQuantity'];
    if (json['dateWiseIssuedDetails'] != null) {
      dateWiseIssuedDetails = <DateWiseIssuedDetails>[];
      json['dateWiseIssuedDetails'].forEach((v) {
        dateWiseIssuedDetails!.add(new DateWiseIssuedDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    data['totalIssuedQuantity'] = this.totalIssuedQuantity;
    if (this.dateWiseIssuedDetails != null) {
      data['dateWiseIssuedDetails'] =
          this.dateWiseIssuedDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateWiseIssuedDetails {
  String? date;
  int? todayTotalIssuedQuantity;

  DateWiseIssuedDetails({this.date, this.todayTotalIssuedQuantity});

  DateWiseIssuedDetails.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    todayTotalIssuedQuantity = json['todayTotalIssuedQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['todayTotalIssuedQuantity'] = this.todayTotalIssuedQuantity;
    return data;
  }
}
