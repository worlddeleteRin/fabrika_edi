import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';






class StockPageArguments  {
  Map stock;
  StockPageArguments(this.stock);
}

class StockPage extends StatefulWidget {

  const StockPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    final StockPageArguments args = ModalRoute.of(context).settings.arguments;
    Map stock = args.stock;
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: MainAppBar(),
          body: Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10),
            child: ListView(children: [
              ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                  return Container(
                    height: 200,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                        imageUrl: model.main_url + stock['imgsrc'],
                        placeholder: (context, url) => CircularProgressIndicator.adaptive(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        // width: 350,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: AutoSizeText('${stock['name']}',
                  maxLines: 4,
                  style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                ))
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: AutoSizeText('${stock['description']}',
                  maxLines: 100,
                  style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ))
              ),
          ],),
          ),
        );
      }
    );
  }
}