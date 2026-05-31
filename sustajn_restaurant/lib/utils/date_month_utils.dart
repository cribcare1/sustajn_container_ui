class DateMonthUtils {
  static  List<String> getCurrentYearMonths() {
    final now = DateTime.now();
    const monthNames = [
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

    return List.generate(12, (index) => '${monthNames[index]}–${now.year}');
  }
}