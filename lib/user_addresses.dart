import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'main.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';


class UserAddressesPage extends StatefulWidget {

  const UserAddressesPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _UserAddressesPageState createState() => _UserAddressesPageState();
}

class _UserAddressesPageState extends State<UserAddressesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.user_ad.isEmpty) {
            return FutureBuilder(
              future: model.get_user_addresses(),
              builder: (context, ads) {
                if (!ads.hasData) {
                  return Center(child: Text('Загрузка данных...'));
                }
                if (ads.hasError) {
                  return Center(
                    child: Text('Возникла ошибка во время загрузки адресов')
                  );
                } else if (ads.hasData) {
                  return AdsList(context, this, model.user_ad);
                }
              },
            );
          } else { 
            // return Stack(children: [
              return AdsList(context, this, model.user_ad);
              // ],);
          }
        }
      )
    );
  }
}


Widget AdsList(BuildContext context, parent, ads) {
  List<Widget> ads_widgets = [];
  if (ads.isEmpty) {
    ads_widgets.add(Text('У вас не добавлено ни одного адреса. Добавьте новый, чтобы он здесь отобразился'));
  } else {
  for (Map ad in ads) {
    ads_widgets.add(AdItem(context, parent, ad));
  }
  }
  return ScopedModelDescendant<AppStateModel> (
   builder: (context, child, model) {
     return Container(
       margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
       child: ListView(
         children: [
         Column(children: ads_widgets),
         AddAdButton(context, parent, model),
       ],)  
     );
   }
 );
}

Widget AdItem(BuildContext context, parent, ad) {
  return ScopedModelDescendant<AppStateModel>(
  builder: (context, child, model) {
    return Container(
    padding: EdgeInsets.only(top: 10, left: 10, right: 7),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Flexible(
      child: Text('${model.format_address(ad)}'),
      ),
      Row(children: [
      Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteAdDialog(
              context, 
              parent,
              ad,
              model,
            );
          }
        );
      },
      child: Icon(Icons.delete, color: Colors.deepOrange),
      ),
      ),
      ],)
    ],),
  );
  },
  );
}

Widget DeleteAdDialog(context, parent, ad, model) {
  return AlertDialog(
        title: Text('Удаление адреса'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Вы уверены, что хотите удалить данный адрес?',
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: Text(
                '${model.format_address(ad)}', style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Да', style: TextStyle(
              color: Colors.red,
            )),
            onPressed: () async {
              await model.delete_user_address(ad['id']);
              await model.get_user_addresses();
              parent.setState((){});
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Нет', style: TextStyle(
              color: Colors.black87,
            )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}

Widget AddAdButton(BuildContext context, parent, model) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      height: 40,
    child: ElevatedButton(
      onPressed: () {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddAddressDialog(model, parent);
          }
        );
      },
      // child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          child: Container(
            child: Text('Добавить адрес', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            )),
            alignment: Alignment.center,
          ),
        // ],),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15)),
        ),
    ),
    ),
  );
}



class AddAddressDialog extends StatefulWidget {
  dynamic parent;
  AppStateModel model;
  AddAddressDialog(this.model, this.parent);
  @override
  _AddAddressDialogState createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();


  var _ad_city;
  var _ad_street;
  var _ad_house;
  var _ad_flat;
  var _ad_comment;

  final ad_cityController = TextEditingController();
  final ad_streetController = TextEditingController();
  final ad_houseController = TextEditingController();
  final ad_flatController = TextEditingController();
  final ad_commentController = TextEditingController();

  @override 
  void dispose() {
    ad_cityController.dispose();
    ad_streetController.dispose();
    ad_houseController.dispose();
    ad_flatController.dispose();
    ad_commentController.dispose();
    super.dispose();
  }
  void set_fields(ad_city, ad_street, ad_house, ad_flat, ad_comment) {
    setState(() {
        _ad_city = ad_city;
        _ad_street = ad_street;
        _ad_house = ad_house;
        _ad_flat = ad_flat;
        _ad_comment = ad_comment;
      });
  }
  @override
  Widget build(BuildContext context) {
      return AlertDialog(
      title: Text('Добавление адреса'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                        controller: ad_cityController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Введите ваш город';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Город',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                        controller: ad_streetController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Введите вашу улицу';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Улица',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          // prefixIcon: Icon(Icons.account_circle,
                          // color: Colors.deepOrange),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                        controller: ad_houseController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Введите номер дома';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Дом',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          // prefixIcon: Icon(Icons.account_circle,
                          // color: Colors.deepOrange),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                        controller: ad_flatController,
                        validator: (value) {
                        },
                        decoration: InputDecoration(
                          labelText: 'Квартира',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          // prefixIcon: Icon(Icons.account_circle,
                          // color: Colors.deepOrange),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                ],),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Сохранить', style: TextStyle(
            color: Colors.red,
          )),
          onPressed: () async {
            // call set state just to reload the page
            var city = ad_cityController.text;
            var street = ad_streetController.text;
            var house = ad_houseController.text;
            var flat = ad_flatController.text;
            set_fields(city, street, house, flat, '');
            bool required_not_empty = validateform();
            if (required_not_empty) {
              await widget.model.create_user_address(city, street, house, flat);
              await widget.model.get_user_addresses();
              this.widget.parent.setState(() {});             
              Navigator.of(context).pop();
            }
            // Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Отмена', style: TextStyle(
            color: Colors.black87,
          )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }


bool validateform() {
    if (_formKey.currentState.validate()) {
      return true;
    }
    return false;
} 

}
