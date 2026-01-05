import 'package:sustajn_customer/utils/utils.dart';

class DateMonthUtils {

  static getMonthYear(String date) {
    try {
      final parsedDate = DateTime.parse(date);

      const months = [
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

      return '${months[parsedDate.month - 1]} ${parsedDate.year}';
    } catch (e) {
      Utils.printLog('Invalid date format: $date');
      return 'Unknown';
    }
  }

  static  getMonthIndex(String monthName) {
    const months = [
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
    return months.indexOf(monthName) + 1;
  }

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