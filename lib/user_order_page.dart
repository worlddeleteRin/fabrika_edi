import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'package:flutter/material.dart';



class UserOrderPageArguments  {
  Map order;
  UserOrderPageArguments(this.order);
}

class UserOrderPage extends StatefulWidget {

  UserOrderPage({ Key key }) : super(key: key);

  // final Destination destination;

  @override
  _UserOrderPageState createState() => _UserOrderPageState();
}

class _UserOrderPageState extends State<UserOrderPage> {
  @override
  Widget build(BuildContext context) {
    final UserOrderPageArguments args = ModalRoute.of(context).settings.arguments;
    Map order = args.order;
    List<Widget> order_items = [];
    for (Map order_item in order['order_items']) {
      order_items.add(OrderItem(order_item));
    }
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: MainAppBar(), 
          body: WillPopScope(
          // onWillPop: () async => null,
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Container(
                padding: EdgeInsets.all(10),
                child: ListView(children: [
                  NiceTitle('Заказ #${order['id']}'),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Статус заказа:'),
                  ),
                  Row(children: [
                  Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
                  decoration: BoxDecoration(
                    color: order['status'] == 'in_progress' ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text('${order['status_display'].toUpperCase()}', style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  )),
                  ),
                  ],),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Дата заказа:'),
                  ),
                  Container(
                  child: Text('${order['date_display']}'),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Контактные данные:'),
                  ),
                  Container(
                  child: Row(children: [
                  Text('${order['name'].trim()}, '),
                  Text('${order['phone']}'),
                  ],)
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Способ доставки:'),
                  ),
                  Container(
                  child: Text('${order['delivery']}'),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Адрес доставки:'),
                  ),
                  Container(
                  child: Text('${order['address']}'),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Способ оплаты:'),
                  ),
                  Container(
                  child: Text('${order['payment']}'),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Сумма заказа: '),
                  ),
                  Container(
                  child: Text('${order['order_cost']} ₽', style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  )),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 1),
                    child: NiceTitle2('Состав заказа:'),
                  ),
                  Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: order_items,
                  ),
                  ),
                  // Text('${order}'),
                ],),
              );
            }
          ),
          ),
        );
      }
    );
  }
}

Widget OrderItem(order_item) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
    return Container(
    margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    // height: 70,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 9.0, // soften the shadow                
          spreadRadius: -4.0, //extend the shadow
          offset: Offset(
            0, // Move to right 10  horizontally
            0, // Move to bottom 10 Vertically
          ),
        ),
      ],
      color: Colors.white,
    ),
    width: double.infinity,
    child: Column(children: [
      CachedNetworkImage(
        imageUrl: model.main_url + order_item['imgsrc'],
        placeholder: (context, url) => CircularProgressIndicator.adaptive(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        width: 200,
        height: 90,
        fit: BoxFit.contain,
      ),
      Container(
      padding: EdgeInsets.only(top: 12, bottom: 13),
      child: Text('${order_item['name'].trim()}', style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      )),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        Row(children: [
          Text('Кол-во: ', style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w600,
          )),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text('${order_item['quantity']}', style: TextStyle(
              color: Colors.white,
            )),
          )
        ],),
        Row(children: [
          Text('Сумма: ', style: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w600,
          )),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              order_item['sale_price'] > 0 ? 
              ('${order_item['sale_price'] * order_item['quantity']} ₽') :
              ('${order_item['price'] * order_item['quantity']} ₽')
              , style: TextStyle(
              color: Colors.white,
            )),
          )
        ],),
      ],)
    ],)
  );
  }
  );
}