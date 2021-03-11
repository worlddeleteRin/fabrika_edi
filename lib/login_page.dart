import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key }) : super(key: key);

  @override LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var _password;

  final passwordController = TextEditingController();

  @override 
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
  void set_password(password) {
    setState(() {
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
                NiceTitle('Пароль'),
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
                        var current_password = passwordController.text;
                        set_password(current_password);
                        bool password_valid = validateform();
                        if (password_valid) {
                          bool auth_success = await model.auth_user(current_password);
                          if (auth_success) {
                            print('auth success. need to log in user');
                            Navigator.pushNamed(context, '/profile');
                          } else {
                            print('password is not correct');
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
          content: Text('Проверка пароля для аккаунта ...'),
        )
      );
      return true;
    }
    return false;
  } 
}