class ContainerListModel {
  List<InventoryData> inventoryData;
  int count;
  String message;

  ContainerListModel({
    required this.inventoryData,
    required this.count,
    required this.message,
  });

  factory ContainerListModel.fromJson(Map<String, dynamic> json) {
    return ContainerListModel(
      inventoryData: (json['inventory_data'] as List? ?? [])
          .map((e) => InventoryData.fromJson(e))
          .toList(),
      count: json['count'] ?? 0,
      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "inventory_data": inventoryData.map((e) => e.toJson()).toList(),
      "count": count,
      "message": message,
    };
  }
}
class InventoryData {
  int inventoryId;
  int containerTypeId;
  String containerName;
  String containerDescription;
  int capacityMl;
  String material;
  String colour;

  int? lengthCm;
  int? widthCm;
  int? heightCm;
  int? weightGrams;

  bool foodSafe;
  bool dishwasherSafe;
  bool microwaveSafe;

  int? maxTemperature;
  int? minTemperature;
  int? lifespanCycle;

  String imageUrl;
  double costPerUnit;
  int totalContainers;
  int availableContainers;
  String productId;

  InventoryData({
    required this.inventoryId,
    required this.containerTypeId,
    required this.containerName,
    required this.containerDescription,
    required this.capacityMl,
    required this.material,
    required this.colour,
    this.lengthCm,
    this.widthCm,
    this.heightCm,
    this.weightGrams,
    required this.foodSafe,
    required this.dishwasherSafe,
    required this.microwaveSafe,
    this.maxTemperature,
    this.minTemperature,
    this.lifespanCycle,
    required this.imageUrl,
    required this.costPerUnit,
    required this.totalContainers,
    required this.availableContainers,
    required this.productId,
  });

  factory InventoryData.fromJson(Map<String, dynamic> json) {
    return InventoryData(
      inventoryId: json['inventoryId'] ?? 0,
      containerTypeId: json['containerTypeId'] ?? 0,
      containerName: json['containerName'] ?? "",
      containerDescription: json['containerDescription'] ?? "",
      capacityMl: json['capacityMl'] ?? 0,
      material: json['material'] ?? "",
      colour: json['colour'] ?? "",

      lengthCm: json['lengthCm'],
      widthCm: json['widthCm'],
      heightCm: json['heightCm'],
      weightGrams: json['weightGrams'],

      foodSafe: json['foodSafe'] ?? false,
      dishwasherSafe: json['dishwasherSafe'] ?? false,
      microwaveSafe: json['microwaveSafe'] ?? false,

      maxTemperature: json['maxTemperature'],
      minTemperature: json['minTemperature'],
      lifespanCycle: json['lifespanCycle'],

      imageUrl: json['imageUrl'] ?? "",
      costPerUnit: (json['costPerUnit'] ?? 0).toDouble(),
      totalContainers: json['totalContainers'] ?? 0,
      availableContainers: json['availableContainers'] ?? 0,
      productId: json['productId']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "inventoryId": inventoryId,
      "containerTypeId": containerTypeId,
      "containerName": containerName,
      "containerDescription": containerDescription,
      "capacityMl": capacityMl,
      "material": material,
      "colour": colour,
      "lengthCm": lengthCm,
      "widthCm": widthCm,
      "heightCm": heightCm,
      "weightGrams": weightGrams,
      "foodSafe": foodSafe,
      "dishwasherSafe": dishwasherSafe,
      "microwaveSafe": microwaveSafe,
      "maxTemperature": maxTemperature,
      "minTemperature": minTemperature,
      "lifespanCycle": lifespanCycle,
      "imageUrl": imageUrl,
      "costPerUnit": costPerUnit,
      "totalContainers": totalContainers,
      "availableContainers": availableContainers,
      "productId": productId,
    };
  }
}
