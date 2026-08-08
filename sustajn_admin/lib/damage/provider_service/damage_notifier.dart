import 'package:flutter/cupertino.dart';
import '../../utils/utility.dart';
import '../models/damage_partner_data.dart';
import '../models/damage_user_data.dart';
import 'damage_notifier.dart';
import 'damage_service.dart';

class DamageNotifier extends ChangeNotifier {

  bool _isLoading = false;

  String _searchQuery = '';
  // Error messages
  String? _nameError;
  BuildContext? _context;

  DamageUserData? _damageUserData;
  List<DamageUserDataList> _damageUserDataList = [];

  DamagePartnerData? _damagePartnerData;
  List<DamagePartnerDataList> _damagePartnerDataList = [];

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  BuildContext get context => _context!;

  //Getter
  String? get nameError => _nameError;

  DamageUserData? get getDamageUserData => _damageUserData;
  List<DamageUserDataList> get getDamageUserDataList => _damageUserDataList;

  DamagePartnerData? get getDamagePartnerData => _damagePartnerData;
  List<DamagePartnerDataList> get getDamagePartnerDataList => _damagePartnerDataList;

//Setter

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setDamageUserData(DamageUserData damageUserData) {
    print("Notifier Called");
    print("List Length = ${damageUserData.data?.length}");

    _damageUserData = damageUserData;
    _damageUserDataList = damageUserData.data ?? [];

    print("Stored Length = ${_damageUserDataList.length}");

    notifyListeners();
  }

  void setDamagePartnerData(DamagePartnerData damagePartnerData) {
    print("Partner Data Length = ${damagePartnerData.data?.length}");

    _damagePartnerData = damagePartnerData;
    _damagePartnerDataList = damagePartnerData.data ?? [];

    print("Notifier Partner List = ${_damagePartnerDataList.length}");

    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    // updateGroupedOrders();
    notifyListeners();
  }

}
