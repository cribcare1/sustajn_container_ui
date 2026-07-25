class WithPartnerDetailsData {
  String? message;
  String? status;
  PartnersDataList? data;

  WithPartnerDetailsData({this.message, this.status, this.data});

  WithPartnerDetailsData.fromJson(Map<String, dynamic> json) {
    message = json['message']??"";
    status = json['status']??"";
    data = json['data'] != null ? new PartnersDataList.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PartnersDataList {
  int? containerTypeId;
  String? name;
  String? productId;
  String? capacity;
  String? imageUrl;
  int? totalWithPartner;
  List<Partners>? partners;

  PartnersDataList(
      {this.containerTypeId,
        this.name,
        this.productId,
        this.capacity,
        this.imageUrl,
        this.totalWithPartner,
        this.partners});

  PartnersDataList.fromJson(Map<String, dynamic> json) {
    containerTypeId = json['containerTypeId']??0;
    name = json['name']??"";
    productId = json['productId']??"";
    capacity = json['capacity']??"";
    imageUrl = json['imageUrl']??"";
    totalWithPartner = json['totalWithPartner']??0;
    if (json['partners'] != null) {
      partners = <Partners>[];
      json['partners'].forEach((v) {
        partners!.add(new Partners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['containerTypeId'] = this.containerTypeId;
    data['name'] = this.name;
    data['productId'] = this.productId;
    data['capacity'] = this.capacity;
    data['imageUrl'] = this.imageUrl;
    data['totalWithPartner'] = this.totalWithPartner;
    if (this.partners != null) {
      data['partners'] = this.partners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Partners {
  int? restaurantId;
  String? partnerName;
  String? address;
  int? count;

  Partners({this.restaurantId, this.partnerName, this.address, this.count});

  Partners.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId']??0;
    partnerName = json['partnerName']??"";
    address = json['address']??"";
    count = json['count']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['partnerName'] = this.partnerName;
    data['address'] = this.address;
    data['count'] = this.count;
    return data;
  }
}
