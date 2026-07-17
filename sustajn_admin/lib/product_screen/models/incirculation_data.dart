class IncirculationData {
  List<IncirculationList>? data;
  String? message;
  String? status;

  IncirculationData({this.data, this.message, this.status});

  IncirculationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <IncirculationList>[];
      json['data'].forEach((v) {
        data!.add(new IncirculationList.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
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

class IncirculationList {
  String? capacity;
  int? containerTypeId;
  String? imageUrl;
  int? inCirculationCount;
  String? name;
  String? productId;

  IncirculationList(
      {this.capacity,
        this.containerTypeId,
        this.imageUrl,
        this.inCirculationCount,
        this.name,
        this.productId});

  IncirculationList.fromJson(Map<String, dynamic> json) {
    capacity = json['capacity'];
    containerTypeId = json['containerTypeId'];
    imageUrl = json['imageUrl'];
    inCirculationCount = json['inCirculationCount'];
    name = json['name'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['capacity'] = this.capacity;
    data['containerTypeId'] = this.containerTypeId;
    data['imageUrl'] = this.imageUrl;
    data['inCirculationCount'] = this.inCirculationCount;
    data['name'] = this.name;
    data['productId'] = this.productId;
    return data;
  }
}
