import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key }) : super(key: key);

  @override RegisterPageState createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  var _name;
  var _password;

  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override 
  void dispose() {
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
  void set_fields(name, password) {
    setState(() {
        _name = name;
        _password = password;    
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
          return Form(
            key: _formKey,
            child: Container(
            padding: EdgeInsets.only(top: 45, bottom: 15, left: 10, right: 10),
            child: Container(
              child: Column(
                children: [
                NiceTitle('+ ${model.current_user_phone}'),
                Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите ваше Имя';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Ваше имя',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        prefixIcon: Icon(Icons.account_circle,
                        color: Colors.deepOrange),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.deepOrange,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                    ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите ваш пароль';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Ваш пароль',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        prefixIcon: Icon(Icons.enhanced_encryption_rounded,
                        color: Colors.deepOrange),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.deepOrange,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                    ),
                ),
                  Container(
                  alignment: Alignment.centerRight,
                  // padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () async {
                        // learn hot to get text field value
                        var current_name = nameController.text;
                        var current_password = passwordController.text;
                        set_fields(current_name, current_password);
                        bool form_valid = validateform();
                        if (form_valid) {
                          bool sms_sent = await model.register_user_request(
                            current_name,
                            current_password
                          );
                          if (sms_sent) {
                            print('sms send on phone, go to sms confirm page');
                            Navigator.pushNamed(context, '/sms_confirm_page');
                          } else {
                            print('sms is not send, print the error');
                          }
                        }
                      },
                      child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Container(
                          child: Text('Далее', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          )),
                          alignment: Alignment.center,
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.arrow_forward_ios_outlined, size: 16.0),
                        ),
                      ],),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15)),
                      ),
                    ),
                  ),
              ),
              ],),
            ),
            ),
        );
  }
    ),
  );
  }// Widget build
  bool validateform() {
    print('start form validating');
    if (_formKey.currentState.validate()) {
      // print('phone validated');
      // var phone = _formKey.currentState.;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Проверка данных для аккаунта ...'),
        )
      );
      return true;
    }
    return false;
  } 
}