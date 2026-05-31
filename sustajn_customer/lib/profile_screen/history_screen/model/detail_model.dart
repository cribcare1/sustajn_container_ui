
class BorrowedDetails {
  final String resturantName;
  final String containerName;
  final String code;
  final String volume;
  final int qty;
  final String image;
  final String date;
  final String? price;

  BorrowedDetails({
    required this.resturantName,
    required this.containerName,
    required this.code,
    required this.volume,
    required this.qty,
    required this.image,
    required this.date,
    this.price
  });
}