class LoginModel {
  final LoginData? data;
  final String? message;
  final String? status;

  LoginModel({
    this.data,
    this.message,
    this.status,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
      status: json['status'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'data':data,
      'message': message,
      'status': status,
    };
  }
}

class LoginData {
  final int? userId;
  final String? image;
  final String? role;
  final String? userName;
  final String? address;
  final String? fullName;
  final String? jwtToken;
  final String? tokenType;

  LoginData({
    this.userId,
    this.image,
    this.role,
    this.userName,
    this.address,
    this.fullName,
    this.jwtToken,
    this.tokenType,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      userId: json['userId'] ?? 0,
      image: json['image'] ?? '',
      role: json['role'] ?? '',
      userName: json['userName'] ?? '',
      address: json['address'] ?? '',
      fullName: json['fullName'] ?? '',
      jwtToken: json['jwtToken'] ?? '',
      tokenType: json['tokenType'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId ?? 0,
      'image': image ?? '',
      'role': role ?? '',
      'userName': userName ?? '',
      'address': address ?? '',
      'fullName': fullName ?? '',
      'jwtToken': jwtToken ?? '',
      'tokenType': tokenType ?? '',
    };
  }
}
