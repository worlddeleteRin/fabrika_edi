import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'main.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';

class OrderCreatedPage extends StatefulWidget {

  const OrderCreatedPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _OrderCreatedPageState createState() => _OrderCreatedPageState();
}

class _OrderCreatedPageState extends State<OrderCreatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            alignment: Alignment.center,
            child: ListView(
              children: [
              Column(  
              children: [
              NiceTitle('Заказ успешно размещен!'),
              Container(margin: EdgeInsets.only(top: 15.0)),
              Text('Ваш заказ успешно размещен, в ближайшее время с вами свяжется менеджер для его подтверждения.', style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              )),
              Container(margin: EdgeInsets.only(top: 19.0)),
              Container(
                height: 37,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    model.set_currentIndex(2);
                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false );
                    return main();
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
              Container(margin: EdgeInsets.only(top: 10.0)),
              Container(
                height: 37,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    model.set_currentIndex(3);
                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false );
                    return main();
                  },
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Container(
                      child: Text('Мои заказы', style: TextStyle(
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
      )
    );
  }
}