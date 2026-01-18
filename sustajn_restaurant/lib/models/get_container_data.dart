
class GetContainerData {
  List<ContainersDetails>? containersDetails;
  String? message;
  String? status;

  GetContainerData({this.containersDetails, this.message, this.status});

  GetContainerData.fromJson(Map<String, dynamic> json) {
    if(json["containersDetails"] is List) {
      containersDetails = json["containersDetails"] == null ? null : (json["containersDetails"] as List).map((e) => ContainersDetails.fromJson(e)).toList();
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(containersDetails != null) {
      _data["containersDetails"] = containersDetails?.map((e) => e.toJson()).toList();
    }
    _data["message"] = message;
    _data["status"] = status;
    return _data;
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

  ContainersDetails({this.containerId, this.containerName, this.containerDescription, this.capacity, this.containerImageUrl, this.containerUniqueId, this.quantityAvailable});

  ContainersDetails.fromJson(Map<String, dynamic> json) {
    if(json["containerId"] is int) {
      containerId = json["containerId"];
    }
    if(json["containerName"] is String) {
      containerName = json["containerName"];
    }
    if(json["containerDescription"] is String) {
      containerDescription = json["containerDescription"];
    }
    if(json["capacity"] is int) {
      capacity = json["capacity"];
    }
    if(json["containerImageUrl"] is String) {
      containerImageUrl = json["containerImageUrl"];
    }
    if(json["containerUniqueId"] is String) {
      containerUniqueId = json["containerUniqueId"];
    }
    if(json["quantityAvailable"] is int) {
      quantityAvailable = json["quantityAvailable"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["containerId"] = containerId;
    _data["containerName"] = containerName;
    _data["containerDescription"] = containerDescription;
    _data["capacity"] = capacity;
    _data["containerImageUrl"] = containerImageUrl;
    _data["containerUniqueId"] = containerUniqueId;
    _data["quantityAvailable"] = quantityAvailable;
    return _data;
  }
}