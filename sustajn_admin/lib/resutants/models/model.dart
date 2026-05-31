class Restaurant {
  final String name;
  final int containers;
  final String address;
  final String imageUrl;

  Restaurant({
    required this.name,
    required this.containers,
    required this.address,
    required this.imageUrl,
  });
}

// class RestaurantDetails {
//   final String name;
//   final int totalContainersIssued;
//   final int totalAvailable;
//   final int totalGivenToCustomers;
//   final int pendingFromCustomers;
//   final DateTime registeredOn;
//   final DateTime approvedOn;
//   final DateTime rejectedOn;
//
//   RestaurantDetails({
//     required this.name,
//     required this.totalContainersIssued,
//     required this.totalAvailable,
//     required this.totalGivenToCustomers,
//     required this.pendingFromCustomers,
//     required this.registeredOn,
//     required this.approvedOn,
//     required this.rejectedOn,
//   });
// }