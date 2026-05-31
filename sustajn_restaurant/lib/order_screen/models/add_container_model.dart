class ContainerItem {
  final String name;
  final String code;
  final String volume;
  final int availableQty;
  final String image;

  int selectedQty;
  bool isAdded;

  ContainerItem({
    required this.name,
    required this.code,
    required this.volume,
    required this.availableQty,
    required this.image,
    this.selectedQty = 0,
    this.isAdded = false,
  });
}
