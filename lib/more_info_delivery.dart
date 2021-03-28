import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MoreInfoDeliveryPage extends StatefulWidget {

  const MoreInfoDeliveryPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _MoreInfoDeliveryPageState createState() => _MoreInfoDeliveryPageState();
}

class _MoreInfoDeliveryPageState extends State<MoreInfoDeliveryPage> {
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
              NiceTitle('Доставка и самовывоз'),
              MoreInfoDeliveryWidget(context, model),
            ],)
          );
        }
      )
    );
  }
}

Widget MoreInfoDeliveryWidget(context, model) {
  return Container(
    margin: EdgeInsets.only(top: 15),
    alignment: Alignment.topLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      NiceTitleBold('Детали стоимости доставки', 17.0),
      Container(margin: EdgeInsets.only(top: 7),),
      Container(child: Text(
        '✓ Алупка - доставка бесплатнаяя. Минимальная сумма заказа - 850 ₽',
        style: TextStyle(
          fontSize: 15,
        ),
      )),
      Container(child: Text(
        '✓ Кореиз, Гаспра, Симеиз - 100₽. При заказе от 1200₽ доставка бесплатная.',
        style: TextStyle(
          fontSize: 15,
        ),
      )),
      Container(child: Text(
        '✓ Голубой залив, Кацивели, Понизовка, Мрия, Оползневое, Курпаты, Ореанда - 150₽. При заказе от 1500₽ доставка бесплатная.',
        style: TextStyle(
          fontSize: 15,
        ),
      )),
      Container(child: Text(
        '✓ Ливадия, Береговое, Кастрополь, Олива, Парковое - 200₽. При заказе от 2000₽ доставка бесплатная.',
        style: TextStyle(
          fontSize: 15,
        ),
      )),
      Container(child: Text(
         '✓ Ялта, Форос, Санаторное - 250₽. При заказе от 2500 доставка бесплатная.',
          style: TextStyle(
          fontSize: 15,
        ),
      )),
      Container(margin: EdgeInsets.only(top: 7),),
      NiceTitleBold('Самовывоз', 17.0),
      Container(child: Text(
        'Даем скидку 10% на заказ при самовывозе. Адрес самовывоза: ${model.delivery_byclient_address}',
        style: TextStyle(
          fontSize: 15,
        ),
      )),
      Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 9.0),
      child: ElevatedButton(
        onPressed: () {
          UrlLauncher.launch("${model.delivery_address_map}");
        },
        child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
              child: Text('Посмотреть на карте', style: TextStyle(
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