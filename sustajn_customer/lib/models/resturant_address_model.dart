class SearchData {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String? imageUrl;

  SearchData({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    this.imageUrl,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distanceKm': distanceKm,
      'imageUrl': imageUrl,
    };
  }
}