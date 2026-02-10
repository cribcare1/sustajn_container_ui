class GetContainerData {
  List<ContainersDetails>? containersDetails;
  String? message;
  String? status;

  GetContainerData({this.containersDetails, this.message, this.status});

  GetContainerData.fromJson(Map<String, dynamic> json) {
    if (json['containersDetails'] != null) {
      containersDetails = <ContainersDetails>[];
      json['containersDetails'].forEach((v) {
        containersDetails!.add(new ContainersDetails.fromJson(v));
      });
    }
    message = json['message'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.containersDetails != null) {
      data['containersDetails'] =
          this.containersDetails!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class ContainersDetails {
  int? containerId;
  String? containerName;
  String? containerDescription;
  int? capacity;
  String? containerImageUrl;
  String? containerUniqueId;
  int? quantityAvailable;

  ContainersDetails(
      {this.containerId,
        this.containerName,
        this.containerDescription,
        this.capacity,
        this.containerImageUrl,
        this.containerUniqueId,
        this.quantityAvailable});

  ContainersDetails.fromJson(Map<String, dynamic> json) {
    containerId = json['containerId'] ?? 0;
    containerName = json['containerName'] ?? "";
    containerDescription = json['containerDescription'] ?? "";
    capacity = json['capacity'] ?? 0;
    containerImageUrl = json['containerImageUrl'] ?? "";
    containerUniqueId = json['containerUniqueId'] ?? "";
    quantityAvailable = json['quantityAvailable'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['containerId'] = this.containerId;
    data['containerName'] = this.containerName;
    data['containerDescription'] = this.containerDescription;
    data['capacity'] = this.capacity;
    data['containerImageUrl'] = this.containerImageUrl;
    data['containerUniqueId'] = this.containerUniqueId;
    data['quantityAvailable'] = this.quantityAvailable;
    return data;
  }
}
