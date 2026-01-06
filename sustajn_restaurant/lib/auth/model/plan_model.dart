class PlanModel {
  final String title;
  final String price;
  final List<String> features;
  bool isSelected;

  PlanModel({
    required this.title,
    required this.price,
    required this.features,
    this.isSelected = false,
  });
}
List<PlanModel> plans = [
  PlanModel(
    title: 'Pay-per-use',
    price: '500 / month',
    features: [
      'Lorem ipsum dolor sit amet consectetur.',
      'Vitae eu s',
      'Lorem ipsum',
    ],
  ),
  PlanModel(
    title: 'Customisation',
    price: '1000 / month',
    features: [
      'Lorem ipsum dolor sit amet consectetur.',
      'Vitae eu',
      'Lorem ipsum',
    ],
  ),
];
