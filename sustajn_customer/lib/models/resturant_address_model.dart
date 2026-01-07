class MapData {
  String? message;
  List<SearchData>? searchData;
  String? status;

  MapData({this.message, this.searchData, this.status});

  MapData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['searchData'] != null) {
      searchData = <SearchData>[];
      json['searchData'].forEach((v) {
        searchData!.add(new SearchData.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.searchData != null) {
      data['searchData'] = this.searchData!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class SearchData {
  int? id;
  String? name;
  String? address;
  int? latitude;
  int? longitude;
  double? distanceKm;
  String? imageUrl;

  SearchData(
      {this.id,
        this.name,
        this.address,
        this.latitude,
        this.longitude,
        this.distanceKm,
        this.imageUrl});

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??'';
    address = json['address']??'';
    latitude = json['latitude']??0;
    longitude = json['longitude']??0;
    distanceKm = json['distanceKm']??0.0;
    imageUrl = json['imageUrl']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['distanceKm'] = this.distanceKm;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
