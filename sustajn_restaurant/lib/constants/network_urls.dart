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

  static const BASE_URL = "http://65.0.241.5:9090/";
  static const PROFILE_IMAGE_BASE_URL = "http://65.0.241.5:9090/auth/images/profile/";
  static const IMAGE_BASE_URL = "http://65.0.241.5:9090/auth/images/";
  static const CONTAINER_IMAGE_BASE_URL = "http://65.0.241.5:9090/auth/images/container/";
  static const LOGIN_API = "auth/login";
  static const REGISTER_USER = "auth/register-restaurant";
  static const FORGOT_PASSWORD = "notification/forgot-password";
  static const RESET_PASSWORD = "auth/change-password";
  static const VERIFY_OTP = "notification/verify-token";
  static const SUBSCRIPTION_LIST = "inventory/subscription-plans/getPlans?role=RESTAURANT";
  static const CONTAINER_COUNT = "orders/getLeasedReturnedCount";
  static const ORDER_HISTORY = "orders/getLeasedReturnedMonthYearDetails";
  static const ORDER_GRAPH = "orders/getLeasedReturnedCountWithTimeGraph";

  /// Profile ///
  static const GET_PROFILE = "auth/getProfileDetails/";
  static const UPDATE_PROFILE = "auth/updateProfileDetails";
  static const UPDATE_ADDRESS = "auth/updateAddress";
  static const GET_CONTAINER = "inventory/restaurant/getAvailableContainers/";
  static const GET_RETURN_CONTAINER = "orders/monthWiseReturnedDetails?userId=";
  static const CONTAINER_HISTORY = "orders/orderHistory/";
  static const REFER_A_PARTNER = "auth/referPartner";
  static const BUSINESS_INFO = "auth/addBusinessInfo";
  static const FEEDBACK = "auth/submitFeedback";
  static const UPGRADE_SUBSCRIPTION_PLAN = "auth/upgradeSubscription";
  /// Container ///
  static const ADD_CONTAINER = "inventory/saveOrUpdateContainerType";
  static const CONTAINER_LIST = "inventory/getContainerTypes";
  static const DELETE_CONTAINER = "inventory/delete-container-type/";
  static const ADD_RETURN_CONTAINER = "inventory/raiseOrderRequest";
  static const GET_DAMAGED_CONTAINER = "inventory/getDamagedContainersByRestaurant?restaurantId=";
  static const GET_SOLD_CONTAINER = "inventory/getSoldContainersByRestaurant?restaurantId=";


  /// Search Restaurant ///

 static const SEARCH_RESTAURANT ="auth/searchRestaurant";

 /// Lease and Receive///

static const CONTAINER_LIST_LEASE = "inventory/restaurant/getAvailableContainers/";
static const CONTAINER_LEASE = "orders/borrowContainers";
static const CONTAINER_RECEIVE = "orders/returnContainers";
static const CONTAINER_RECEIVE_LIST = "orders/monthWiseBorrowedDetails";
static const CUSTOMER_BORROWED_LIST = "orders/getBorrowedProduct?customerId=";
/// Damage container
static const DAMAGE_CONTAINER = "inventory/reportDamagedContainer";

/// Notification
static const GET_ALL_NOTIFICATION = "notifications/getAll/";
static const GET_NOTIFICATION_COUNT = "notifications/unread/count/";
static const MARK_READ = "notifications/mark-read/";

static const DASHBOARD_CHART = "orders/restaurantOrders/chart-stats?restaurantId=";
static const UPDATE_PAYMENT_TYPE = "auth/updateBankDetailsByUser?customerId=";


}