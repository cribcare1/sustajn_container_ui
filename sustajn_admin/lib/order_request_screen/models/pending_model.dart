class PendingData {
  List<PendingDataList>? data;
  String? message;
  String? status;

  PendingData({this.data, this.message, this.status});

  PendingData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PendingDataList>[];
      json['data'].forEach((v) {
        data!.add(new PendingDataList.fromJson(v));
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

class PendingDataList {
  int? id;
  String? requestNumber;
  String? requestType;
  String? restaurantName;
  String? containerCodes;
  String? formattedDateTime;
  int? totalQuantity;
  List<String>? imageUrls;

  PendingDataList(
      {this.id,
        this.requestNumber,
        this.requestType,
        this.restaurantName,
        this.containerCodes,
        this.formattedDateTime,
        this.totalQuantity,
        this.imageUrls});

  PendingDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestNumber = json['requestNumber'];
    requestType = json['requestType'];
    restaurantName = json['restaurantName'];
    containerCodes = json['containerCodes'];
    formattedDateTime = json['formattedDateTime'];
    totalQuantity = json['totalQuantity'];
    imageUrls = json['imageUrls'].cast<String>();
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
    data['imageUrls'] = this.imageUrls;
    return data;
  }
}
