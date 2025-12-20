class LoginModel {
  String? message;
  Data? data;
  String? status;

  LoginModel({this.message, this.data, this.status});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? userId;
  String? image;
  String? role;
  String? userName;
  String? address;
  String? fullName;
  String? jwtToken;
  String? tokenType;

  Data(
      {this.userId,
        this.image,
        this.role,
        this.userName,
        this.address,
        this.fullName,
        this.jwtToken,
        this.tokenType});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    image = json['image'];
    role = json['role'];
    userName = json['userName'];
    address = json['address'];
    fullName = json['fullName'];
    jwtToken = json['jwtToken'];
    tokenType = json['tokenType'];
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
