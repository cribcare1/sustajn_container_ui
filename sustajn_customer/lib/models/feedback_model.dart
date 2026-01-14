class FeedbackModel {
  String? status;
  String? message;
  dynamic data;

  FeedbackModel({this.status, this.data, this.message});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
