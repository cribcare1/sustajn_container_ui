class GetContainerData {
  List<InventoryData>? data;
  String? message;
  String? status;

  GetContainerData({this.data, this.message, this.status});

  GetContainerData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InventoryData>[];
      json['data'].forEach((v) {
        data!.add(new InventoryData.fromJson(v));
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

class InventoryData {
  int? id;
  String? name;
  String? description;
  int? capacityMl;
  String? productId;
  String? material;
  String? colour;
  Null? lengthCm;
  Null? widthCm;
  Null? heightCm;
  Null? weightGrams;
  bool? foodSafe;
  bool? dishwasherSafe;
  bool? microwaveSafe;
  Null? maxTemperature;
  Null? minTemperature;
  Null? lifespanCycle;
  String? imageUrl;
  double? costPerUnit;
  double? extendFee;
  String? status;
  String? createdAt;
  Null? createdBy;
  String? updatedAt;
  Null? updatedBy;
  int? totalContainerCount;
  int? availableContainerCount;

  InventoryData({
    this.id,
    this.name,
    this.description,
    this.capacityMl,
    this.productId,
    this.material,
    this.colour,
    this.lengthCm,
    this.widthCm,
    this.heightCm,
    this.weightGrams,
    this.foodSafe,
    this.dishwasherSafe,
    this.microwaveSafe,
    this.maxTemperature,
    this.minTemperature,
    this.lifespanCycle,
    this.imageUrl,
    this.costPerUnit,
    this.extendFee,
    this.status,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.totalContainerCount,
    this.availableContainerCount,
  });

  InventoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    capacityMl = json['capacityMl'];
    productId = json['productId'];
    material = json['material'];
    colour = json['colour'];
    lengthCm = json['lengthCm'];
    widthCm = json['widthCm'];
    heightCm = json['heightCm'];
    weightGrams = json['weightGrams'];
    foodSafe = json['foodSafe'];
    dishwasherSafe = json['dishwasherSafe'];
    microwaveSafe = json['microwaveSafe'];
    maxTemperature = json['maxTemperature'];
    minTemperature = json['minTemperature'];
    lifespanCycle = json['lifespanCycle'];
    imageUrl = json['imageUrl'];
    costPerUnit = json['costPerUnit'];
    extendFee = json['extendFee'];
    status = json['status'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    totalContainerCount = json['totalContainerCount'];
    availableContainerCount = json['availableContainerCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['capacityMl'] = this.capacityMl;
    data['productId'] = this.productId;
    data['material'] = this.material;
    data['colour'] = this.colour;
    data['lengthCm'] = this.lengthCm;
    data['widthCm'] = this.widthCm;
    data['heightCm'] = this.heightCm;
    data['weightGrams'] = this.weightGrams;
    data['foodSafe'] = this.foodSafe;
    data['dishwasherSafe'] = this.dishwasherSafe;
    data['microwaveSafe'] = this.microwaveSafe;
    data['maxTemperature'] = this.maxTemperature;
    data['minTemperature'] = this.minTemperature;
    data['lifespanCycle'] = this.lifespanCycle;
    data['imageUrl'] = this.imageUrl;
    data['costPerUnit'] = this.costPerUnit;
    data['extendFee'] = this.extendFee;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['updatedAt'] = this.updatedAt;
    data['updatedBy'] = this.updatedBy;
    data['totalContainerCount'] = this.totalContainerCount;
    data['availableContainerCount'] = this.availableContainerCount;
    return data;
  }
}
