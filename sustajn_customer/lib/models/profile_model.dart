// class ProfileData {
//   ProfileList? data;
//   String? message;
//   String? status;
//
//   ProfileData({this.data, this.message, this.status});
//
//   ProfileData.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null ? new ProfileList.fromJson(json['data']) : null;
//     message = json['message'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = this.message;
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class ProfileList {
//   int? id;
//   String? fullName;
//   String? mobileNumber;
//   String? customerId;
//   BankDetailsResponse? bankDetailsResponse;
//   dynamic cardDetailsResponse;
//   dynamic paymentGetWayResponse;
//   List<AddressResponses>? addressResponses;
//
//   ProfileList(
//       {this.id,
//         this.fullName,
//         this.mobileNumber,
//         this.customerId,
//         this.bankDetailsResponse,
//         this.cardDetailsResponse,
//         this.paymentGetWayResponse,
//         this.addressResponses});
//
//   ProfileList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     fullName = json['fullName'];
//     mobileNumber = json['mobileNumber'];
//     customerId = json['customerId'];
//
//     bankDetailsResponse = json['bankDetailsResponse'] != null
//         ? BankDetailsResponse.fromJson(json['bankDetailsResponse'])
//         : null;
//
//     cardDetailsResponse =
//     json.containsKey('cardDetailsResponse') && json['cardDetailsResponse'] != null
//         ? json['cardDetailsResponse']
//         : null;
//
//     paymentGetWayResponse =
//     json.containsKey('paymentGetWayResponse') && json['paymentGetWayResponse'] != null
//         ? json['paymentGetWayResponse']
//         : null;
//
//     if (json['addressResponses'] != null) {
//       addressResponses = <AddressResponses>[];
//       json['addressResponses'].forEach((v) {
//         addressResponses!.add(AddressResponses.fromJson(v));
//       });
//     }
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//
//     data['id'] = id;
//     data['fullName'] = fullName;
//     data['mobileNumber'] = mobileNumber;
//     data['customerId'] = customerId;
//
//     if (bankDetailsResponse != null) {
//       data['bankDetailsResponse'] = bankDetailsResponse!.toJson();
//     }
//
//     if (cardDetailsResponse != null) {
//       data['cardDetailsResponse'] = cardDetailsResponse;
//     }
//
//     if (paymentGetWayResponse != null) {
//       data['paymentGetWayResponse'] = paymentGetWayResponse;
//     }
//
//     if (addressResponses != null) {
//       data['addressResponses'] =
//           addressResponses!.map((v) => v.toJson()).toList();
//     }
//
//     return data;
//   }
//
// }
//
// class BankDetailsResponse {
//   int? id;
//   int? userId;
//   String? bankName;
//   String? accountNumber;
//   String? iBanNumber;
//   String? taxNumber;
//
//   BankDetailsResponse(
//       {this.id,
//         this.userId,
//         this.bankName,
//         this.accountNumber,
//         this.iBanNumber,
//         this.taxNumber});
//
//   BankDetailsResponse.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['userId'];
//     bankName = json['bankName'];
//     accountNumber = json['accountNumber'];
//     iBanNumber = json['iBanNumber'];
//     taxNumber = json['taxNumber'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['userId'] = this.userId;
//     data['bankName'] = this.bankName;
//     data['accountNumber'] = this.accountNumber;
//     data['iBanNumber'] = this.iBanNumber;
//     data['taxNumber'] = this.taxNumber;
//     return data;
//   }
// }
//
// class AddressResponses {
//   int? id;
//   String? addressType;
//   String? flatDoorHouseDetails;
//   String? areaStreetCityBlockDetails;
//   String? poBoxOrPostalCode;
//
//   AddressResponses(
//       {this.id,
//         this.addressType,
//         this.flatDoorHouseDetails,
//         this.areaStreetCityBlockDetails,
//         this.poBoxOrPostalCode});
//
//   AddressResponses.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     addressType = json['addressType'];
//     flatDoorHouseDetails = json['flatDoorHouseDetails'];
//     areaStreetCityBlockDetails = json['areaStreetCityBlockDetails'];
//     poBoxOrPostalCode = json['poBoxOrPostalCode'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['addressType'] = this.addressType;
//     data['flatDoorHouseDetails'] = this.flatDoorHouseDetails;
//     data['areaStreetCityBlockDetails'] = this.areaStreetCityBlockDetails;
//     data['poBoxOrPostalCode'] = this.poBoxOrPostalCode;
//     return data;
//   }
// }
