class DashboardData {
  int? containersCirculation;
  int? activeContainers;
  int? overdueContainers;
  int? todayLeased;
  String? leasedTrendPercentage;
  int? todayReturns;
  String? returnsTrendPercentage;
  int? extendedFeeRevenue;
  int? soldRevenue;
  int? averageReturnTimeDays;
  int? activeUsersToday;
  MostLeased? mostLeased;
  MostLeased? lessLeased;

  DashboardData(
      {this.containersCirculation,
        this.activeContainers,
        this.overdueContainers,
        this.todayLeased,
        this.leasedTrendPercentage,
        this.todayReturns,
        this.returnsTrendPercentage,
        this.extendedFeeRevenue,
        this.soldRevenue,
        this.averageReturnTimeDays,
        this.activeUsersToday,
        this.mostLeased,
        this.lessLeased});

  DashboardData.fromJson(Map<String, dynamic> json) {
    containersCirculation = json['containersCirculation']??0;
    activeContainers = json['activeContainers']??0;
    overdueContainers = json['overdueContainers']??0;
    todayLeased = json['todayLeased']??0;
    leasedTrendPercentage = json['leasedTrendPercentage']??"";
    todayReturns = json['todayReturns']??0;
    returnsTrendPercentage = json['returnsTrendPercentage']??"";
    extendedFeeRevenue = json['extendedFeeRevenue']??0;
    soldRevenue = json['soldRevenue']??0;
    averageReturnTimeDays = json['averageReturnTimeDays']??0;
    activeUsersToday = json['activeUsersToday']??0;
    mostLeased = json['mostLeased'] != null
        ? new MostLeased.fromJson(json['mostLeased'])
        : null;
    lessLeased = json['lessLeased'] != null
        ? new MostLeased.fromJson(json['lessLeased'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['containersCirculation'] = this.containersCirculation;
    data['activeContainers'] = this.activeContainers;
    data['overdueContainers'] = this.overdueContainers;
    data['todayLeased'] = this.todayLeased;
    data['leasedTrendPercentage'] = this.leasedTrendPercentage;
    data['todayReturns'] = this.todayReturns;
    data['returnsTrendPercentage'] = this.returnsTrendPercentage;
    data['extendedFeeRevenue'] = this.extendedFeeRevenue;
    data['soldRevenue'] = this.soldRevenue;
    data['averageReturnTimeDays'] = this.averageReturnTimeDays;
    data['activeUsersToday'] = this.activeUsersToday;
    if (this.mostLeased != null) {
      data['mostLeased'] = this.mostLeased!.toJson();
    }
    if (this.lessLeased != null) {
      data['lessLeased'] = this.lessLeased!.toJson();
    }
    return data;
  }
}

class MostLeased {
  int? productId;
  String? name;
  String? productCode;
  String? capacity;
  int? percentage;

  MostLeased(
      {this.productId,
        this.name,
        this.productCode,
        this.capacity,
        this.percentage});

  MostLeased.fromJson(Map<String, dynamic> json) {
    productId = json['productId']??0;
    name = json['name']??"";
    productCode = json['productCode']??"";
    capacity = json['capacity']??"";
    percentage = json['percentage']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['name'] = this.name;
    data['productCode'] = this.productCode;
    data['capacity'] = this.capacity;
    data['percentage'] = this.percentage;
    return data;
  }
}