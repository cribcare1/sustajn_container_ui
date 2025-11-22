class ContainerRequest {
  final String id;
  final String restaurantName;
  final int requestedQuantity;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime requestDate;
  final String status;
  final int? approvedQuantity;

  ContainerRequest({
    required this.id,
    required this.restaurantName,
    required this.requestedQuantity,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.requestDate,
    this.status = 'Pending',
    this.approvedQuantity,
  });

  ContainerRequest copyWith({
    String? status,
    int? approvedQuantity,
  }) {
    return ContainerRequest(
      id: id,
      restaurantName: restaurantName,
      requestedQuantity: requestedQuantity,
      address: address,
      latitude: latitude,
      longitude: longitude,
      requestDate: requestDate,
      status: status ?? this.status,
      approvedQuantity: approvedQuantity ?? this.approvedQuantity,
    );
  }

  static List<ContainerRequest> sampleRequests = [
    ContainerRequest(
      id: '1',
      restaurantName: 'Food Paradise',
      requestedQuantity: 50,
      address: '123 Main Street, Downtown, City 12345',
      latitude: 40.7128,
      longitude: -74.0060,
      requestDate: DateTime.now().subtract(Duration(hours: 2)),
    ),
    ContainerRequest(
      id: '2',
      restaurantName: 'Urban Bites',
      requestedQuantity: 30,
      address: '456 Oak Avenue, Midtown, City 12345',
      latitude: 40.7589,
      longitude: -73.9851,
      requestDate: DateTime.now().subtract(Duration(hours: 1)),
    ),
  ];
}