class LoginModel {
    int? userId;
    String? image;
    String? role;
    String? userName;
    String? address;
    String? fullName;
    String? jwtToken;
    String? tokenType;
    String? mobileNo;

  LoginModel({
     this.userId,
     this.image,
     this.role,
     this.userName,
     this.address,
     this.fullName,
     this.jwtToken,
     this.tokenType,
     this.mobileNo,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      userId: json['userId'] ?? 0,
      image: json['image'] ?? "",
      role: json['role'] ?? "",
      userName: json['userName'] ?? "",
      address: json['address'] ?? "",
      fullName: json['fullName'] ?? "",
      jwtToken: json['jwtToken'] ?? "",
      tokenType: json['tokenType'] ?? "",
      mobileNo: json['mobileNo'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'image': image,
      'role': role,
      'userName': userName,
      'address': address,
      'fullName': fullName,
      'jwtToken': jwtToken,
      'tokenType': tokenType,
      'mobileNo': mobileNo,
    };
  }
}
