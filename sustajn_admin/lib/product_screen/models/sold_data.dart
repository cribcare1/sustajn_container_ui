// class SoldContainersData {
//   List<SoldList>? data;
//   String? message;
//   String? status;
//
//   SoldContainersData({this.data, this.message, this.status});
//
//   SoldContainersData.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <SoldList>[];
//       json['data'].forEach((v) {
//         data!.add(new SoldList.fromJson(v));
//       });
//     }
//     message = json['message']??"";
//     status = json['status']??"";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['message'] = this.message;
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class SoldList {
//   String? monthYear;
//   int? monthTotalAmount;
//   List<Transactions>? transactions;
//
//   SoldList({this.monthYear, this.monthTotalAmount, this.transactions});
//
//   SoldList.fromJson(Map<String, dynamic> json) {
//     monthYear = json['monthYear']??"";
//     monthTotalAmount = json['monthTotalAmount']??0;
//     if (json['transactions'] != null) {
//       transactions = <Transactions>[];
//       json['transactions'].forEach((v) {
//         transactions!.add(new Transactions.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['monthYear'] = this.monthYear;
//     data['monthTotalAmount'] = this.monthTotalAmount;
//     if (this.transactions != null) {
//       data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Transactions {
//   String? id;
//   String? type;
//   String? name;
//   Null? customerId;
//   Null? address;
//   String? formattedDate;
//   int? totalQuantity;
//   int? totalAmount;
//   String? productCodesConcatenated;
//   List<ContainersList>? containers;
//
//   Transactions(
//       {this.id,
//         this.type,
//         this.name,
//         this.customerId,
//         this.address,
//         this.formattedDate,
//         this.totalQuantity,
//         this.totalAmount,
//         this.productCodesConcatenated,
//         this.containers});
//
//   Transactions.fromJson(Map<String, dynamic> json) {
//     id = json['id']??"";
//     type = json['type']??"";
//     name = json['name']??"";
//     customerId = json['customerId'];
//     address = json['address'];
//     formattedDate = json['formattedDate']??"";
//     totalQuantity = json['totalQuantity']??0;
//     totalAmount = json['totalAmount']??0;
//     productCodesConcatenated = json['productCodesConcatenated']??"";
//     if (json['containers'] != null) {
//       containers = <ContainersList>[];
//       json['containers'].forEach((v) {
//         containers!.add(new ContainersList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['type'] = this.type;
//     data['name'] = this.name;
//     data['customerId'] = this.customerId;
//     data['address'] = this.address;
//     data['formattedDate'] = this.formattedDate;
//     data['totalQuantity'] = this.totalQuantity;
//     data['totalAmount'] = this.totalAmount;
//     data['productCodesConcatenated'] = this.productCodesConcatenated;
//     if (this.containers != null) {
//       data['containers'] = this.containers!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ContainersList {
//   int? containerTypeId;
//   String? containerName;
//   String? productCode;
//   String? capacity;
//   String? imageUrl;
//   int? quantity;
//   int? price;
//
//   ContainersList(
//       {this.containerTypeId,
//         this.containerName,
//         this.productCode,
//         this.capacity,
//         this.imageUrl,
//         this.quantity,
//         this.price});
//
//   ContainersList.fromJson(Map<String, dynamic> json) {
//     containerTypeId = json['containerTypeId']??0;
//     containerName = json['containerName']??"";
//     productCode = json['productCode']??"";
//     capacity = json['capacity']??"";
//     imageUrl = json['imageUrl']??"";
//     quantity = json['quantity']??0;
//     price = json['price']??0;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['containerTypeId'] = this.containerTypeId;
//     data['containerName'] = this.containerName;
//     data['productCode'] = this.productCode;
//     data['capacity'] = this.capacity;
//     data['imageUrl'] = this.imageUrl;
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     return data;
//   }
// }
