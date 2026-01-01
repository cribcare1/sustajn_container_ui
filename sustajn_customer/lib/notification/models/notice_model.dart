class NoticeModel {
  final String title;
  final String subtitle;
  final String dateTime;
  final String icon;
  final bool hasActions;

  const NoticeModel({
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.icon,
    required this.hasActions,
});
}