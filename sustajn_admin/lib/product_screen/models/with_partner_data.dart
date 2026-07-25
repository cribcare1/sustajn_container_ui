class WithPartnerData {
  List<WithPartnerList>? withpartnerData;
  String? message;
  String? status;

  WithPartnerData({this.withpartnerData, this.message, this.status});

  WithPartnerData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      withpartnerData = <WithPartnerList>[];
      json['data'].forEach((v) {
        withpartnerData!.add(new WithPartnerList.fromJson(v));
      });
    }
    message = json['message']??"";
    status = json['status']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.withpartnerData != null) {
      data['data'] = this.withpartnerData!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class WithPartnerList {
  String? capacity;
  int? containerTypeId;
  String? imageUrl;
  String? name;
  String? productId;
  int? withPartnerCount;

  WithPartnerList(
      {this.capacity,
        this.containerTypeId,
        this.imageUrl,
        this.name,
        this.productId,
        this.withPartnerCount});

  WithPartnerList.fromJson(Map<String, dynamic> json) {
    capacity = json['capacity']??"";
    containerTypeId = json['containerTypeId']??0;
    imageUrl = json['imageUrl']??"";
    name = json['name']??"";
    productId = json['productId']??"";
    withPartnerCount = json['withPartnerCount']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['capacity'] = this.capacity;
    data['containerTypeId'] = this.containerTypeId;
    data['imageUrl'] = this.imageUrl;
    data['name'] = this.name;
    data['productId'] = this.productId;
    data['withPartnerCount'] = this.withPartnerCount;
    return data;
  }
}
