import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';

class SmsConfirmPage extends StatefulWidget {
  SmsConfirmPage({Key key }) : super(key: key);

  @override SmsConfirmPageState createState() {
    return SmsConfirmPageState();
  }
}

class SmsConfirmPageState extends State<SmsConfirmPage> {
  final _formKey = GlobalKey<FormState>();

  var _sms_code;

  var maskFormatter = new MaskTextInputFormatter(mask: '#############', filter: { "#": RegExp(r'[0-9]') });

  @override 
  void set_sms_code(sms_code) {
    setState(() {
        _sms_code = sms_code;    
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
                NiceTitle('КОД ПОДТВЕРЖДЕНИЯ'),
                Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: TextFormField(
                      inputFormatters: [maskFormatter],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите смс код';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Код подтверждения',
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
                        var sms_code = maskFormatter.getUnmaskedText();
                        set_sms_code(sms_code);
                        bool code_not_null = validateform();
                        if (code_not_null) {
                          bool sms_valid = await model.check_sms_code(_sms_code);
                          if (sms_valid) {
                            print('sms code is valid. Need to finish user register');
                            bool user_registered = await model.register_user_finish();
                            if (user_registered) {
                            Navigator.pushNamed(context, '/profile');
                            } else {
                              print('error while finish user register');
                            }
                          } else {
                            print('sms code is not valid');
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
          content: Text('Проверка кода ...'),
        )
      );
      return true;
    }
    return false;
  } 
}