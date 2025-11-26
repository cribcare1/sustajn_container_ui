import 'dart:ui';

import '../constants/number_constants.dart';

class ContainerRequest {
  final String id;
  final int requestedCount;
  final int? approvedCount;
  final RequestStatus status;
  final DateTime requestDateTime;
  final String restaurantAddress;
  final double latitude;
  final double longitude;

  ContainerRequest({
    required this.id,
    required this.requestedCount,
    this.approvedCount,
    required this.status,
    required this.requestDateTime,
    required this.restaurantAddress,
    required this.latitude,
    required this.longitude,
  });

  bool get canDelete => status == RequestStatus.pending;
}

enum RequestStatus {
  pending('Pending', Constant.warningColor),
  approved('Approved', Constant.successColor),
  rejected('Rejected', Constant.errorColor);

  final String displayName;
  final Color color;
  const RequestStatus(this.displayName, this.color);
}