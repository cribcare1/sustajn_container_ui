class NetworkUrls {
  static const int TIME_OUT_CODE = 408;
  static const int NETWORK_CALL_FAILED_CODE = 409;
  static const int EMPTY_RESPONSE_CODE = 406;
  static const int UNAUTHORIZED_ERROR_CODE = 401;

  static const BASE_URL = "http://65.0.241.5:9090/";
  static const BASE_IMAGE_URL = 'http://65.0.241.5:9090/auth/images/';
  static const BASE_CONTAINER_URL = 'http://65.0.241.5:9090/auth/images/container/';
  static const PROFILE_IMAGE_BASE_URL = "http://65.0.241.5:9090/auth/images/profile/";
  static const LOGIN_API = "auth/login";
  static const REGISTER_USER = "auth/registerCostumer";
  static const FORGOT_PASSWORD = "notification/forgot-password";
  static const GET_OTP = "notification/forgot-password";
  static const VERIFY_OTP = "notification/verify-token";
  static const CREATE_FEEDBACK = "auth/submitFeedback";
  static const UPGRADE_SUBSCRIPTION = "auth/upgradeSubscription";
  static const RESET_PASSWORD = "auth/change-password";
  static const GET_SUBSCRIPTION_PLAN = "inventory/subscription-plans/getPlans?role=CUSTOMER";
  static const CREATE_BANK = 'auth/createBankDetails';
  static const UPDATE_BANK = 'auth/updateBankDetails';
  static const UPLOAD_IMAGE = 'auth/uploadImage/';
  static const CREATE_ADDRESS = 'auth/saveAddress';
  static const EDIT_ADDRESS = 'auth/updateAddress';
  static const DELETE_ADDRESS = 'auth/deleteAddress';

  static const BORROWED_DATA = 'orders/monthWiseBorrowedDetails?';
  static const RETURNED_DATA = 'orders/monthWiseReturnedDetails?';
  static const PRODUCT_DATA = 'orders/getBorrowedProduct?userId=';
  static const SEARCH_RESTAURANT ="auth/searchRestaurant";
  static const GET_PROFILE = 'auth/getProfileDetails/';
  static const UPDATE_PROFILE = 'auth/updateProfileDetails';
  static const GET_SOLD_CONTAINER = "inventory/getDetailedSoldHistoryByRestaurant?restaurantId=";


  /// Container ///
  static const ADD_CONTAINER = "inventory/saveOrUpdateContainerType";
  static const CONTAINER_LIST = "inventory/getContainerTypes";
  static const DELETE_CONTAINER = "inventory/delete-container-type/123";
  static const SUCCESS = 'success';

  /// Notification ///
  static const GET_ALL_NOTIFICATION = "notifications/getAll/";
  static const MARK_READ = "notifications/mark-read/";
  static const GET_NOTIFICATION_COUNT = "notifications/unread/count/";



}