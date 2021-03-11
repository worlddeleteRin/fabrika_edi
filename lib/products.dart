import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_donor/stock.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'product_page.dart';
import 'useful_widgets.dart';


Widget Products(category_name, products) {
      return ListView(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10,),  
      children: [
      Container(
        child: Text('$category_name', style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        )),
      ),
      GridView.builder(
          padding: EdgeInsets.only(top: 20, bottom: 20), 
          primary: false,
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 20.0,
          mainAxisExtent: 270,
          // mainAxisSpacing: 100.0,
          ),
          itemCount: products.length,
          itemBuilder: (BuildContext context, index) {
            return ProductCard(product: products[index]);
          },
        ),
  ],);
  // List<Widget> products_widget = [];
  // for(Map product in products) {
  //   products_widget.add(ProductCard(product: product));
  // }
}


class ProductCard extends StatelessWidget {
  ProductCard({this.product});
  Map product;
  @override
  Widget build(BuildContext context) {
      return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/product', arguments: ProductPageArguments(
                  product
                ));
              },
            child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
      // padding: EdgeInsets.only(top: 20),
      child: Stack(
      children: [
        Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,  
        children: [
      CachedNetworkImage(
        imageUrl: model.main_url + product['imgsrc'],
        placeholder: (context, url) => CircularProgressIndicator.adaptive(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        width: 150,
        height: 130,
        fit: BoxFit.contain,
      ),
      Column(
        children: [
          Container(
          alignment: Alignment.centerLeft,
            child: AutoSizeText('${product['name']}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
              ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text('${product['price']}', style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          ),
        ],
      ),
        CartButton(product['id'], 14.0)
        ],),

        product['ves'] == 'nan'? Text('') : 
        Positioned(
          // top: 110,
          child: Container(
            padding: EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.black87,
            ),
            child: AutoSizeText('${product['ves']}', style: TextStyle(
              color: Colors.white,
              fontSize: 11,
          )),
          ),
        ),
    ],
    ),
            ),
    );
        }
      );
      
  }
}
