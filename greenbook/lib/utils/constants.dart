const String homePageName = 'login';
const String poolPageName = 'pool';
const String poolInventoryName = 'poolInventory';
const String adminLoginName = 'adminLogin';
const String adminDashboard = 'adminDashboard';
const String currency = '\$';

const String productConditionNew = 'New';
const String productConditionUsed = 'Used';
const String productConditionRefurbished = 'Refurbished';

const String listingStatusActive = 'Active';
const String listingStatusSold = 'Sold';
const String listingStatusExpired = 'Expired';

const String emptyFieldErrMessage = 'This field must not be empty';
const String dateErrMsg = 'Please select date';

const String accessToken = 'accessToken';
const String loginTime = 'loginTime';
const String expirationDuration = 'expirationDuration';

const String routeNameHome = 'home';
const String routeNameItemDetailsPage = 'item_details';
const String routeNameLoginPage = 'login';
const String routeNameMyItemsPage = 'my_items';
const String routeNameSellItemPage = 'sell_item';
const String routeNameEditItemPage = 'edit_item';

const List<String> categories = [
  'Electronics',
  'Clothing',
  'Furniture',
  'Books',
  'Toys',
  'Sports',
  'Home & Garden',
];

enum ResponseStatus {
  SUCCESS,
  ERROR,
  UNAUTHORIZED,
  EXPIRED,
  NONE,
}

const List<String> productConditions = [
  productConditionNew,
  productConditionUsed,
  productConditionRefurbished,
];

const List<String> productSizes = [
  'Small',
  'Medium',
  'Large',
  'Extra Large',
];
