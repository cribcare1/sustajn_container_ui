class Register {
  RestaurantRegistrationData? restaurantRegistrationData;
  String? message;
  String? status;

  Register({this.restaurantRegistrationData, this.message, this.status});

  Register.fromJson(Map<String, dynamic> json) {
    restaurantRegistrationData = json['restaurantRegistrationData'] != null
        ? new RestaurantRegistrationData.fromJson(
        json['restaurantRegistrationData'])
        : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurantRegistrationData != null) {
      data['restaurantRegistrationData'] =
          this.restaurantRegistrationData!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class RestaurantRegistrationData {
  int? restaurantId;
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImageUrl;

  RestaurantRegistrationData(
      {this.restaurantId,
        this.name,
        this.email,
        this.phoneNumber,
        this.profileImageUrl});

  RestaurantRegistrationData.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['profileImageUrl'] = this.profileImageUrl;
    return data;
  }
}
