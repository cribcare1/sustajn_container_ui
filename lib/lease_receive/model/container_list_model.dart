class ContainerListModel {
  List<ContainerDetails> containersDetails;
  String message;
  String status;

  ContainerListModel({
    required this.containersDetails,
    required this.message,
    required this.status,
  });

  factory ContainerListModel.fromJson(Map<String, dynamic> json) {
    return ContainerListModel(
      containersDetails: (json['containersDetails'] as List<dynamic>?)
          ?.map((e) => ContainerDetails.fromJson(e))
          .toList() ??
          [],
      message: json['message'] ?? "",
      status: json['status'] ?? "",
    );
  }
}

class ContainerDetails {
  int containerId;
  String containerName;
  String containerDescription;
  int capacity;
  String containerImageUrl;
  String containerUniqueId;
  int quantityAvailable;
  int quantity;

  ContainerDetails({
    required this.containerId,
    required this.containerName,
    required this.containerDescription,
    required this.capacity,
    required this.containerImageUrl,
    required this.containerUniqueId,
    required this.quantityAvailable,
    this.quantity = 1,
  });

  factory ContainerDetails.fromJson(Map<String, dynamic> json) {
    return ContainerDetails(
      containerId: json['containerId'] ?? 0,
      containerName: json['containerName'] ?? "",
      containerDescription: json['containerDescription'] ?? "",
      capacity: json['capacity'] ?? 0,
      containerImageUrl: json['containerImageUrl'] ?? "",
      containerUniqueId: json['containerUniqueId'] ?? "",
      quantityAvailable: json['quantityAvailable'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }
}
