class SignUpModel {
  SignUpData? data;
  String? message;
  String? status;

  SignUpModel({this.data, this.message, this.status});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SignUpData.fromJson(json['data']) : null;
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

class SignUpData {
  int? userId;
  String? image;
  String? role;
  String? userName;
  String? address;
  String? fullName;
  String? jwtToken;
  String? tokenType;

  SignUpData(
      {this.userId,
        this.image,
        this.role,
        this.userName,
        this.address,
        this.fullName,
        this.jwtToken,
        this.tokenType});

  SignUpData.fromJson(Map<String, dynamic> json) {
    userId = json['userId']??0;
    image = json['image']??"";
    role = json['role']??"";
    userName = json['userName']??"";
    address = json['address']??"";
    fullName = json['fullName']??"";
    jwtToken = json['jwtToken']??"";
    tokenType = json['tokenType']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['image'] = this.image;
    data['role'] = this.role;
    data['userName'] = this.userName;
    data['address'] = this.address;
    data['fullName'] = this.fullName;
    data['jwtToken'] = this.jwtToken;
    data['tokenType'] = this.tokenType;
    return data;
  }
}
