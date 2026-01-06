class PlanModel {
  final int planId;
  final String planName;
  final int totalContainers;
  final List<String> features;
  bool isSelected;
  final String planStatus;
  final String billingCycle;

  PlanModel({
    required this.planId,
    required this.planName,
    required this.totalContainers,
    required this.features,
    this.isSelected = false,
    required this.planStatus,
    required this.billingCycle,
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
      isSelected: json['isSelected'] ?? false,
      planStatus: json['planStatus'] ?? '',
      billingCycle: json['billingCycle'] ?? '',
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
      'totalContainers': totalContainers,
      'features': features,
      'isSelected': isSelected,
      'planStatus': planStatus,
      'billingCycle': billingCycle,
    };
  }
}