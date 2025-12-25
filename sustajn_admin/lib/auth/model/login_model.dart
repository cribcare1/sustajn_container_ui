class LoginModel {
  final String message;
  final LoginData data;
  final String status;

  LoginModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      data: LoginData.fromJson(json['data'] ?? {}),
    );
  }
}

class LoginData {
  final int userId;
  final String image;
  final String role;
  final String userName;
  final String address;
  final String fullName;
  final String jwtToken;
  final String tokenType;
  final String mobileNo;

  LoginData({
    required this.userId,
    required this.image,
    required this.role,
    required this.userName,
    required this.address,
    required this.fullName,
    required this.jwtToken,
    required this.tokenType,
    required this.mobileNo,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      userId: json['userId'] ?? 0,
      image: json['image'] ?? '',
      role: json['role'] ?? '',
      userName: json['userName'] ?? 'Unknown',
      address: json['address'] ?? '',
      fullName: json['fullName'] ?? 'Unknown', // handles null
      jwtToken: json['jwtToken'] ?? '',
      tokenType: json['tokenType'] ?? '',
      mobileNo: json['mobileNo'] ?? '**********',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "image": image,
      "role": role,
      "userName": userName,
      "address": address,
      "fullName": fullName,
      "jwtToken": jwtToken,
      "tokenType": tokenType,
      "mobileNo": mobileNo,
    };
  }
}
