class Strings {

  static String get CONTAINERS => "Containers";

  static String get ACTIVE => "Active";

  static String get RETURNED => "Returned";

  //Shared Preference Key
  static const JWT_TOKEN = 'jwt_token';
  static const IS_LOGGED_IN = 'isLoggedIn';
  static const PROFILE_DATA = 'ProfileData';

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

  //Sign Up & Login
  static const String LOGIN = "Log In";
  static const String SIGN_UP = "Sign Up";
  static const String FULL_NAME = "Full Name*";
  static const String EMAIL = 'Email ID';

  static const String RESTURANT_TITLE = 'Resturants';
  static const String SEARCH_RESTURANTS = 'Search by Resturant Name';
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
      "We've sent you a code to verify your email id on\n";
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
  static const ALREADY_HAVE_ACC = 'Already have an account?';
  static const RESET = 'Reset';
  static const SET_NEW_PASSWORD = 'Please set your new password';
  static const RESET_PASSWORD = 'Reset Password';
  static const WELCOME = 'Welcome';
  static const LOGIN_YOUR_ACC = 'Login to your account';
  static const String SIGN_UP_TTITLE = "Please provide your details below";
  static const FORGOT_PASSWORD = 'Forgot Password?';
  static const DONT_HAVE_ACC = "Don't have an account ?";
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
      'You have already verified your email. Going back may interrupt account the account setup process';
  static const String STAY_ON_THIS_PAGE = 'Stay on this page';
  static const String CONFIRM_LOGOUT = 'Confirm Logout';
  static const String SURE_LOG_OUT = 'Are you sure you want to log out?';
  static const String YES = 'Yes';
  static const String NO = 'No';
  static const String DASHBOARD_TEXT = 'Welcome! Ready to start reusing?';
  static const String BORROW_REUSABLE_CONTAINERS = 'Borrow reusable containers from your favourite\n resturants  and track returns here';

  static const String MY_QR_CODE = 'My QR Code';

  static const String CONFIRM_ACCOUNT = "Confirm Agreement & Create Account";
  static const String CONFIRM_MESSAGE = "Looks great! Tap Confirm to finish creating your\n account with the Freemium plan.";
  static const String CANCEL = "Cancel";
  static const String CREATE = "Create";
  static const String LEAVE_RESET_PASSWORD = 'Leave Reset Password?';
  static const String LEAVE_PASSWORD_TXT = 'If you go back now, your password reset process will\n be canceled.Do you still want to go back?';

}
