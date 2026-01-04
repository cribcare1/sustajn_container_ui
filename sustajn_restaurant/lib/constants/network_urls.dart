class NetworkUrls {
  static const int TIME_OUT_CODE = 408;
  static const int NETWORK_CALL_FAILED_CODE = 409;
  static const int EMPTY_RESPONSE_CODE = 406;
  static const int UNAUTHORIZED_ERROR_CODE = 401;

  // API Key Neme
  static const PART_URL = 'part_url';
  static const REQUEST_TYPE = 'request_type';
  static const REQUEST_KEY = 'request_key';
  static const LISTENER = 'listener';
  static const DATA = 'data';
  static const IMAGE = 'image';
  static const DOCUMENT = 'document';
  static const SUCCESS = 'success';
  static const REGISTER_USER_KEY = 'data';

  static const BASE_URL = "http://35.154.182.218:9090/";
  static const PROFILE_IMAGE_BASE_URL = "http://35.154.182.218:9090/auth/images/profile/";
  static const LOGIN_API = "auth/login";
  static const REGISTER_USER = "auth/register-restaurant";
  static const FORGOT_PASSWORD = "notification/forgot-password";
  static const VERIFY_OTP = "notification/verify-token";

  /// Container ///
  static const ADD_CONTAINER = "inventory/saveOrUpdateContainerType";
  static const CONTAINER_LIST = "inventory/getContainerTypes";
  static const DELETE_CONTAINER = "inventory/delete-container-type/123";

  /// Search Restaurant ///

 static const SEARCH_RESTAURANT ="auth/searchRestaurant";

}