class NetworkUrls {
  static const int TIME_OUT_CODE = 408;
  static const int NETWORK_CALL_FAILED_CODE = 409;
  static const int EMPTY_RESPONSE_CODE = 406;
  static const int UNAUTHORIZED_ERROR_CODE = 401;

  static const BASE_URL = "http://35.154.182.218:9090/";
  static const BASE_IMAGE_URL = 'http://35.154.182.218:9090/auth/images/';
  static const LOGIN_API = "auth/login";
  static const REGISTER_USER = "auth/registerCostumer";
  static const FORGOT_PASSWORD = "notification/forgot-password";
  static const GET_OTP = "notification/forgot-password";
  static const VERIFY_OTP = "notification/verify-token";
  static const RESET_PASSWORD = "auth/change-password";
  static const GET_SUBSCRIPTION_PLAN = "inventory/subscription-plans/summaries";

  static const BORROWED_DATA = 'orders/monthWiseBorrowedDetails?';
  static const RETURNED_DATA = 'orders/monthWiseReturnedDetails?';
  static const PRODUCT_DATA = 'orders/productsSummary/';

  /// Container ///
  static const ADD_CONTAINER = "inventory/saveOrUpdateContainerType";
  static const CONTAINER_LIST = "inventory/getContainerTypes";
  static const DELETE_CONTAINER = "inventory/delete-container-type/123";
  static const SUCCESS = 'success';

}