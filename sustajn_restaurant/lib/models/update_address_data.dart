
class UpdateProfAddressData {
  dynamic data;
  String? message;
  String? status;

  UpdateProfAddressData({this.data, this.message, this.status});

  UpdateProfAddressData.fromJson(Map<String, dynamic> json) {
    data = json["data"];
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["data"] = data;
    _data["message"] = message;
    _data["status"] = status;
    return _data;
  }
}