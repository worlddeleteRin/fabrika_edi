import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  NiceTitle('Настройки'),
                  ChangePasswordForm(model, this),
                ],),
              );
            },
          );
        }
      )
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  ChangePasswordForm(this.model, this.parent);
  AppStateModel model;
  var parent;

  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  // String reg_password = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]";

  var _password1;
  var _password2;

  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();

  @override 
  void dispose() {
    password1Controller.dispose();
    password2Controller.dispose();
    super.dispose();
  }
  void set_fields(password1, password2) {
    setState(() {
        _password1 = password1;
        _password2 = password2;    
      });
  }
  void clear_passwords_fields() {
    password1Controller.clear();
    password2Controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('Смена пароля', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: TextFormField(
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: password1Controller,
                        validator: (value) {
                          var password2 = password2Controller.text;
                          if (value.isEmpty) {
                            return 'Введите новый пароль';
                          }
                          else if (value != password2) {
                            return 'Пароли не совпадают';
                          }
                          // else if(!RegExp(reg_password).hasMatch(value)) {
                          //   return 'Пароль введен не корректно';
                          // }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Новый пароль',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          prefixIcon: Icon(Icons.enhanced_encryption,
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
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: TextFormField(
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: password2Controller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Подвторите пароль';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Повторите пароль',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          prefixIcon: Icon(Icons.enhanced_encryption,
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
                  ElevatedButton(
                    onPressed: () async {
                      // need to change password
                      var password1 = password1Controller.text;
                      var password2 = password2Controller.text; 
                      bool passwords_valid = validateform();
                      if (passwords_valid) {
                        bool password_changed = await model.change_user_password(password1);
                        if (password_changed) {
                          final snackBar = new SnackBar(content: new Text('Пароль успешно изменен'),                                                         
                          backgroundColor: Colors.green);                                                                                      
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          clear_passwords_fields();
                        }
                      }
                    },
                    child: Stack(
                        children: [
                        Container(
                          child: Text('Изменить пароль', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          )),
                          alignment: Alignment.center,
                        ),
                      ],),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15)),
                      ),
                  )
              ],)
            ),
          ),
        ],),
      );
    }
    );
  }

// password form empty validation
bool validateform() {
    if (_formKey.currentState.validate()) {
      return true;
    }
    return false;
  } 


}