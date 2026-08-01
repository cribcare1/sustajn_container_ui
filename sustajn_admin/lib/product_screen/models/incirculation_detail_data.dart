class IncirculationDetailsData {
  String? status;
  String? message;
  InCirculationDetails? data;

  IncirculationDetailsData({this.status, this.message, this.data});

  IncirculationDetailsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new InCirculationDetails.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class InCirculationDetails {
  String? capacity;
  int? containerTypeId;
  String? imageUrl;
  String? name;
  String? productId;
  int? totalInCirculation;
  List<Users>? users;

  InCirculationDetails(
      {this.capacity,
        this.containerTypeId,
        this.imageUrl,
        this.name,
        this.productId,
        this.totalInCirculation,
        this.users});

  InCirculationDetails.fromJson(Map<String, dynamic> json) {
    capacity = json['capacity'];
    containerTypeId = json['containerTypeId'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    productId = json['productId'];
    totalInCirculation = json['totalInCirculation'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['capacity'] = this.capacity;
    data['containerTypeId'] = this.containerTypeId;
    data['imageUrl'] = this.imageUrl;
    data['name'] = this.name;
    data['productId'] = this.productId;
    data['totalInCirculation'] = this.totalInCirculation;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? count;
  String? userId;

  Users({this.count, this.userId});

  Users.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['userId'] = this.userId;
    return data;
  }
}
