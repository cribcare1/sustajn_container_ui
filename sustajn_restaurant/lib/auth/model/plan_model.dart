class PlanModel {
  final int planId;
  final String planName;
  final int totalContainers;
  double? feeType;
  final List<String> features;
  bool isSelected;
  final String planStatus;
  final String billingCycle;
  String? description;

  PlanModel({
    required this.planId,
    required this.planName,
    required this.totalContainers,
    required this.features,
    required this.feeType,
    this.isSelected = false,
    required this.planStatus,
    required this.billingCycle,
     this.description
  });
  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      planId: json['planId'] ?? 0,
      planName: json['planName'] ?? '',
      totalContainers: json['totalContainers'] ?? 0,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [ 'Lorem ipsum dolor sit amet consectetur.',
            'Vitae eu s',
            'Lorem ipsum',],
        feeType: (json['feeType'] as num?)?.toDouble() ?? 0.0,
      isSelected: json['isSelected'] ?? false,
      planStatus: json['planStatus'] ?? '',
      billingCycle: json['billingCycle'] ?? '',
      description: json['description']??''
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'totalContainers': totalContainers,
      'features': features,
      'feeType':feeType,
      'isSelected': isSelected,
      'planStatus': planStatus,
      'billingCycle': billingCycle,
      'description':description
    };
  }
}