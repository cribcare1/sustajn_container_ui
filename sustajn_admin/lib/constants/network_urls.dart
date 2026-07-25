class NetworkUrls {
  static const int TIME_OUT_CODE = 408;
  static const int NETWORK_CALL_FAILED_CODE = 409;
  static const int EMPTY_RESPONSE_CODE = 406;
  static const int UNAUTHORIZED_ERROR_CODE = 401;

  static const BASE_URL = "http://65.0.241.5:9090/";
  static const IMAGE_BASE_URL = "http://65.0.241.5:9090/auth/images/";
  static const CONTAINER_IMAGE_BASE_URL = "http://65.0.241.5:9090/auth/images/container/";
  static const GET_CONTAINER = "inventory/getAllActiveInventory/";
  static const GET_CONTAINER_BY_ID = "inventory/restaurant/getAvailableContainers/";
  static const CONTAINER_COUNT = "orders/getLeasedReturnedCount";
  static const LOGIN_API = "auth/login";
  static const REGISTER_USER = "auth/register-user";
  static const FORGOT_PASSWORD = "notification/forgot-password";
  static const VERIFY_OTP = "notification/verify-token";

  ///Patner
  static const LEASE_BORROW_CONTAINER = "orders/partner/";
/// Container ///
static const ADD_CONTAINER = "inventory/addContainerByAdmin";
static const CONTAINER_LIST = "inventory/getAllActiveInventory";
static const DELETE_CONTAINER = "inventory/delete-container-type/123";
/// Restaurant ///
static const RESTAURANT_LIST = "auth/activeRestaurants?";

/// Customer ///
static const CUSTOMER_LIST = "auth/activeCustomersDetails?";
static const USER_DAMAGED_DATA = "inventory/getDamagedContainersByUser?userId=";

/// Partner products
  static const ALL_RESTAURANT_LIST = "auth/getAllActiveRestaurants";
  static const CONTAINER_HISTORY = "orders/orderHistory/";
  //static const GET_CONTAINER = "inventory/restaurant/getAvailableContainers/";
  static const RETURN_PRODUCTS = "inventory/restaurantOrders/returnedProducts/";
  static const ISSUED_PRODUCTS = "inventory/restaurantOrders/monthWiseIssuedProducts?restaurantId=&productId=";
  static const RESTAURANT_DETAILS = "auth/getRestaurantDetailsById/";
  static const PRODUCT_DATA = 'orders/getBorrowedProduct?userId=';
  static const BORROWED_DATA = 'orders/monthWiseBorrowedDetails?';
  static const RETURNED_DATA = 'orders/monthWiseReturnedDetails?';
  static const GET_SOLD_CONTAINER = "inventory/getSoldContainersByRestaurant?restaurantId=";

  //Order request
  static const PENDING_ORDER_DATA = 'inventory/admin/orders/pending';
  static const PENDING_ORDER_DETAILS_DATA = 'inventory/admin/orders/details/';
  static const CONFIRM_ORDER_DATA = 'inventory/admin/orders/confirmed';
  static const CONFIRM_ORDER_DETAILS_DATA = 'inventory/admin/orders/confirmed/details/';
  static const DELIVER_ORDER_DATA = 'inventory/admin/orders/delivered';
  static const DELIVER_ORDER_DETAILS = 'inventory/admin/orders/delivered/details/';
  static const REJECT_ORDER_DATA = 'inventory/admin/orders/rejected';
  static const REJECT_ORDER_DETAILS_DATA = 'inventory/admin/orders/rejected/details/';
  static const APPROVE_ORDER = 'inventory/approveOrder';
  static const REJECT_ORDER = 'inventory/rejectOrder';
  static const MARK_AS_DELIVERED = 'inventory/markOrderAsDelivered/';

  static const SUBSCRIPTION = 'inventory/admin/transactions/subscriptions';
  static const SOLD_DASHBOARD = 'inventory/admin/transactions/sold-dashboard';

  // Admin Product
static const PRODUCT_INCIRCULATION ='inventory/cointainerstatistic/in-circulation-list';
static const WITH_PARTNER = 'inventory/cointainerstatistic/with-partner-list';
static const DAMAGED_CONTAINER = 'inventory/getDamageContainerByUserType?damageBy=USER/';
static const SOLD_CONTAINERS = 'inventory/admin/transactions/sold-dashboard';
static const WITH_PARTNER_DETAIL = 'inventory/cointainerstatistic//with-partner/2';
static const INCIRCULATION_DETAIL = 'inventory/cointainerstatistic/in-circulation/2';
}
