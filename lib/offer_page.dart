import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'user_addresses.dart';
import 'dart:core';

class OfferPage extends StatefulWidget {

  const OfferPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  final _notauth_ad_formKey = GlobalKey<FormState>();
  final _payment_formKey = GlobalKey<FormState>();
  final notauthAdController = TextEditingController();
  final notauthNameController = TextEditingController();
  var notauthphoneFormatter = new MaskTextInputFormatter(mask: '+7 (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });
  var _notauthPhone;
  String _current_order_address = '';
  int _delivery_radio_value;
  String _current_order_payment = 'Наличными';
  List<bool> _delivery_selected = [true, false];
  List<bool> _payment_selected = [true, false];

  void _handleDeliveryRadioValueChange(int value) {
    setState(() {
          _delivery_radio_value = value;
      });
  }
  void set_current_order_payment(int index) {
    if (index == 0) {
      _current_order_payment = 'Наличными';
    } else {
      _current_order_payment = 'Картой курьеру';
    }
  }
  int get_delivery_method() {
    if (_delivery_selected[0] == true) {
      return 1;
    } else {
      return 2;
    }
  }
  int get_payment_method() {
    if (_payment_selected[0] == true) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (_delivery_selected[1] == true) {
            model.check_set_delivery_discount();
          } else {
            model.remove_delivery_discount();
          }
          return FutureBuilder(
            future: model.get_user_addresses(),
            builder: (context, ads) {
              List ads = model.user_ad;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: ListView(children: [
                  NiceTitle('Оформление заказа'),
                  model.user.isEmpty ? UserInfoBlock() : Text(''),
                  DeliveryBlock(context, this, ads),
                  PaymentBlock(),
                  OrderInfo(),
                  CreateOrderButton(),
                ],)
              );
            }
          );
        }
      ),
    );
  }


Widget DeliveryBlock(context, parent, ads) {
  List<Widget> ads_widgets = [];
  if (ads.isEmpty) {
    ads_widgets.add(Text('У вас не добавлено ни одного адреса. Добавьте новый, чтобы он здесь отобразился'));
  } else {
  for (Map ad in ads) {
    ads_widgets.add(AdItemCart(context, parent, ad));
  }
  }
  return ScopedModelDescendant<AppStateModel> (
   builder: (context, child, model) {
     return Container(
       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(8.0),
         boxShadow: [
           BoxShadow(
             color: Colors.black87,
             blurRadius: 13,  
             spreadRadius: -10.0,
           )
         ]
       ),
       child: Column(
         children: [
          Container(
            margin: EdgeInsets.only(top: 5, left: 8, bottom: 12),
            alignment: Alignment.centerLeft,
              child: Text('Способ доставки', style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )),
         ),
         ToggleButtons(
           children: [
             Container(
             padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
             child: Text('Доставка'),
             ),
             Container(
             padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
             child: Text('Самовывоз'),
             ),
           ],
          selectedColor: Colors.white,
          fillColor: Colors.deepOrange,
          borderRadius: BorderRadius.circular(10.0),
           onPressed: (int index) {
            setState(() {
              _current_order_address = '';
              _delivery_radio_value = null;
              for (int buttonIndex = 0; buttonIndex < _delivery_selected.length; buttonIndex++) {
                if (buttonIndex == index) {
                  _delivery_selected[buttonIndex] = true;
                } else {
                  _delivery_selected[buttonIndex] = false;
                }
              }
            });
          },
          isSelected: _delivery_selected,
         ),

        //  check if delivery method is delivery
         _delivery_selected[0] == true ?
         model.user.isNotEmpty ? 
         (Column(children: [
         Column(children: ads_widgets),
         AddAdButton(context, parent, model),
         ],)) : 
         (NotAuthorizedAddress()) :
          Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text('Адрес самовывоза: ${model.delivery_byclient_address}')
          ),
          //  end dcheck if delivery method is delivery

       ],),
     );
   }
 );
}



Widget AdItemCart(context, parent, ad) {
  return ScopedModelDescendant<AppStateModel>(
  builder: (context, child, model) {
    int radio_value = ad['id'];
    return GestureDetector(
      onTap: () {
        _handleDeliveryRadioValueChange(radio_value);
         Map current_ad = model.get_user_address_by_id(_delivery_radio_value);
          setState(() {
            _current_order_address = model.format_address(current_ad);
          });
      },
    child: Container(
    padding: EdgeInsets.only(top: 10, left: 10, right: 7),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Row(children: [
        Radio(
        value: radio_value,
        groupValue: _delivery_radio_value,
        onChanged: _handleDeliveryRadioValueChange
        ),
      Flexible(
      child: Text('${model.format_address(ad)}'),
      ),
      ],),),
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
    ),
  );
  },
  );
}

Widget NotAuthorizedAddress() {
  return Container(
    child: Form(
      key: _notauth_ad_formKey,
      child: Column(children: [
        Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: TextFormField(
                onChanged: (text)  {
                setState(() {
                  _current_order_address = text;
                });
                },
                controller: notauthAdController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введите адрес доставки';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Адрес доставки',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  prefixIcon: Icon(Icons.location_on,
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
      ],)
    )
  );
}

Widget PaymentBlock() {
  return Container(
    alignment: Alignment.center,
    // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
    padding: EdgeInsets.symmetric(vertical: 17, horizontal: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
         boxShadow: [
           BoxShadow(
             color: Colors.black87,
             blurRadius: 13,  
             spreadRadius: -10.0,
           )
         ]
      ),
    child: Column(children: [
      Container(
      margin: EdgeInsets.only(top: 5, left: 13, bottom: 12),
      alignment: Alignment.centerLeft,
      child: Text('Способ оплаты', style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      )),
      ),
    ToggleButtons(
        children: [
          Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Text('Наличными'),
          ),
          Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Text('Картой курьеру'),
          ),
        ],
      selectedColor: Colors.white,
      fillColor: Colors.deepOrange,
      borderRadius: BorderRadius.circular(10.0),
        onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < _payment_selected.length; buttonIndex++) {
            if (buttonIndex == index) {
              _payment_selected[buttonIndex] = true;
            } else {
              _payment_selected[buttonIndex] = false;
            }
          }
          set_current_order_payment(index);
        });
      },
      isSelected: _payment_selected,
      ),
      ],),
  );
}

Widget OrderInfo() {
  return ScopedModelDescendant<AppStateModel> (
    builder: (context, child, model) {
    return Container(
      decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(8.0),
         boxShadow: [
           BoxShadow(
             color: Colors.black87,
             blurRadius: 13,  
             spreadRadius: -10.0,
           )
         ]
       ),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        NiceTitleGrey('Адрес доставки:'),
        NiceTitleBold('$_current_order_address', 15.0),
        Container(margin: EdgeInsets.only(top: 12)),
        NiceTitleGrey('Способ оплаты:'),
        NiceTitleBold('$_current_order_payment', 15.0),
        Container(margin: EdgeInsets.only(top: 12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          NiceTitleBold('Итого к оплате: ', 17.0),
          NiceTitleBold('${model.get_order_total_amount()} ₽', 17.0),
        ],)
      ],),
    );
  }
  );
}


Widget CreateOrderButton() {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
    return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: ElevatedButton(
    onPressed: () async {
      int delivery_method = get_delivery_method();
      int payment_method = get_payment_method();
      if (model.get_cart_items_length() > 0) { 
      if (model.user.isEmpty) {
        String user_name = notauthNameController.text;
        if (user_name.length < 1) {
          return showDialog(
          context: context,
          builder: (BuildContext context) {
            return DefaultAlert(context, 'Укажите ваше Имя', 
            'Укажите ваше имя, чтобы наш менеджер знал, как к вам обратиться');
            }
          );
        }
        String user_phone = notauthphoneFormatter.getUnmaskedText();
        if (user_phone.length < 8) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return DefaultAlert(context, 'Укажите ваш номер телефона', 
              'Корректно укажите ваш номер телефона, чтобы мы могли с вами связаться');
              }
            );
        }
        String delivery_address = 'Самовывоз';
        if (delivery_method == 1) {
          delivery_address = _current_order_address;
          if (delivery_address.length < 1) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return DefaultAlert(context, 'Укажите адрес доставки', 
              'Вы выбрали доставку, однако не указали адрес');
              }
            );
          }
        }
        bool order_created = await model.create_order_not_auth(delivery_method, 
        payment_method, 
        delivery_address, 
        user_name, 
        user_phone);
        if (order_created) {
          model.delete_all_cart();
          Navigator.pushNamed(context, '/order_created');
        } else {
          // need to return an error dialog
        }
      } else {
        int delivery_address_id = 2;
        if (delivery_method == 1) {
          delivery_address_id = _delivery_radio_value;
          if (_delivery_radio_value == null) {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return DefaultAlert(context, 'Укажите адрес доставки', 
                'Вы выбрали доставку, однако не указали адрес');
                }
              );
          }
        };
        bool order_created = await model.create_order_auth(
          delivery_method,
          payment_method,
          delivery_address_id,
        );
        if (order_created) {
          await model.get_user_orders(model.user['id']);
          model.delete_all_cart();
          Navigator.pushNamed(context, '/order_created');
        } else {
          // need to return an error dialog
        }
      } 
      } else {
        // cart is empty
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return DefaultAlert(context, 'Ваша корзина пуста', 
          'Добавьте товар в корзину, чтобы оформить заказ');
          }
        ); 
      }
    },
    child: Stack(
    // mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
      child: Text('Оформить заказ', style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      )),
      alignment: Alignment.center,
    ),
    Container(
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      child: Icon(Icons.arrow_forward_ios_outlined, size: 16.0,
      color: Colors.white),
    ),
  ],),
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    )),
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 13, bottom: 13, left: 15, right: 15)),
  ),
    ),
  );
  }
  );
}

Widget UserInfoBlock() {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
      return Container(
        decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(8.0),
         boxShadow: [
           BoxShadow(
             color: Colors.black87,
             blurRadius: 13,  
             spreadRadius: -10.0,
           )
         ]
       ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Form(
          child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 5, left: 8, bottom: 0),
            alignment: Alignment.centerLeft,
              child: Text('Данные клиента', style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )),
          ),
          Container(
                height: 40,
                margin: EdgeInsets.only(top: 13, bottom: 10),
                child: TextFormField(
                  controller: notauthNameController,
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
                height: 40,
                margin: EdgeInsets.only(top: 0, bottom: 10),
                child: TextFormField(
                  inputFormatters: [notauthphoneFormatter],
                  // controller: notauthPhoneController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Введите ваш номер телефона';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Номер телефона',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    prefixIcon: Icon(Icons.phone,
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
          ]),
        ),
      );
    },
  );
}


}