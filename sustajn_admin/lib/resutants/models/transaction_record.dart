class TransactionRecord {
  final String status;
  final int amount;
  final DateTime date;

  TransactionRecord({
    required this.status,
    required this.amount,
    required this.date,
  });
}
