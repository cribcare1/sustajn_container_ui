class DeleteAddressModel {
  Map<String, dynamic>? data;
  String? message;
  String? status;

  DeleteAddressModel({this.data, this.message, this.status});

  DeleteAddressModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
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
