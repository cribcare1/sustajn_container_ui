class UserRegistration {
  String? message;
  int? userId;
  String? profileImageUrl;
  String? status;

  UserRegistration(
      {this.message, this.userId, this.profileImageUrl, this.status});

  UserRegistration.fromJson(Map<String, dynamic> json) {
    message = json['message']??"";
    userId = json['userId']??0;
    profileImageUrl = json['profileImageUrl']??"";
    status = json['status']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['userId'] = this.userId;
    data['profileImageUrl'] = this.profileImageUrl;
    data['status'] = this.status;
    return data;
  }
}
