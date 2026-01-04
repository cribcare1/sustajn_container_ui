import '../constants/imports_util.dart';

class NotificationModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String dateTime;

  NotificationModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.dateTime,
  });
}
