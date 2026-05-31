
import 'ApiHelper.dart';

AppDataManager appDataManager = AppDataManager();

class AppDataManager {
  static final AppDataManager _appDataManager = AppDataManager._internal();
  final ApiHelper apiHelper = ApiHelper();

  factory AppDataManager() {
    return _appDataManager;
  }

  AppDataManager._internal();
}