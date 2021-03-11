import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateModel extends Model {

String ACCESS_TOKEN = 'FJALj242jfL2KL8732VBNLADCP0123';
String main_url = 'http://127.0.0.1:8000/';
String url = 'http://127.0.0.1:8000/api/';
// String main_url = 'https://delivery.fast-code.ru/';
// String url = 'https://delivery.fast-code.ru/api/';

List _products = [];
List get products => _products;

List _categories = [];
List get categories => _categories;

List _stocks = [];
List get stocks => _stocks;

String _current_user_phone;
String get current_user_phone => _current_user_phone;

String _current_user_name;
String get current_user_name => _current_user_name;

String _current_user_password;
String get current_user_password => _current_user_password;

Map _user = {};
Map get user => _user;

int _sms_code;
int get sms_code => _sms_code;

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
      print(err);
    });
    Map<String, dynamic> categories = jsonDecode(response.body);
    return categories['categories'];
}


// starter info method is here
Future load_start_info() async {
  // get categories on app run
  _categories = await getCategories();
  // check if user was logged in 
  bool logged_in = await check_user_login();
  return _categories;
}

Future get_stocks() async {
  String method = 'get_stocks';
  String request_url = url + method;
  String final_url = request_url + '?access_token=' + ACCESS_TOKEN;
  final response = await http.get(final_url).catchError((err) {
    print(err);
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
    print(err);
  });
  Map<String, dynamic> data = jsonDecode(response.body);
  var user_exist = data['user_exist'];
  print('response from api: $user_exist');
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
      print(err);
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool auth_status = data['auth_status'];
    // return user_exist;
    print('response is $data',);
    print('auth status is $auth_status');
    if (auth_status) {
       _user = data['user'];
      print('user is $user');
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
      print(err);
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool sms_send = data['sms_send'];
    // return user_exist;
    print('response is $data',);
    print('sms send status is $sms_send');
    if (sms_send) {
       _sms_code = data['sms_code'];
      print('sms code is $_sms_code');
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
      print(err);
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    bool user_registered = data['user_registered'];
    // return user_exist;
    print('response is $data',);
    print('user registered status is $user_registered');
    if (user_registered) {
       _user = data['user'];
      print('user is $_user');
    }
    return user_registered;
}

bool check_sms_code(sms_code) {
  sms_code = int.parse(sms_code);
  print('input sms code is $sms_code');
  print('sms code need to be $_sms_code');
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
  print('prefs is ${prefs}');
  return true;
}

}