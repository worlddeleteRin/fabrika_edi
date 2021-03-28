import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class InfoPage extends StatefulWidget {

  const InfoPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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
              NiceTitle('Полезная информация'),
              MoreInfoTiles(context, model),
            ],)
          );
        }
      )
    );
  }
}

Widget MoreInfoTiles(context, model) {
  return Container(
  margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
  child: Column(children: [
      GestureDetector(onTap: () {
        Navigator.pushNamed(context, '/more_info_delivery');
      },child: NiceLinkItem(context, Icons.local_shipping, 'Доставка и самовывоз'),),
      GestureDetector(onTap: () {
        Navigator.pushNamed(context, '/more_info_payment');
      },child: NiceLinkItem(context, Icons.payment, 'Способы оплаты'),),
      GestureDetector(onTap: () {
        Navigator.pushNamed(context, '/more_info_bonus');
      },child: NiceLinkItem(context, Icons.star_rate, 'Бонусная система'),),
      GestureDetector(onTap: () {
        UrlLauncher.launch("tel://${model.delivery_phone}");
        // Navigator.pushNamed(context, '/user_orders');
      },child: NiceLinkItem(context, Icons.phone, 'Связаться с нами'),),
    ],)
    ,);
}