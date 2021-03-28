import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MoreInfoBonusPage extends StatefulWidget {

  const MoreInfoBonusPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _MoreInfoBonusPageState createState() => _MoreInfoBonusPageState();
}

class _MoreInfoBonusPageState extends State<MoreInfoBonusPage> {
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
              NiceTitle('Бонусная система'),
              MoreInfoBonusWidget(context),
            ],)
          );
        }
      )
    );
  }
}

Widget MoreInfoBonusWidget(context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(margin: EdgeInsets.only(top: 7),),
      Text(
        'В нашей доставке каждому авторизованному клиенту автоматически открывается бонусный счет, на который вместе с каждым заказом будут начисляться бонусы.'
      ),
      Container(margin: EdgeInsets.only(top: 7),),
      NiceTitleBold('Правила бонусной системы', 16.0),
      Text('- ')
    ],),
  );
}
