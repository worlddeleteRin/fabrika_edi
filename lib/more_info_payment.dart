import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MoreInfoPaymentPage extends StatefulWidget {

  const MoreInfoPaymentPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _MoreInfoPaymentPageState createState() => _MoreInfoPaymentPageState();
}

class _MoreInfoPaymentPageState extends State<MoreInfoPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              NiceTitle('Способы оплаты'),
              MoreInfoPaymentWidget(context),
            ],)
          );
        }
      )
    );
  }
}

Widget MoreInfoPaymentWidget(context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(margin: EdgeInsets.only(top: 7),),
      NiceTitleBold('Оплата картой курьеру', 17.0),
      Container(margin: EdgeInsets.only(top: 4),),
      Container(child: Text(
        'Наш курьер приедет с терминалом и вы сможете оплатить свой заказ картой. Мы принимаем карты Visa, Mastercard, МИР.',
        style: TextStyle(
          fontSize: 15,
        ),
      )),
      Container(margin: EdgeInsets.only(top: 7),),
      NiceTitleBold('Наличыми курьеру', 17.0),
      Container(margin: EdgeInsets.only(top: 4),),
      Container(child: Text(
        'Наш курьер приедет с необходимой сдачей и примет у вас оплату наличными.',
        style: TextStyle(
          fontSize: 15,
        ),
      )),
    ],),
  );
}
