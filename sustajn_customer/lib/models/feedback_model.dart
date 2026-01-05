class FeedbackModel {
  String? status;
  String? message;
  dynamic data; // ✅ FIX

  FeedbackModel({this.status, this.data, this.message});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data']; // ✅ FIX
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
