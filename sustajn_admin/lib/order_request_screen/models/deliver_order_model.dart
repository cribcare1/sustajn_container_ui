class DeliverData {
  List<DeliverDataList>? data;
  String? message;
  String? status;

  DeliverData({this.data, this.message, this.status});

  DeliverData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeliverDataList>[];
      json['data'].forEach((v) {
        data!.add(new DeliverDataList.fromJson(v));
      });
    }
    message = json['message']??"";
    status = json['status']??"";
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

class DeliverDataList {
  int? id;
  String? requestNumber;
  String? requestType;
  String? restaurantName;
  String? containerCodes;
  String? formattedDateTime;
  int? totalQuantity;

  DeliverDataList(
      {this.id,
        this.requestNumber,
        this.requestType,
        this.restaurantName,
        this.containerCodes,
        this.formattedDateTime,
        this.totalQuantity});

  DeliverDataList.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    requestNumber = json['requestNumber']??"";
    requestType = json['requestType']??"";
    restaurantName = json['restaurantName']??"";
    containerCodes = json['containerCodes']??"";
    formattedDateTime = json['formattedDateTime']??"";
    totalQuantity = json['totalQuantity']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requestNumber'] = this.requestNumber;
    data['requestType'] = this.requestType;
    data['restaurantName'] = this.restaurantName;
    data['containerCodes'] = this.containerCodes;
    data['formattedDateTime'] = this.formattedDateTime;
    data['totalQuantity'] = this.totalQuantity;
    return data;
  }
}
