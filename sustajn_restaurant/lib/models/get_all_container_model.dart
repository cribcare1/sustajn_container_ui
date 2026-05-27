class GetAllContainerModel {
  List<ContainerData>? data;
  String? message;
  String? status;

  GetAllContainerModel({
    this.data,
    this.message,
    this.status,
  });

  GetAllContainerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ContainerData>[];
      json['data'].forEach((v) {
        data!.add(ContainerData.fromJson(v));
      });
    }
    message = json['message'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    dataMap['message'] = message ?? "";
    dataMap['status'] = status ?? "";

    return dataMap;
  }
}

class ContainerData {
  int? id;
  String? name;
  String? description;
  int? capacityMl;
  String? productId;
  String? material;
  String? colour;
  double? lengthCm;
  double? widthCm;
  double? heightCm;
  double? weightGrams;
  bool? foodSafe;
  bool? dishwasherSafe;
  bool? microwaveSafe;
  double? maxTemperature;
  double? minTemperature;
  int? lifespanCycle;
  String? imageUrl;
  double? costPerUnit;
  String? status;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  int? totalContainerCount;
  int? availableContainerCount;

  ContainerData({
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
    this.status,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.totalContainerCount,
    this.availableContainerCount,
  });

  ContainerData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    capacityMl = json['capacityMl'] ?? 0;
    productId = json['productId'] ?? "";
    material = json['material'] ?? "";
    colour = json['colour'] ?? "";
    lengthCm = (json['lengthCm'] ?? 0).toDouble();
    widthCm = (json['widthCm'] ?? 0).toDouble();
    heightCm = (json['heightCm'] ?? 0).toDouble();
    weightGrams = (json['weightGrams'] ?? 0).toDouble();
    foodSafe = json['foodSafe'] ?? false;
    dishwasherSafe = json['dishwasherSafe'] ?? false;
    microwaveSafe = json['microwaveSafe'] ?? false;
    maxTemperature = (json['maxTemperature'] ?? 0).toDouble();
    minTemperature = (json['minTemperature'] ?? 0).toDouble();
    lifespanCycle = json['lifespanCycle'] ?? 0;
    imageUrl = json['imageUrl'] ?? "";
    costPerUnit = (json['costPerUnit'] ?? 0).toDouble();
    status = json['status'] ?? "";
    createdAt = json['createdAt'] ?? "";
    createdBy = json['createdBy'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    updatedBy = json['updatedBy'] ?? "";
    totalContainerCount = json['totalContainerCount'] ?? 0;
    availableContainerCount = json['availableContainerCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id ?? 0;
    data['name'] = name ?? "";
    data['description'] = description ?? "";
    data['capacityMl'] = capacityMl ?? 0;
    data['productId'] = productId ?? "";
    data['material'] = material ?? "";
    data['colour'] = colour ?? "";
    data['lengthCm'] = lengthCm ?? 0;
    data['widthCm'] = widthCm ?? 0;
    data['heightCm'] = heightCm ?? 0;
    data['weightGrams'] = weightGrams ?? 0;
    data['foodSafe'] = foodSafe ?? false;
    data['dishwasherSafe'] = dishwasherSafe ?? false;
    data['microwaveSafe'] = microwaveSafe ?? false;
    data['maxTemperature'] = maxTemperature ?? 0;
    data['minTemperature'] = minTemperature ?? 0;
    data['lifespanCycle'] = lifespanCycle ?? 0;
    data['imageUrl'] = imageUrl ?? "";
    data['costPerUnit'] = costPerUnit ?? 0;
    data['status'] = status ?? "";
    data['createdAt'] = createdAt ?? "";
    data['createdBy'] = createdBy ?? "";
    data['updatedAt'] = updatedAt ?? "";
    data['updatedBy'] = updatedBy ?? "";
    data['totalContainerCount'] = totalContainerCount ?? 0;
    data['availableContainerCount'] = availableContainerCount ?? 0;

    return data;
  }
}