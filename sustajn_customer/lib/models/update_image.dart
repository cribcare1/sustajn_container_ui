class UpdateImage {
  String? data;
  String? message;
  String? status;

  UpdateImage({this.data, this.message, this.status});

  UpdateImage.fromJson(Map<String, dynamic> json) {
    data = json['data']??"";
    message = json['message']??"";
    status = json['status']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
