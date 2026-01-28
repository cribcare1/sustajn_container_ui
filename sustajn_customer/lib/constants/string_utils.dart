class Strings {

  static String get CONTAINERS => "Containers";

  static String get ACTIVE => "Active";

  static String get RETURNED => "Returned";

  //Shared Preference Key
  static const JWT_TOKEN = 'jwt_token';
  static const IS_LOGGED_IN = 'isLoggedIn';
  static const PROFILE_DATA = 'ProfileData';
  static const USER_DATA = 'userData';

  //Network Message
  static const EMPTY_DATA_SERVER_MSG =
      'Something went wrong! Please try again after sometime.';
  static const SESSION_EXPIRED_MSG =
      'Session expired! Please login again after sometime.';
  static const TIME_OUT_ERROR_MSG =
      'Timed out from server! Please try again after sometime.';
  static const NO_INTERNET_CONNECTION =
      'Internet connection failed! Please try after sometime.';
  static const API_ERROR_MSG_TEXT =
      "Request is not successful. Please try again later!";
  static const RESTAURANT_ADDRESS = "Restaurant Address";
  static const PART_URL = 'part_url';
  static const REQUEST_TYPE = 'request_type';
  static const REQUEST_KEY = 'request_key';
  static const DATA = 'data';
  static const IMAGE = 'image';
  static const DOCUMENT = 'document';
  static const LISTENER = 'listener';
  static const CUSTOMER_ID = "customer_id";

  //Sign Up & Login
  static const String LOGIN = "LogIn";
  static const String SIGN_UP = "Sign Up";
  static const String FULL_NAME = "Full Name*";
  static const String EMAIL = 'Email ID*';

  static const String RESTURANT_TITLE = 'Resturants';
  static const String SEARCH_RESTURANTS = 'Search by Resturant Name';
  static const String SEARCH_RESTURANT_TITLE = 'Search Resturant';
  static const String APPROVED_STATUS = 'Approved';
  static const String PENDING_STATUS = 'Pending';
  static const String REJECTED_STATUS = 'Rejected';
  static const String TRANSACTION_DETAILS_TITLE = 'Transaction Details';
  static const String TRANSACTION_HISTORY = 'Transaction History';
  static const String REQUESTED_CONTAINER_TYPES = 'Requested Container types';
  static const String REQUESTED_ON = 'Requested on';
  static const String APPROVED_CONTAINER = 'Approved Container types';
  static const String APPROVED_ON = 'Approved on';
  static const String DIRECTION = 'Direction';
  static const String CALL = 'Call';
  static const String VIEW_ALL = 'View All';
  static const String RESTURANT_HISTORY = 'Resturant History';
  static const String VIEW_RESTURANT_DETAILS = 'View Resturant Details';
  static const String RESTURANT_DETAILS_TITLE = 'Resturant Details';
  static const String LARGE = 'Large';
  static const String MEDIUM = 'Medium';
  static const String SMALL = 'Small';
  static const String RESTURANT_TRANSACTION_HISTORY_TITLE =
      'Resturant Transaction History';
  static const String STATUS = 'Status';
  static const CONTAINERS_TITLE = 'Containers';
  static const CONTAINER_DETAILS = 'Container Details';
  static const ADD_NEWCONTAINER_TITLE = 'Add New Container';
  static const CONTAINER_INFORMATION = 'Container Information';
  static const ENTER_PRODUCT = 'Enter Product*';
  static const ENTER_PRODUCT_ID = 'Enter Product ID*';
  static const ENTER_VOLUME = 'Enter Volume in ml*';
  static const ENTER_QUANTITY = 'Quantity*';
  static const CONTAINER_PRICE = 'Price of the container*';
  static const CONTAINER_IMAGE = 'Container Image';
  static const ADD_CONTAINER = 'Add Container';
  static const CHOOSE = 'Choose';
  static const CAMERA = 'Camera';
  static const GALLERY = 'Gallery';
  static const UPLOAD_IMAGE = 'Upload container image (JPG/PNG)';
  static const NO_CONTAINERS = 'No containers added yet';
  static const START_ADD_CONTAINERS =
      'Start by adding container items so they appear here';
  static const SEARCH_CONTAINER_NAME = 'Search by Container Name or ID';
  static const AVAILABLE_CONTAINERS = 'Available Containers';
  static const TOTAL_ISSUED_TITLE = 'Total Issued';
  static const SEARCH_BY_RESTURANT = 'Search by resturant';
  static const TOTAL_RETURNED = 'Total Returned';
  static const OVERDUE = 'Overdue';

  // static const RETURNED = 'Returned';
  static const BORROWED = 'Borrowed';
  static const MONTHLY = 'Monthly';
  static const DAILY = 'Daily';
  static const TOTAL_RETURNED_CONTAINER = 'Total Returned Containers';
  static const TOTAL_BORROWED_CONTAINER = 'Total Borrowed Containers';
  static const TOTAL_ACTIVE_CUSTOMER = 'Total Active Customers';
  static const TOTAL_REGISTERED_CUST = 'Total Customers Registered';
  static const TOTAL_ISSUED_CONTAINER = 'Total Issued Containers';
  static const TOTAL_ACTIVE_RESTURANTS = 'Total Active Resturants';
  static const TOTAL_REGISTERED_RESTURANT = 'Total Resturants Registered';
  static const RESTURANT = 'Resturant';
  static const CUSTOMER = 'Customer';
  static const TOTAL_EARNINGS = 'Total Earnings';
  static const VERIFY_EMAIL = 'Verify your email';
  static const SEND_CODE =
      "We've sent you a code to verify your email id on ";
  static const VERIFY = 'Verify';
  static const DIDNT_RECV_CODE = "Didn't receive the code? ";
  static const RESEND = 'Resend';
  static const USER_ID = 'userId';
  static const FILL_DETAILS =
      'Please fill the below details to create your account';
  static const NAME = 'Name';
  static const MOBILE_NUMBER = 'Mobile Number*';
  static const EMAIL_ID = 'Email ID*';
  static const PASSWORD = 'Password*';
  static const CONFIRM_PASSWORD = 'Confirm Password*';
  static const LOCATION = 'Location';
  static const CONTINUE_VERIFICATION = 'Continue to verification';
  static const ALREADY_HAVE_ACC = 'Existing user? ';
  static const RESET = 'Reset';
  static const SET_NEW_PASSWORD = 'Please set your new password';
  static const RESET_PASSWORD = 'Reset Password';
  static const WELCOME = 'Welcome';
  static const LOGIN_YOUR_ACC = 'Login to your account';
  static const String SIGN_UP_TTITLE = "Please provide your details below";
  static const FORGOT_PASSWORD = 'Forgot Password?';
  static const DONT_HAVE_ACC = "Don't have an account? ";
  static const FORGOT_PASSWORD_TXT = 'Forgot Password';
  static const ENTER_EMAIL_TORCV_CODE =
      'Please enter your email address to receive confirmation code';
  static const SEARCH_BY_CUSTOMERNAME = 'Search by customer name';
  static const FEEDBACK = 'Feedback';
  static const EDIT = 'Edit';
  static const DELETE = 'Delete';
  static const REJECT_TXT = 'rejected';
  static const RESOLVED_TXT = 'resolved';
  static const INPROGRESS_TXT = 'in progress';
  static const NEW_UNREAD = 'New / Unread';
  static const FEEDBACK_TITLE = 'Feedback';
  static const REJECT_BUTTON = 'Reject';
  static const RESOLVE_BUTTON = 'Resolve';
  static const RESOLVE_FEEDBACK = 'Resolve feedback?';
  static const RESOLVE_DIALOG_TXT =
      'Are you sure you want to resolve this feedback?';
  static const REJECT_FEEDBACK = 'Reject feedback?';
  static const REJECT_DIALOG_TXT =
      'Are you sure you want to reject this feedback? This action cannot be undone';
  static const ACKNOWLEDGEMENT_TXT = 'Acknowledgement';
  static const ACK_TITLE = 'Acknowledgement feedback?';
  static const ACK_DIALOG_TXT =
      'Are you sure you want to acknowledge this feedback?';
  static const APPROVE_TXT = 'Approve';
  static const IMAGES = 'Images';
  static const DESCRIPTION = 'Description';
  static const SUBJECT = 'Subject';
  static const REPORT_ID = 'Report ID';
  static const DATE_TIME = 'Date & Time';
  static const FEEDBACK_DETAILS = 'Feedback Details';
  static const STATUS_INPROGRESS = 'In Progress';
  static const STATUS_RESOLVED = 'Resolved';
  static const STATUS_REJECTED = 'Rejected';
  static const ACK_REMARKS = 'Acknowledged Remarks';
  static const RESOLVED_REMARKS = 'Resolved Remarks';
  static const REJECTED_RAMARKS = 'Rejected Remarks';
  static const MSG = 'message';
  static const SUCCESS = 'success';
  static const ERROR = 'Error';
  static const EMAIL_REQUIRED_TXT = "Email is required.";
  static const PASSWORD_REQUIRED_TXT = "Password is required";
  static const INVALID_PASSWORD =
      'Password must be at least 8 characters long and contain at least one letter and one number';
  static const LOGGED_SUCCESS = "Logged in successfully";
  static const ADDED_CONTAINER = "Container Added Successfully";
  static const String BANK_DETAILS = 'Bank Details';
  static const String ENTER_BANK_INFO = 'Enter your bank information';
  static const String BANK_NAME = 'Bank Name';
  static const String ACC_NO = 'Account Number';
  static const String CONFIRM_ACC_NO = 'Confirm Account Number';
  static const String TAX_NUMBER = 'Tax Number';
  static const String CONTINUE = 'Continue';
  static const String GO_BACK = 'Are you sure you want to go back ?';
  static const String VERIFIED_EMAIL =
      'You have already verified your email. Going back may interrupt the account setup process';
  static const String STAY_ON_THIS_PAGE = 'Stay on this page';
  static const String CONFIRM_LOGOUT = 'Confirm Logout';
  static const String SURE_LOG_OUT = 'Are you sure you want to log out?';
  static const String YES = 'Yes';
  static const String NO = 'No';
  static const String DASHBOARD_TEXT = 'Welcome! Ready to start reusing?';
  static const String BORROW_REUSABLE_CONTAINERS = 'Borrow reusable containers from your favourite\n resturants  and track returns here';

  static const String MY_QR_CODE = 'My QR Code';

  static const String CONFIRM_ACCOUNT = "Confirm Agreement & Create Account";
  static const String CONFIRM_MESSAGE = "Looks great! Tap Confirm to finish creating your account with the Freemium plan.";
  static const String CANCEL = "Cancel";
  static const String CREATE = "Create";
  static const String LEAVE_RESET_PASSWORD = 'Leave Reset Password?';
  static const String LEAVE_PASSWORD_TXT = 'If you go back now, your password reset process will\n be canceled.Do you still want to go back?';
  static const String SKIP_PAYMENT = 'To enjoy the full benefits of the service offered, provideing the payment information is mandatory';
  static const String SKIP_CONTINUE = 'Skip&Continue';
  static const String SAVE_CHANGES = 'Save Changes';
  static const String USER_FULL_NAME = 'Full Name';
  static const String NO_SUBSCRIPTION_TEXT = 'No subscription plans available';
  static const String LEARN_MORE = 'Learn More';
  static const String UPGRADE = 'Upgrade';


  static const String REMOVE_DETAILS = 'Remove Saved Bank Details?';
  static const String DELETE_MESSAGE = 'Your bank information will be securely deleted from our sysytem';
  static const String REMOVE = 'Remove';
  static const String SKIP = 'Skip';
  static const String SELECT_HOME_ADDRESS_TITLE = 'Select Home Address';
  static const String ADD_ADDRESS_TITLE = 'Add Address';
  static const String EDIT_ADDRESS_TITLE = 'Edit Address';
  static const String CONTACT_NUMBER = 'Contact Number';
  static const String ADD_CONTACT_NUMBER = 'Add Contact Number';
  static const String EDIT_CONTACT_NUMBER= 'Edit Contact Number';
  static const String PRIMARY_NUMBER = 'Primary Number';
  static const String ADD_SECONDARY_NUMBER = 'Add Secondary Number';
  static const String SECONDARY_NUMBER = 'Secondary Number';
  static const String ADD_TEXT = 'Add';
  static const String ENTER_MOBILE_NUMBER = 'Enter mobile number';
  static const String ENTER_VALID_PHONE = 'Enter valid 10 digit number';
  static const String DOB= 'Date of birth';

  static const String PROCEED_TERMS = 'Proceed to Terms & Conditions';
  static const String VALID_EMAIL = 'Enter valid email';
  static const String SPECIAL_CHAR = 'No special characters allowed';
  static const String PASSWORD_MATCH = 'Password must be 8+ chars with letters, numbers & special char';
  static const String CONFIRM = 'Confirm password required';
  static const String NOT_MATCH = 'Passwords do not match';
  static const String REQUIRED = 'Password required';
  static const String MOBILE = 'Mobile number required';
  static const String VALID_MOB = 'Enter valid 10-digit mobile number';
  static const String EMAIL_REQ = 'Email required';
  static const String RESTAURANT = 'Restaurant name required';
  static const String TITLE_1 = 'Order Confirmed\nSahara Sizzle';
  static const String TITLE_2 = 'Item Marked as Sold\nYour return window has expired.The full amount of AED[amount] has now been charged.';
  static const String TITLE_3 = 'Friendly reminder\nPlease return the leased product by 08.01.2026.';
  static const String TITLE_4 = 'Friendly reminder\nPlease return the leased product by 08.01.2026.';
  static const String TITLE_5 = 'Friendly reminder\nPlease return the leased product by 08.01.2026.';
  static const String TITLE_6 = 'Friendly reminder\nPlease return the leased product by 03.01.2026. You can also extend the lease for 5 days for a fee of AED 3';
  static const String SUB_TITLE_= 'Round Bowl | Dip Cup | Rectangular Container';
  static const String EXTEND_LEASE = 'Extend Lease Period';
  static const String PRODUCTS = 'Products';
  static const String PAY_AED = 'Confirm & Pay AED 9';
  static const String SEARCH_ADDRESS = "Search address / pincode / area";
  static const String USE_CURRENT_LOCATION = "Use Current Location";
  static const String HOME_TXT = "Home";
  static const String WORK_TXT = 'Work';
  static const String OTHER_TXT = 'Other';
  static const String SAVE_AS = 'Save as';
  static const String FLAT_FLOOR_TXT = 'Flat / Door / House';
  static const String STREET_BLOCK_TXT = 'Street / Block / City / Postal Code';
  static const String CONFIRM_CONTINUE = 'Confirm & Continue';
  static const String GO_BACK_TXT = 'Go back';
  static const String HOME = 'HOME';
  static const String ACTIVE_TXT = 'ACTIVE';
  static const String CLOSE = 'Close';
  static const String WORK = 'WORK';
  static final RegExp alphaNumericWithSpace =
  RegExp(r'^[a-zA-Z0-9 ]+$');

  static final RegExp email =
  RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$');

  static final RegExp password =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}$');

}
