import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_donor/user_order_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'main.dart';
class UserOrdersPage extends StatefulWidget {

  const UserOrdersPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: MainAppBar(), 
          body: WillPopScope(
          // onWillPop: () async => null,
          child: RefreshIndicator(
          color: Colors.deepOrange,
          onRefresh: () async {
            await model.get_user_orders(model.user['id']);
            setState(() {});
          },
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              if (model.user.isEmpty) {
                return UserOrdersNeedLogin();
              }
              if (model.user_orders.isEmpty) {
                return UserOrdersEmpty(context);
              } else {
              return UserOrders(context, model.user_orders);
              }
            }
          ),
          ),
          ),
        );
      }
    );
  }
}

Widget UserOrders(BuildContext context, orders) {
  List<Widget> orders_list = [];
  orders_list.add(NiceTitle('Мои заказы'));
  for (Map order in orders) {
    orders_list.add(UserOrder(context, order));
  }

  return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
      child: Container(
        child: ListView(
          children: orders_list,
        )
      )
    );  
}


Widget UserOrder(BuildContext context, order) {
  return GestureDetector(
  onTap: () {
    Navigator.pushNamed(context, '/user_order', arguments: UserOrderPageArguments(order));
  },
  child: Container(
    height: 90,
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 9.0, // soften the shadow                
          spreadRadius: -4.0, //extend the shadow
          offset: Offset(
            0, // Move to right 10  horizontally
            0, // Move to bottom 10 Vertically
          ),
        )
      ]
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Заказ #${order['id']}', style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        )),
        Text('${order['order_cost']} ₽', style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ))
      ],),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: order['status'] == 'in_progress' ? Colors.blue : Colors.green,
          ),
          child: Text('${order['status_display'].toUpperCase()}', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          )),
        ),
        Row(children: [
        Text('Подробнее', style: TextStyle(
          color: Colors.deepOrange,
        )),
        Icon(Icons.chevron_right, color: Colors.deepOrange)
        ],)
      ],),
    ],)
  ),
  );
}

Widget UserOrdersEmpty(context) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
  return Container(
    padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
    child: Column(
    children: [
      Container(
      padding: EdgeInsets.only(left: 10, bottom: 100),
      alignment: Alignment.topLeft,
      child: NiceTitle('Мои заказы'),
      ),
      Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: AutoSizeText('На данный момент у вас нет заказов', 
        maxLines: 4,
        textAlign: TextAlign.center,
        style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700
      )),
      ),
      Container(
        padding: EdgeInsets.only(top: 15,),
        child: GestureDetector(
          onTap: () {
            // return Navigator.pushNamed(context, '/main_page');
          },
          child: ElevatedButton(
                      onPressed: () async {
                        model.set_currentIndex(2);
                        // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false );
                        AppBuilder.of(context).rebuild();
                        // return main_app();
                      },
                      child: Stack(
                        children: [
                        Container(
                          child: Text('В каталог', style: TextStyle(
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
      ),
  ],));
  }
  );
}

Widget UserOrdersNeedLogin() {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
      child: Column(children: [
        Container(
        alignment: Alignment.centerLeft,
        child: NiceTitle('Мои заказы'),
        ),
        Container(
        padding: EdgeInsets.only(left: 0, top: 25, bottom: 15),
        child: Center(
          child: Text('Войдите в аккаунт, чтобы видеть свои заказы', style: TextStyle(
            fontSize: 17,
          )),
        ),
        ),
        ElevatedButton(
          onPressed: () async {
            model.set_currentIndex(0);
            AppBuilder.of(context).rebuild();
            // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false );
            // return main_app();
          },
          child: Stack(
            children: [
            Container(
              child: Text('Войти в аккаунт', style: TextStyle(
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
      ],)
    );
  }
  );
}