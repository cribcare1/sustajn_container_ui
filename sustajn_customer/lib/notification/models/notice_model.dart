class NotificationResponseModel {
  final List<NotificationModel>? data;
  final String? message;
  final String? status;

  NotificationResponseModel({
    this.data,
    this.message,
    this.status,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      data: json['data'] != null
          ? List<NotificationModel>.from(
        json['data'].map((x) => NotificationModel.fromJson(x)),
      )
          : [],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data?.map((e) => e.toJson()).toList(),
      "message": message,
      "status": status,
    };
  }
}

class NotificationModel {
  final int? id;
  final String? message;
  final String? notificationType;
  final int? senderId;
  final int? receiverId;
  final String? timestamp;
  final bool? isRead;
  final String? approvalStatus;
  final int? orderId;
  final String? status;

  NotificationModel({
    this.id,
    this.message,
    this.notificationType,
    this.senderId,
    this.receiverId,
    this.timestamp,
    this.isRead,
    this.approvalStatus,
    this.orderId,
    this.status,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message']??"",
      notificationType: json['notificationType']??"",
      senderId: json['senderId']??0,
      receiverId: json['receiverId'],
      timestamp: json['timestamp']??"",
      isRead: json['isRead'],
      approvalStatus: json['approvalStatus']??"",
      orderId: json['orderId'],
      status: json['status']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "message": message,
      "notificationType": notificationType,
      "senderId": senderId,
      "receiverId": receiverId,
      "timestamp": timestamp,
      "isRead": isRead,
      "approvalStatus": approvalStatus,
      "orderId": orderId,
      "status": status,
    };
  }
}