final List months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
String maskCardNumber(String? cardNumber) {
  if (cardNumber == null || cardNumber.isEmpty) {
    return "**** **** **** ****";
  }

  if (cardNumber.length <= 4) {
    return "**** **** **** $cardNumber";
  }

  final last4 = cardNumber.substring(cardNumber.length - 4);
  return "**** **** **** $last4";
}
