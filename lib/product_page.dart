import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';






class ProductPageArguments  {
  Map product;
  ProductPageArguments(this.product);
}

class ProductPage extends StatefulWidget {

  const ProductPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final ProductPageArguments args = ModalRoute.of(context).settings.arguments;
    Map product = args.product;
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: MainAppBar(),
          body: ListView(children: [
                  Container(
                      padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                    child: Column(children: [
                        Container(
                        child: CachedNetworkImage(
                            imageUrl: model.main_url + product['imgsrc'],
                            placeholder: (context, url) => CircularProgressIndicator.adaptive(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            // width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text('${product['name']}', style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                          )),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            product['sale_price'] > 0 ? 
                            Column(children: [
                              Text('${product['price']} ₽',
                                style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              )),
                              Text('${product['sale_price']} ₽', style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                              )),
                            ],)
                            : 
                            Text('${product['price']} ₽', style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                              )),
                          CartButton(product['id'], 18.0),
                        ],),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                          product['description'] == 'nan'? '': '${product['description']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          )),
                        ),
                    ],)
                  ),
          ],),
        );
      }
    );
  }
}