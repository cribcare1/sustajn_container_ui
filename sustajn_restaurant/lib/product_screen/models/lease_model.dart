class LeaseItem {
  final String customerId;
  final String containerTypes;
  final int quantity;
  final String dateTime;

  LeaseItem({
    required this.customerId,
    required this.containerTypes,
    required this.quantity,
    required this.dateTime,
  });
}

class LeasedContainer {
  final String name;
  final String code;
  final String volume;
  final int qty;
  final String image;

  LeasedContainer({
    required this.name,
    required this.code,
    required this.volume,
    required this.qty,
    required this.image,
  });
}
