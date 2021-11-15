import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';
import 'stock_page.dart';

class StocksPage extends StatefulWidget {

  const StocksPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _StocksPageState createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: MainAppBar(),
          body: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
            if (model.stocks.isEmpty) {
            return FutureBuilder(
              future: model.get_stocks(),
              builder: (context, stocks) {
                if (!stocks.hasData) {
                  return LoadingWidget('Загрузка акций...');
                }
                if (stocks.hasData) {
                  return Stocks(stocks.data, context);
                }
              }
            );
            } else {
              return Stocks(model.stocks, context);
            }
          }
          ),
        );
  }
}

Widget Stocks(stocks, context) {
  List<Widget> stocks_widgets = [];
  stocks_widgets.add(NiceTitle('Акции'));
  for (Map stock in stocks) {
    stocks_widgets.add(Stock(context, stock));
  }
  Widget stock_info = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(margin: EdgeInsets.only(top: 7)),
    NiceTitleBold('*Скидки по акциям не суммируются.', 15.0),
    NiceTitleBold('*За один заказ клиент может воспользоваться только одной акцией', 15.0),
    Container(margin: EdgeInsets.only(bottom: 10)),
  ],);
  stocks_widgets.add(stock_info);
  return Container(
  padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
  child: ListView(
    children: stocks_widgets,
  ),
  );
}

Widget Stock(context2, stock) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (child, context, model) {
    return GestureDetector(
      onTap: () {
        // go to stock page
        Navigator.pushNamed(context2, '/stock', arguments: StockPageArguments(
          stock
        ));
      },
      child: Container(
        padding: EdgeInsets.only(top: 5),
        child: Card(
          child: Column(children: [
            Container(  
              height: 120,
              width: 400,        
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: CachedNetworkImage(
                    imageUrl: model.main_url + stock['imgsrc'],
                    placeholder: (context, url) => CircularProgressIndicator.adaptive(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    // width: 350,
                    fit: BoxFit.cover,
                  ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              child: AutoSizeText('${stock['name']}', style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              )),
            ),
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 10),
              child: AutoSizeText('${stock['description']}', style: TextStyle(
                color: Colors.black,
              )),
            ),
            ],)
        ),
      ),
      );
    }
  );
}

