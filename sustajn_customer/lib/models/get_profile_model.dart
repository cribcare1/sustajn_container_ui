class GetProfileModel {
  Data? data;
  String? message;
  String? status;

  GetProfileModel({this.data, this.message, this.status});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
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
  Null? bankDetailsResponse;
  Null? cardDetailsResponse;
  Null? paymentGetWayResponse;
  List<AddressResponses>? addressResponses;

  Data(
      {this.id,
        this.fullName,
        this.mobileNumber,
        this.customerId,
        this.bankDetailsResponse,
        this.cardDetailsResponse,
        this.paymentGetWayResponse,
        this.addressResponses});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    customerId = json['customerId'];
    bankDetailsResponse = json['bankDetailsResponse'];
    cardDetailsResponse = json['cardDetailsResponse'];
    paymentGetWayResponse = json['paymentGetWayResponse'];
    if (json['addressResponses'] != null) {
      addressResponses = <AddressResponses>[];
      json['addressResponses'].forEach((v) {
        addressResponses!.add(new AddressResponses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['mobileNumber'] = this.mobileNumber;
    data['customerId'] = this.customerId;
    data['bankDetailsResponse'] = this.bankDetailsResponse;
    data['cardDetailsResponse'] = this.cardDetailsResponse;
    data['paymentGetWayResponse'] = this.paymentGetWayResponse;
    if (this.addressResponses != null) {
      data['addressResponses'] =
          this.addressResponses!.map((v) => v.toJson()).toList();
    }
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
