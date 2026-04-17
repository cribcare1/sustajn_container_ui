class GetRestaurantData {
  List<Data>? data;
  String? message;
  String? status;

  GetRestaurantData({this.data, this.message, this.status});

  GetRestaurantData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? profileImageUrl;
  String? address;

  Data({this.id, this.name, this.profileImageUrl, this.address});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    profileImageUrl = json['profileImageUrl'] ?? '';
    address = json['address'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profileImageUrl'] = this.profileImageUrl;
    data['address'] = this.address;
    return data;
  }
}
