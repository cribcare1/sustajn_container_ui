class CustomerListModel {
  List<CustomerData> customersData;
  int size;
  int totalPages;
  int page;
  String status;
  int totalElements;

  CustomerListModel({
    required this.customersData,
    required this.size,
    required this.totalPages,
    required this.page,
    required this.status,
    required this.totalElements,
  });

  factory CustomerListModel.fromJson(Map<String, dynamic> json) {
    return CustomerListModel(
      customersData: (json['customersData'] as List? ?? [])
          .map((e) => CustomerData.fromJson(e))
          .toList(),
      size: json['size'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      page: json['page'] ?? 0,
      status: json['status'] ?? "",
      totalElements: json['totalElements'] ?? 0,
    );
  }
}
class CustomerData {
  int id;
  String email;
  String mobile;
  String fullName;
  String profileImage;
  int borrowedCount;
  int returnedCount;
  int pendingCount;

  CustomerData({
    required this.id,
    required this.email,
    required this.mobile,
    required this.fullName,
    required this.profileImage,
    required this.borrowedCount,
    required this.returnedCount,
    required this.pendingCount,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] ?? 0,
      email: json['email'] ?? "",
      mobile: json['mobile'] ?? "",
      fullName: json['fullName'] ?? "",
      profileImage: json['profileImage'] ?? "",
      borrowedCount: json['borrowedCount'] ?? 0,
      returnedCount: json['returnedCount'] ?? 0,
      pendingCount: json['pendingCount'] ?? 0,
    );
  }
}
