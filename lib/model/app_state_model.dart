import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AppStateModel extends Model {

String GET_API_ACCESS_TOKEN = 'FJALj242jfL2KL8732VBNLADCP0123';
String ACCESS_TOKEN;
String get_api_to_use_url = 'https://fast-code.ru/get_api_fabrika_edi';
String main_url;
String url;

// index for page transition
int _currentIndex = 2;
int get currentIndex => _currentIndex;
void set_currentIndex(int currentIndex) {
  _currentIndex  = currentIndex;
}

List _destinationKey;
List get destinationKey => _destinationKey;

void set_destinationKey(destinationKey) {
  _destinationKey = destinationKey;
}

// critical variables
int _delivery_byclient_discount;
int get delivery_byclient_discount => _delivery_byclient_discount;
String _delivery_byclient_address;
String get delivery_byclient_address => _delivery_byclient_address;
String _delivery_phone;
String get delivery_phone => _delivery_phone;
String _delivery_address_map;
String get delivery_address_map => _delivery_address_map;
String _delivery_main_info;
String get delivery_main_info => _delivery_main_info;

bool _delivery_byclient_discount_use = false;
bool get delivery_byclient_discount_use => _delivery_byclient_discount_use;
// endof critical variables

List _products = [];
List get products => _products;

List _categories = [];
List get categories => _categories;

List _stocks = [];
List get stocks => _stocks;

List _user_orders = [];
List get user_orders => _user_orders;

String _current_user_phone;
String get current_user_phone => _current_user_phone;

String _current_user_name;
String get current_user_name => _current_user_name;

String _current_user_password;
String get current_user_password => _current_user_password;

Map _user = {};
Map get user => _user;

Map _current_promo = {};
Map get current_promo => _current_promo;
Map _promo_in_use = {};
Map get promo_in_use => _promo_in_use;

List _user_ad = [];
List get user_ad => _user_ad;

int _sms_code;
int get sms_code => _sms_code;

Map<int,int> _cartItems = {};



// starter info method is here
Future load_start_info() async {
  // get categories on app run
  // get the api url to use
  await get_api_to_use();
  await get_critical_info();
  _categories = await getCategories();
  // check if user was logged in 
  bool logged_in = await check_user_login();
  if (logged_in) {
    try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt('user_id');
    _user = await get_user_info(user_id);
    _user_orders = await get_user_orders(user_id);
    } catch(error) {
    }
  } 
  return _categories;
}

Future get_api_to_use() async {
  String final_url = get_api_to_use_url + '?access_token=' + GET_API_ACCESS_TOKEN;
  final response = await http.get(final_url);
  Map<String, dynamic> api_info = jsonDecode(response.body);
  bool status = api_info['status'];
  if (status) {
    main_url = api_info['main_url'];
    url = api_info['api_url'];
    ACCESS_TOKEN = api_info['access_token'];
  } else {
    
  }
}

Future get_critical_info() async {
    String method = 'get_critical_info';
    String request_url = url + method;
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN;
    final response = await http.get(final_url);
    Map<String, dynamic> critical_info = jsonDecode(response.body);
    _delivery_byclient_discount = critical_info['delivery_byclient_discount'];
    _delivery_byclient_address = critical_info['delivery_byclient_address'];
    _delivery_phone = critical_info['delivery_phone'];
    _delivery_address_map = critical_info['delivery_address_map'];
    _delivery_main_info = critical_info['delivery_main_info'];
    return true;
}

void clean_user_info() async {
  shared_delete_user_id();
  _user_orders = [];
  _user = {};
  _user_ad = [];
}

Future getProducts() async {
    String method = 'get_products';
    String request_url = url + method;
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN;
    final response = await http.get(final_url);
    Map<String, dynamic> products = jsonDecode(response.body);
    _products = products['products'];
    return products['products'];
}

Future getCategories() async {
    String method = 'get_categories';
    String request_url = url + method;
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN;
    final response = await http.get(final_url).catchError((err) {
    });
    Map<String, dynamic> categories = jsonDecode(response.body);
    return categories['categories'];
}

Future get_stocks() async {
  String method = 'get_stocks';
  String request_url = url + method;
  String final_url = request_url + '?access_token=' + ACCESS_TOKEN;
  final response = await http.get(final_url).catchError((err) {
  });
  Map<String, dynamic> data = jsonDecode(response.body);
  if (data['status'] == 'success') {
    _stocks = data['stocks'];
  }
  return _stocks;
}

Future check_account_exist(current_phone) async {
  String method = 'check_account_exist';
  String user_phone = "&user_phone=" + current_phone;
  String request_url = url + method;
  String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user_phone;
  final response = await http.get(final_url).catchError((err) {
  });
  Map<String, dynamic> data = jsonDecode(response.body);
  var user_exist = data['user_exist'];
  _current_user_phone = current_phone;
  return user_exist;
}


Future auth_user(password) async {
    String method = 'auth_user';
    String user_phone = "&user_phone=" + _current_user_phone;
    String user_password = "&user_password=" + password;

    String request_url = url + method;
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user_phone + user_password;
    final response = await http.get(final_url).catchError((err) {
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool auth_status = data['auth_status'];
    // return user_exist;
    if (auth_status) {
       _user = data['user'];
      await shared_set_user_id(_user['id']);
      _user_orders = await get_user_orders(_user['id']);
    }
    return auth_status;
}

Future register_user_request(name, password) async {
    _current_user_name = name;
    _current_user_password = password;
    
    String method = 'register_user_request';
    String user_name = "&user_name=" + name;
    String user_phone = "&user_phone=" + _current_user_phone;
    String user_password = "&user_password=" + password;

    String request_url = url + method;
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user_name + user_phone + user_password;
    final response = await http.get(final_url).catchError((err) {
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool sms_send = data['sms_send'];
    // return user_exist;
    if (sms_send) {
       _sms_code = data['sms_code'];
    }
    return sms_send;
}

Future register_user_finish() async {
    String name = _current_user_name;
    String phone = _current_user_phone;
    String password = _current_user_password;

    String method = 'register_user_finish';
    String user_name = "&user_name=" + name;
    String user_phone = "&user_phone=" + phone;
    String user_password = "&user_password=" + password;

    String request_url = url + method;
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user_name + user_phone + user_password;
    final response = await http.get(final_url).catchError((err) {
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool user_registered = data['user_registered'];
    // return user_exist;
    if (user_registered) {
       _user = data['user'];
      await shared_set_user_id(_user['id']);
      _user_orders = await get_user_orders(_user['id']);
    }
    return user_registered; 
}

bool check_sms_code(sms_code) {
  sms_code = int.parse(sms_code);
  if (_sms_code == sms_code) {
    return true;
  } else {
    return false;
  }
}

List get_products_by_category(products, category_id) {
  List filtered_products = products.where((item) => item['category_id'] == category_id).toList();
  return filtered_products;
}

Future check_user_login() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int user_id = prefs.getInt('user_id');
  if (user_id == null) {
    return false;
  } else {
    return true;
  }
}

void shared_set_user_id(int user_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('user_id', user_id);
}

void shared_delete_user_id() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  _user = {};
}

Future get_user_info(int user_id) async {
    String method = 'get_user_info';
    String request_url = url + method;
    String user = '&user_id=' + user_id.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user;
    final response = await http.get(final_url).catchError((err) {
    }); 
    Map<String, dynamic> data = jsonDecode(response.body);
    _user = data['user'];
    return data['user'];
}

Future get_user_orders(user_id) async {
    String method = 'get_user_orders';
    String request_url = url + method;
    String user = '&user_id=' + user_id.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user;
    final response = await http.get(final_url).catchError((err) {
    }); 
    Map<String, dynamic> data = jsonDecode(response.body);
    _user_orders = data['orders'];
    return data['orders'];
}
Future get_user_addresses() async {
    int user_id = _user['id'];
    String method = 'get_user_addresses';
    String request_url = url + method;
    String user = '&user_id=' + user_id.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user;
    final response = await http.get(final_url).catchError((err) {
    }); 
    Map<String, dynamic> data = jsonDecode(response.body);
    _user_ad = data['addresses'];
    return data['addresses'];
}
Future delete_user_address(ad_id) async {
    int user_id = _user['id'];
    String method = 'delete_user_address';
    String request_url = url + method;
    String user = '&user_id=' + user_id.toString();
    String address_id = '&address_id=' + ad_id.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user + address_id;
    final response = await http.get(final_url).catchError((err) {
    }); 
    Map<String, dynamic> data = jsonDecode(response.body);
}
Future create_user_address(city, street, house, flat) async {
    int user_id = _user['id'];
    String method = 'create_user_address';
    String request_url = url + method;
    String user = '&user_id=' + user_id.toString();
    String ad_city = '&city=' + city.toString();
    String ad_street = '&street=' + street.toString();
    String ad_house = '&house=' + house.toString();
    String ad_flat = '&flat=' + flat.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user + ad_city + ad_street + ad_house + ad_flat;
    final response = await http.get(final_url).catchError((err) {
    }); 
    Map<String, dynamic> data = jsonDecode(response.body);
}

Future change_user_password(password) async {
    int user_id = _user['id'];
    String method = 'change_user_password';
    String request_url = url + method;
    String user = '&user_id=' + user_id.toString();
    String new_password = "&password=" + password.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user + new_password;
    final response = await http.get(final_url).catchError((err) {
    }); 
    Map<String, dynamic> data = jsonDecode(response.body);
    bool password_changed = data['password_changed'];
    return password_changed;
}

Future create_order_not_auth(
  delivery_method, 
  payment_method, 
  order_address,
  user_name,
  user_phone) async {
    String method = 'create_order_not_auth';
    String request_url = url + method;
    String _delivery_method = '&delivery_method='+delivery_method.toString();
    String _payment_method = '&payment_method='+payment_method.toString();
    String _order_address = '&order_address='+order_address.toString();
    String _user_name = '&user_name='+user_name.toString();
    String _user_phone = '&user_phone='+ '7' + user_phone.toString();
    // String new_password = "&password=" + password.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN+
    _delivery_method + _payment_method + _order_address + 
    _user_name + _user_phone;

    Map mydata = {
      'cart_items': get_items_in_cart(),
      'purchase_amount': get_cart_amount(),
      'delivery_discount_use': delivery_byclient_discount_use,
    };  
    var response = await http.post('$final_url',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(mydata),
  ).catchError((err) {
  });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool order_created = data['order_created'];
    return order_created;
}

Future create_order_auth(
  delivery_method, 
  payment_method, 
  order_address_id,) async {
    String method = 'create_order_auth';
    String request_url = url + method;
    String user = '&user_id=' + _user['id'].toString();
    String _delivery_method = '&delivery_method='+delivery_method.toString();
    String _payment_method = '&payment_method='+payment_method.toString();
    String _order_address_id = '&order_address_id='+order_address_id.toString();
    // String new_password = "&password=" + password.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + user +
    _delivery_method + _payment_method + _order_address_id;

    Map mydata = {
      'promo_used': _promo_in_use,
      'cart_items': get_items_in_cart(),
      'purchase_amount': get_cart_amount(),
      'delivery_discount_use': delivery_byclient_discount_use,
    };  
    var response = await http.post('$final_url',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(mydata),
  ).catchError((err) {
  });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool order_created = data['order_created'];
    return order_created;
}
Future verify_get_promo(String input_promo_code) async {
    _current_promo = null;
    String method = 'check_promo';
    String request_url = url + method;
    String promo_code = '&promo_code=' + input_promo_code.toString();
    String final_url = request_url + '?access_token=' + ACCESS_TOKEN + promo_code;
    final response = await http.get(final_url).catchError((err) {
    }); 
    Map<String, dynamic> data = jsonDecode(response.body);
    bool promo_status = data['promo_status'];
    if (promo_status) {
      Map current_promo = data['promo'];
      _current_promo = current_promo;
    }
    return promo_status;
}

String check_promo_cart() {
  if (_current_promo == null) {
    return 'Ошибка обработки промокода';
  }
  String promo_msg = '';
  List promo_products_ids = get_promo_products_ids();
  List promo_categories_ids = get_promo_categories_ids();
  if (_current_promo['from_amount'] > get_cart_amount()) {
    promo_msg = "Данный промокод действует при заказе от ${_current_promo['from_amount']} руб.";
    return promo_msg;
  }
  if (promo_products_ids.isEmpty && promo_categories_ids.isEmpty) {
    promo_msg = 'can apply promo';
    apply_promo();
    return promo_msg;
  }
  List cart_products_ids = get_cart_items_ids();
  List cart_categories_ids = get_cart_items_categories_ids();
  bool any_category_contains = false;
  bool any_product_contains = false;

  if (promo_products_ids.isNotEmpty) {
  for (int cart_item_id in cart_products_ids) {
    if (promo_products_ids.contains(cart_item_id)) {
      any_product_contains = true;
    }
  }
  }
  if (promo_categories_ids.isNotEmpty) {
  for (int cart_item_category_id in cart_categories_ids) {
    if (promo_categories_ids.contains(cart_item_category_id)) {
      any_category_contains = true;
    }
  }
  }
  if (!any_product_contains && !any_category_contains) {
    promo_msg = 'Данный промокод не подходит к выбранным товарам в корзине';
    return promo_msg;
  }
  if (any_product_contains | any_category_contains) {
    // promo_msg = 'Промокод может быть применен';
    apply_promo();
    return promo_msg;
  }
  // promo_msg = '$promo_products_ids | $promo_categories_ids';
  return '';
}
void apply_promo() {
  _promo_in_use = new Map.from(_current_promo);
}
void delete_promo() {
  _promo_in_use = {};
  _current_promo = {};
}

List get_promo_products_ids() {
  List promo_products_ids = [];
  if (_current_promo['promo_products'].isEmpty) {
    return [];
  } 
  for (Map product in _current_promo['promo_products']) {
    promo_products_ids.add(product['id']);
  }
  return promo_products_ids;
}
List get_promo_categories_ids() {
  List promo_categories_ids = [];
  if (_current_promo['promo_categories'].isEmpty) {
    return [];
  } 
  for (Map category in _current_promo['promo_categories']) {
    promo_categories_ids.add(category['id']);
  }
  return promo_categories_ids;
}

// cart logic block here
List get_cart_items_categories_ids() {
  List categories_ids = [];
  List items_ids = get_cart_items_ids();
  for (Map product in products) {
    if (items_ids.contains(product['id'])) {
      categories_ids.add(product['category_id']);
    }
  }
  return categories_ids;
}
List<int> get_cart_items_ids() {
  return _cartItems.keys.toList();
}

void add_cart_item(int product_id) {   
  if (_cartItems.keys.contains(product_id)) {
    _cartItems[product_id] += 1;
  } else {
    _cartItems[product_id] = 1;
  }
}

void add_cart_item_quantity(int product_id) {
  _cartItems[product_id] += 1;
}
void remove_cart_item_quantity(int product_id) {
  delete_promo();
  if (_cartItems[product_id] == 1) {
    _cartItems.remove(product_id);
  } else {
  _cartItems[product_id] -= 1;
  }
}
void delete_cart_item(int product_id) {
  delete_promo();
  _cartItems.remove(product_id);
}
void delete_all_cart() {
  delete_promo();
  _cartItems = {};
}
int get_cart_item_price(cart_item) {
  if (cart_item['sale_price'] > 0) {
    return cart_item['sale_price'];
  } else {
    return cart_item['price'];
  }
}
bool check_product_in_promo(item) { 
  List promo_products_ids = get_promo_products_ids();
  List promo_categories_ids = get_promo_categories_ids();
  if (promo_categories_ids.isEmpty && promo_categories_ids.isEmpty) {
    return true;
  }
  if (promo_products_ids.isNotEmpty) {
    if (promo_products_ids.contains(item['id'])) {
      return true;
    }
  }
  if (promo_categories_ids.isNotEmpty) {
    if (promo_categories_ids.contains(item['category_id'])) {
      return true;
    }
  }
  return false;
}
int get_cart_amount() {
  List cart_items = get_items_in_cart();
  int cart_amount = 0;
  for (Map item in cart_items) {
    int item_price = get_cart_item_price(item);
    if (_promo_in_use.isNotEmpty) {
      bool product_in_promo = check_product_in_promo(item);
      if (product_in_promo) {
        item_price = item_price - (promo_in_use['discount'] * item_price / 100).toInt();
      }
    }
    cart_amount += item_price * item['quantity'];
  }
  if (_delivery_byclient_discount_use) {
    cart_amount = cart_amount - ((cart_amount * delivery_byclient_discount) / 100).toInt();
  }
  return cart_amount;
}

int get_order_total_amount() {
  return get_cart_amount();
}

List get_items_in_cart() {
  List items_in_cart = [];
  for (int item in _cartItems.keys) {
    int item_quantity = _cartItems[item];
    Map current_product = _products.where((pr) => pr['id'] == item).toList()[0];
    current_product['quantity'] = item_quantity;
    items_in_cart.add(current_product);
  }
  return items_in_cart;
}
int get_cart_items_length() {
  return _cartItems.length;
}

String format_address(Map ad) {
  String city = 'г. ' + ad['city'] + ', ул. ';
  String street = ad['street'] + ', ';
  String house = ad['house'];
  String adr = city + street + house;
  if (ad['flat'].length > 0) {
    adr += ', кв. ' + ad['flat'];
  }
  return adr;
}
Map get_user_address_by_id(id) {
  Map current_ad = _user_ad.firstWhere((ad) => ad['id'] == id);
  return current_ad;
}

void check_set_delivery_discount() {
  if (_promo_in_use.isEmpty) {
    _delivery_byclient_discount_use = true;    
  }
}
void remove_delivery_discount() {
  _delivery_byclient_discount_use = false;
}

}




