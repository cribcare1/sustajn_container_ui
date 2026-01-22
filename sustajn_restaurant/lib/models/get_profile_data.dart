
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
  String? customerId;
  String? emailId;
  String? profileImageUrl;
  dynamic bankDetailsResponse;
  dynamic cardDetailsResponse;
  dynamic paymentGetWayResponse;
  List<AddressResponses>? addressResponses;

  Data({this.id, this.fullName, this.mobileNumber, this.customerId,
    this.emailId,
    this.profileImageUrl,
    this.bankDetailsResponse, this.cardDetailsResponse, this.paymentGetWayResponse, this.addressResponses});

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
    if(json["customerId"] is String) {
      customerId = json["customerId"];
    }
    if(json["emailId"] is String) {
      emailId = json["emailId"];
    }
    if(json["profileImageUrl"] is String) {
      profileImageUrl = json["profileImageUrl"];
    }
    bankDetailsResponse = json["bankDetailsResponse"];
    cardDetailsResponse = json["cardDetailsResponse"];
    paymentGetWayResponse = json["paymentGetWayResponse"];
    if(json["addressResponses"] is List) {
      addressResponses = json["addressResponses"] == null ? null : (json["addressResponses"] as List).map((e) => AddressResponses.fromJson(e)).toList();
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
    _data["bankDetailsResponse"] = bankDetailsResponse;
    _data["cardDetailsResponse"] = cardDetailsResponse;
    _data["paymentGetWayResponse"] = paymentGetWayResponse;
    if(addressResponses != null) {
      _data["addressResponses"] = addressResponses?.map((e) => e.toJson()).toList();
    }
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