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
      Container(margin: EdgeInsets.only(top: 7),),
      Text('- Накапливать бонусы можно лишь авторизованным клиентам.'),
      Text('- Бонусы зачисляются по факту завершения заказа.'),
      Text('- Бонусы не начисляются, если клиент использовал какую-либо акцию из раздела "Акции" в своем заказе'),
      Text('- Бонусами можно оплатить до 25% от стоимости заказа'),
      Text('- Бонусы являются виртуальными средствами для оплаты услуг сети "Фабрика Еды" и не выдаются в натуральном виде.'),
      Text('- Доставка еды "Фабрика Еды" оставляет за собой право в любой момент вносить изменения в данные правила.'),
      Text('- В зависимости от своего уровня, клиент будет получать различный процент кэшбека'),
      Container(margin: EdgeInsets.only(top: 7),),
      NiceTitleBold('Уровни бонусной системы', 16.0),
      Container(margin: EdgeInsets.only(top: 4),),
      Text('1 уровень - 5%'),
      Text('2 уровень - клиент сделал покупки на сумму > 5000 руб. -  7%'),
      Text('2 уровень - клиент сделал покупки на сумму > 10000 руб. -  10%'),
      Container(margin: EdgeInsets.only(bottom: 7),),
    ],),
  );
}
