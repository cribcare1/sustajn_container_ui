enum FeedbackStatus { newUnread, inProgress, resolved, rejected }

class FeedbackModel {
  final FeedbackStatus status;
  final String name;
  final String reportId;
  final String dateTime;
  final String subject;
  final String description;
  final List<String> images;
  final String remarks;

  FeedbackModel({
    required this.status,
    required this.name,
    required this.reportId,
    required this.dateTime,
    required this.subject,
    required this.description,
    required this.images,
    required this.remarks,
  });
}