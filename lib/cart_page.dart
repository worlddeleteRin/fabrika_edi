
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'main.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';

import 'package:auto_size_text/auto_size_text.dart';

class CartPage extends StatefulWidget {

  const CartPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _formKey = GlobalKey<FormState>();
  final promoController = TextEditingController();
  String _promo_check_status = '';
  void set_promo_status(String new_status) {
    setState(() {
        _promo_check_status = new_status;
      });
  }
  bool validateform() {
    if (_formKey.currentState.validate()) {
      return true;
    }
    return false;
  }
  // List cart_items = [];
  // int cart_amount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          model.remove_delivery_discount();
          int cart_amount = model.get_cart_amount();
          List cart_items = model.get_items_in_cart();
          List<Widget> cart_items_widgets = [];
          if (cart_items.isEmpty) {
            return EmptyCartWidget(context, model);
          }
          for (Map cart_item in cart_items) {
            cart_items_widgets.add(CartItemRow(cart_item, this));
          }
          return Container(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
            child: ListView(children: [
              NiceTitle('Корзина'), 
              Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(children: cart_items_widgets),
              ),
              // display promo widget or promo used, if it is used
              // Text('promo is ${model.promo_in_use}'),
              model.promo_in_use.isEmpty ?  
              PromoWidget(this): 
              PromoUsedWidget(this),
              // 
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Text('Сумма заказа: ', style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
                  Text('${cart_amount} ₽', style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ))
                ],),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/offer_page');
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
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15)),
                ),
                ),
              ),
            ],),
          );
        }
      )
    );
  }
}

Widget CartItemRow(cart_item, _CartPageState parent) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 20.0,
            spreadRadius: -20.0,
            color: Colors.black87,
          )
        ],
      ),
      height: 120,
      child: Stack(children: [
      Positioned(
        top: -5,
        right: 0,
        child: GestureDetector(
          onTap: () {
            model.delete_cart_item(cart_item['id']);
            parent.setState(() {});
          },
          child: Container(
            child: Icon(Icons.close,
            color: Colors.red,
            ),
          ),
        ),
      ),    
      Row(
        // direction: Axis.vertical,
        // mainAxisSize: MainAxisSize.,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
       CachedNetworkImage(
          imageUrl: model.main_url + cart_item['imgsrc'],
          placeholder: (context, url) => CircularProgressIndicator.adaptive(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          // width: 300,
          height: 80,
          width: 100,
          fit: BoxFit.contain,
        ),
        Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.only(left: 8, right: 0),
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                // color: Colors.yellow,
              ),
              child: AutoSizeText('${cart_item['name'].trim()}',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              minFontSize: 11,
              maxLines: 2, 
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Row(children: [
                ElevatedButton(
                onPressed: () {
                  model.remove_cart_item_quantity(cart_item['id']);
                  parent.setState(() {});
                },
                child: Icon(Icons.remove, color: Colors.white,
                size: 16.0),
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  primary: Colors.deepOrange,
                  onPrimary: Colors.deepOrange,
                  side: BorderSide(color: Colors.deepOrange, width: 1),
                  elevation: 4.0,
                  shape: CircleBorder(),

                ),
              ),
              Container(
                child: Text('${cart_item['quantity']}', style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ))
              ),
              ElevatedButton(
                onPressed: () {
                  model.add_cart_item_quantity(cart_item['id']);
                  parent.setState(() {});
                },
                child: Icon(Icons.add, color: Colors.white,
                size: 16.0),
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  primary: Colors.deepOrange,
                  onPrimary: Colors.deepOrange,
                  side: BorderSide(color: Colors.deepOrange, width: 1),
                  elevation: 4.0,
                  shape: CircleBorder(),
                ),
              ),
            ],),
            Container(
              padding: EdgeInsets.only(right: 8),
              alignment: Alignment.topRight,
              child: Text('${model.get_cart_item_price(cart_item) * cart_item['quantity']} ₽', style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              )),
            ),
          ],),
        ],),
        ),
    ],),
    ],)
      );
  }
  );
}

Widget PromoWidget(parent) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: AutoSizeText('${parent._promo_check_status}',
          ),
        ),
        Form(
          key: parent._formKey,
          child: TextFormField(
            controller: parent.promoController,
            validator: (value) {
              if(value.isEmpty) {
                return 'Введите промокод';
              } 
              return null;
            },
            decoration: InputDecoration(
            labelText: 'Есть промокод? Вводи!',
            labelStyle: TextStyle(
              color: Colors.black87,
            ),
            // prefixIcon: Icon(Icons.account_circle,
            // color: Colors.deepOrange),
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
              parent.set_promo_status('');
              bool form_valid = parent.validateform();
              if (form_valid) {
                if (model.user.isEmpty) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DefaultAlert(context, 
                      'Пользователь не авторизован', 
                      'Создайте или войдите в свой аккаунт, чтобы использовать промокоды!');
                    }
                  );
                }
                String input_promo = parent.promoController.text;
                bool promo_status = await model.verify_get_promo(input_promo);
                if (!promo_status) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DefaultAlert(context, 
                      'Неверный промокод', 
                      'Введенный вами промокод не найден');
                    }
                  );
                } else {
                  String promo_check_status = model.check_promo_cart();
                  parent.set_promo_status(promo_check_status);
                }
              }
            },
            child: Container(
              child: Container(
                child: Text('Применить', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                )),
                alignment: Alignment.center,
              ),
              ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15)),
            ),
          ),
        ],)
      );
    }
  ); 
}

Widget PromoUsedWidget(parent) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
      return Container(
        child: Column(children: [
          Text('Промокод ${model.promo_in_use['code']} успешно использован!', style: TextStyle(
          color: Colors.black,
          ),),
          Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: ElevatedButton(
            onPressed: () {
              model.delete_promo();
              parent.setState(() {});
            },
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                child: Text('Отменить', style: TextStyle(
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
          ),
          ),
        ],),
      );
    }
  );
}

Widget EmptyCartWidget(context, model) {
  return Container(
    padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
    child: ListView(children: [
      NiceTitle('Корзина'),
      Column( 
      children: [
      Container(
        margin: EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
        child: Text('На данный момент ваша корзина пуста.', style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ))
      ),
      Container(
        margin: EdgeInsets.only(top: 18.0),
        child: ElevatedButton(
          onPressed: () async {
            model.set_currentIndex(2);
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false );
            AppBuilder.of(context).rebuild();
            // return main_app();
          },
          child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                child: Text('В каталог', style: TextStyle(
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
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15)),
            ),
        )
      ),
      ],)
    ],)
  );
}