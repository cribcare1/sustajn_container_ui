
class UpdateProfileData {
  Data? data;
  String? message;
  String? status;

  UpdateProfileData({this.data, this.message, this.status});

  UpdateProfileData.fromJson(Map<String, dynamic> json) {
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
  String? userType;
  String? fullName;
  String? customerId;
  dynamic gender;
  String? profilePictureUrl;
  String? dateOfBirth;
  String? userName;
  String? email;
  String? phoneNumber;
  String? accountStatus;
  dynamic address;
  double? latitude;
  double? longitude;
  bool? phoneVerified;
  bool? emailVerified;
  dynamic appVersion;
  dynamic deviceOs;
  dynamic pushNotification;
  String? createdAt;
  String? updatedAt;
  dynamic lastLogin;
  int? subscriptionPlanId;

  Data({this.id, this.userType, this.fullName, this.customerId, this.gender, this.profilePictureUrl, this.dateOfBirth, this.userName, this.email, this.phoneNumber, this.accountStatus, this.address, this.latitude, this.longitude, this.phoneVerified, this.emailVerified, this.appVersion, this.deviceOs, this.pushNotification, this.createdAt, this.updatedAt, this.lastLogin, this.subscriptionPlanId});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["userType"] is String) {
      userType = json["userType"];
    }
    if(json["fullName"] is String) {
      fullName = json["fullName"];
    }
    if(json["customerId"] is String) {
      customerId = json["customerId"];
    }
    gender = json["gender"];
    if(json["profilePictureUrl"] is String) {
      profilePictureUrl = json["profilePictureUrl"];
    }
    if(json["dateOfBirth"] is String) {
      dateOfBirth = json["dateOfBirth"];
    }
    if(json["userName"] is String) {
      userName = json["userName"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["phoneNumber"] is String) {
      phoneNumber = json["phoneNumber"];
    }
    if(json["accountStatus"] is String) {
      accountStatus = json["accountStatus"];
    }
    address = json["address"];
    if(json["latitude"] is double) {
      latitude = json["latitude"];
    }
    if(json["longitude"] is double) {
      longitude = json["longitude"];
    }
    if(json["phoneVerified"] is bool) {
      phoneVerified = json["phoneVerified"];
    }
    if(json["emailVerified"] is bool) {
      emailVerified = json["emailVerified"];
    }
    appVersion = json["appVersion"];
    deviceOs = json["deviceOs"];
    pushNotification = json["pushNotification"];
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if(json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
    lastLogin = json["lastLogin"];
    if(json["subscriptionPlanId"] is int) {
      subscriptionPlanId = json["subscriptionPlanId"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["userType"] = userType;
    _data["fullName"] = fullName;
    _data["customerId"] = customerId;
    _data["gender"] = gender;
    _data["profilePictureUrl"] = profilePictureUrl;
    _data["dateOfBirth"] = dateOfBirth;
    _data["userName"] = userName;
    _data["email"] = email;
    _data["phoneNumber"] = phoneNumber;
    _data["accountStatus"] = accountStatus;
    _data["address"] = address;
    _data["latitude"] = latitude;
    _data["longitude"] = longitude;
    _data["phoneVerified"] = phoneVerified;
    _data["emailVerified"] = emailVerified;
    _data["appVersion"] = appVersion;
    _data["deviceOs"] = deviceOs;
    _data["pushNotification"] = pushNotification;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["lastLogin"] = lastLogin;
    _data["subscriptionPlanId"] = subscriptionPlanId;
    return _data;
  }
}