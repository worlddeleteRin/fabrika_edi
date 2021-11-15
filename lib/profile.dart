import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'useful_widgets.dart';

import 'profile_main_page.dart';

import 'package:loader_overlay/loader_overlay.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _current_phone = '';
  void set_phone(phone) {
    setState(() {
      _current_phone = phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.user.isEmpty) {
            return ProfileLogin();
          } else {
            return ProfileMainPage(parent: this);
          }
        }
      );
  }
}

class ProfileLogin extends StatefulWidget {
  ProfileLogin({Key key }) : super(key: key);

  @override ProfileLoginState createState() {
    return ProfileLoginState();
  }
}

class ProfileLoginState extends State<ProfileLogin> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(mask: '+7 (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });
  var _phone;
  void set_phone(phone) {
    setState(() {
        _phone = phone;    
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
                NiceTitle('НОМЕР ТЕЛЕФОНА'),
                Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        var current_phone = maskFormatter.getUnmaskedText();
                        if (value.isEmpty) {
                          return 'Введите ваш номер телефона';
                        }
                        else if (current_phone.length < 10) {
                          return 'Номер введен не корректно';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Ваш номер телефона',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        hintText: '+7(xxx)-xxx-xx-xx',
                        prefixIcon: Icon(Icons.phone_android_sharp,
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
                      inputFormatters: [maskFormatter]
                    ),
                ),
                  Container(
                  alignment: Alignment.centerRight,
                  // padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () async {
                        var current_phone = maskFormatter.getUnmaskedText();
                        current_phone = '7' + current_phone;
                        set_phone(current_phone);
                        bool phone_valid = validateform();
                        if (phone_valid) {
                          context.showLoaderOverlay();
                          bool exist = await model.check_account_exist(current_phone);
                          context.hideLoaderOverlay();
                          // Navigator.of(context).pop();
                          if (exist) {
                            Navigator.pushNamed(context, '/login_page');
                          } else {
                            Navigator.pushNamed(context, '/register');
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
    if (_formKey.currentState.validate()) {
      return true;
    }
    return false;
  } 
}