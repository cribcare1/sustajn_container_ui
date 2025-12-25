class RestaurantListModel {
  final int size;
  final int totalPages;
  final int page;
  final String status;
  final List<RestaurantData> restaurantData;
  final int totalElements;

  RestaurantListModel({
    required this.size,
    required this.totalPages,
    required this.page,
    required this.status,
    required this.restaurantData,
    required this.totalElements,
  });

  factory RestaurantListModel.fromJson(Map<String, dynamic> json) {
    return RestaurantListModel(
      size: json['size'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      page: json['page'] ?? 0,
      status: json['status'] ?? "",
      restaurantData: (json['restaurantData'] as List<dynamic>? ?? [])
          .map((e) => RestaurantData.fromJson(e))
          .toList(),
      totalElements: json['totalElements'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'totalPages': totalPages,
      'page': page,
      'status': status,
      'restaurantData': restaurantData.map((e) => e.toJson()).toList(),
      'totalElements': totalElements,
    };
  }
}
class RestaurantData {
  final int id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String website;
  final int containerCount;

  RestaurantData({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.containerCount,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      email: json['email'] ?? "",
      website: json['website'] ?? "",
      containerCount: json['containerCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'containerCount': containerCount,
    };
  }
}
