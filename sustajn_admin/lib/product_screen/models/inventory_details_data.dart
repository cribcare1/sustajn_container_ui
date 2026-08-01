class InventoryDetailsData {
  int? productId;
  String? name;
  String? productCode;
  String? capacity;
  String? imageUrl;
  int? orderedCount;
  int? issuedToPartnerCount;
  int? inCirculationCount;
  int? withPartnerCount;
  int? soldCount;
  int? damagedCount;
  int? inStockCount;
  int? returnedCount;

  InventoryDetailsData(
      {this.productId,
        this.name,
        this.productCode,
        this.capacity,
        this.imageUrl,
        this.orderedCount,
        this.issuedToPartnerCount,
        this.inCirculationCount,
        this.withPartnerCount,
        this.soldCount,
        this.damagedCount,
        this.inStockCount,
        this.returnedCount});

  InventoryDetailsData.fromJson(Map<String, dynamic> json) {
    productId = json['productId']??0;
    name = json['name']??"";
    productCode = json['productCode']??"";
    capacity = json['capacity']??"";
    imageUrl = json['imageUrl']??"";
    orderedCount = json['orderedCount']??0;
    issuedToPartnerCount = json['issuedToPartnerCount']??0;
    inCirculationCount = json['inCirculationCount']??0;
    withPartnerCount = json['withPartnerCount']??0;
    soldCount = json['soldCount']??0;
    damagedCount = json['damagedCount']??0;
    inStockCount = json['inStockCount']??0;
    returnedCount = json['returnedCount']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['name'] = this.name;
    data['productCode'] = this.productCode;
    data['capacity'] = this.capacity;
    data['imageUrl'] = this.imageUrl;
    data['orderedCount'] = this.orderedCount;
    data['issuedToPartnerCount'] = this.issuedToPartnerCount;
    data['inCirculationCount'] = this.inCirculationCount;
    data['withPartnerCount'] = this.withPartnerCount;
    data['soldCount'] = this.soldCount;
    data['damagedCount'] = this.damagedCount;
    data['inStockCount'] = this.inStockCount;
    data['returnedCount'] = this.returnedCount;
    return data;
  }
}
