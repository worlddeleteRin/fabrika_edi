import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'main.dart';
import 'products.dart';
import 'useful_widgets.dart';
// my imports goes here

class CategoriesList extends StatefulWidget {

  const CategoriesList({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override 
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: MainAppBar(),
        body: ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        if (model.categories.isEmpty) {
        return Center(
        child: FutureBuilder(
          future: model.load_start_info(),
          builder: (context, products) {
            if (products.hasError){
              return Text('Возникла ошибка во время загрузки.');
            }
            if (!products.hasData) {
              return Text('Загрузка категорий...');
            } 
            else {
              return Categories(products.data);
            }
          }
        ),
        );
        } else {
            return Center(
              child: Categories(model.categories),
          );
        }
      }
    ),
    );
  }
}

Widget Categories(categories) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.99,
    ),
    // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent (
    //   maxCrossAxisExtent: 10,
    //   crossAxisSpacing: 20,
    //   mainAxisSpacing: 20,
    // ),
    itemCount: categories.length,
    itemBuilder: (BuildContext context, index) {
      return CategoryCard(category: categories[index]);
    },
  );
}


class CategoryCard extends StatelessWidget {
  CategoryCard ({this.category});
  Map category;
  // String img_url = 'http://127.0.0.1:8000/';
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        // print(model.main_url + category['imgsrc']);
        return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/category",
          arguments: CategoryArguments(
            category['id'], 
            category['name'],
          ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
        border: Border.all(
          width: 0.6,
          color: Colors.grey[200],
        )
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
          CachedNetworkImage(
            imageUrl: model.main_url + category['imgsrc'],
            placeholder: (context, url) => CircularProgressIndicator.adaptive(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 130,
            height: 130,
            fit: BoxFit.contain,
          ),
          Container(
          // decoration: BoxDecoration(
          // border: Border.all(color: Colors.red),
          // ),
          padding: EdgeInsets.all(8.0),
            child: FittedBox(
            fit: BoxFit.fitWidth,
              child: NiceTitle(category['name'])
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




class CategoryArguments {
  final int id;
  final String name;

  CategoryArguments(this.id, this.name);
}

class CategoryPage extends StatefulWidget {

  // CategoryPage({Key key, this.category}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
      final CategoryArguments args = ModalRoute.of(context).settings.arguments;
      print(args.id);
      print(args.name);
      return Scaffold(
        appBar: MainAppBar(),
        body: ScopedModelDescendant<AppStateModel>( 
          builder: (context, child, model) { 
          if (model.products.isEmpty) {
            return FutureBuilder(
              future: model.getProducts(),
              // future: model.getProducts(),
              builder: (context, products) {
                if (!products.hasData) {
                  return Center(
                  child: Text('Загрузка товаров...'),
                  );
                } else if (products.hasData) {
                  List products = model.get_products_by_category(model.products, args.id);
                  return Products(args.name, products);
                }
              }
            );
          } else {
              List products = model.get_products_by_category(model.products, args.id);
              return Products(args.name, products);
          }
        }
        ),
      );
  }
}

