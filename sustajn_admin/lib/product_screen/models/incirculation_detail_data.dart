// class IncirculationDetailsData {
//   String? message;
//   String? status;
//   IncirculationListData? data;
//
//   IncirculationDetailsData({this.message, this.status, this.data});
//
//   IncirculationDetailsData.fromJson(Map<String, dynamic> json) {
//     message = json['message']??"";
//     status = json['status']??"";
//     data = json['data'] != null ? new IncirculationListData.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class IncirculationListData {
//   String? capacity;
//   int? containerTypeId;
//   String? imageUrl;
//   String? name;
//   String? productId;
//   int? totalInCirculation;
//   List<Null>? users;
//
//   IncirculationListData(
//       {this.capacity,
//         this.containerTypeId,
//         this.imageUrl,
//         this.name,
//         this.productId,
//         this.totalInCirculation,
//         this.users});
//
//   IncirculationListData.fromJson(Map<String, dynamic> json) {
//     capacity = json['capacity']??"";
//     containerTypeId = json['containerTypeId']??0;
//     imageUrl = json['imageUrl']??"";
//     name = json['name']??"";
//     productId = json['productId']??"";
//     totalInCirculation = json['totalInCirculation']??0;
//     if (json['users'] != null) {
//       users = <Null>[];
//       json['users'].forEach((v) {
//         users!.add(new Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['capacity'] = this.capacity;
//     data['containerTypeId'] = this.containerTypeId;
//     data['imageUrl'] = this.imageUrl;
//     data['name'] = this.name;
//     data['productId'] = this.productId;
//     data['totalInCirculation'] = this.totalInCirculation;
//     if (this.users != null) {
//       data['users'] = this.users!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
