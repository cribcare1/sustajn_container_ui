class GetContainerData {
  List<InventoryData>? inventoryData;
  int? count;
  String? message;
  String? status;

  GetContainerData({this.inventoryData, this.count, this.message, this.status});

  GetContainerData.fromJson(Map<String, dynamic> json) {
    if (json['inventory_data'] != null) {
      inventoryData = <InventoryData>[];
      json['inventory_data'].forEach((v) {
        inventoryData!.add(new InventoryData.fromJson(v));
      });
    }
    count = json['count'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inventoryData != null) {
      data['inventory_data'] =
          this.inventoryData!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class InventoryData {
  int? inventoryId;
  int? containerTypeId;
  String? containerName;
  String? containerDescription;
  int? capacityMl;
  String? material;
  String? colour;
  double? lengthCm;
  int? widthCm;
  int? heightCm;
  int? weightGrams;
  bool? foodSafe;
  bool? dishwasherSafe;
  bool? microwaveSafe;
  int? maxTemperature;
  int? minTemperature;
  int? lifespanCycle;
  String? imageUrl;
  double? costPerUnit;
  int? totalContainers;
  int? availableContainers;
  String? productId;

  InventoryData(
      {this.inventoryId,
        this.containerTypeId,
        this.containerName,
        this.containerDescription,
        this.capacityMl,
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
        this.totalContainers,
        this.availableContainers,
        this.productId});

  InventoryData.fromJson(Map<String, dynamic> json) {
    inventoryId = json['inventoryId'];
    containerTypeId = json['containerTypeId'];
    containerName = json['containerName'];
    containerDescription = json['containerDescription'];
    capacityMl = json['capacityMl'];
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
    totalContainers = json['totalContainers'];
    availableContainers = json['availableContainers'];
    productId = json['productId'];
  }

  String? get containerImageUrl => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventoryId'] = this.inventoryId;
    data['containerTypeId'] = this.containerTypeId;
    data['containerName'] = this.containerName;
    data['containerDescription'] = this.containerDescription;
    data['capacityMl'] = this.capacityMl;
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
    data['totalContainers'] = this.totalContainers;
    data['availableContainers'] = this.availableContainers;
    data['productId'] = this.productId;
    return data;
  }
}
