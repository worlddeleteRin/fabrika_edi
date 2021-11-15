
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'main.dart';
import 'categories.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

Widget CartButton(product_id, parent, font_size) {
  return ScopedModelDescendant<AppStateModel>(
    builder: (context, child, model) {

      return Container(
              alignment: Alignment.centerRight,
              // padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextButton(
                onPressed: () {
                  // add cart functionality here
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  model.add_cart_item(product_id);
                  parent.setState(() {});
                  final snackBar = new SnackBar(
                  content: new Text('Товар добавлен в корзину'),                                                         
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1));    
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar
                  );  
                },
                child: Text('В корзину', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: font_size,
                )),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15)),
                ),
              ),
          );
      }
  );
}


Widget MainAppBar() {
    // final leading;
    // MainAppBar({this.leading});
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.deepOrange,
      ),
      title: 
       ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return Container(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: model.main_url + 'static/images/slogan5.png',
              placeholder: (context, url) => CircularProgressIndicator.adaptive(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 300,
              height: 100,
              fit: BoxFit.contain,
            ),
            );
          }
        ),
      actions: [
        ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return IconButton(
              color: Colors.deepOrange,
              icon: Icon(Icons.phone), 
              onPressed: () {
                // make call request
                UrlLauncher.launch("tel://${model.delivery_phone}");
              });
          }
        ),
        ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
         return Container(
           margin: EdgeInsets.only(right: 7),
          child: Badge(
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 500),
            animationType: BadgeAnimationType.scale,
            badgeColor: Colors.green,
            badgeContent: Text('${model.get_cart_items_length()}',
            style: TextStyle(
              color: Colors.white,
            ),
            ),
            child: IconButton(
              color: Colors.deepOrange,
              icon: Icon(Icons.shopping_cart), 
              onPressed: () {
                Navigator.pushNamed(context, '/cart_page');
              }),
          ),
          );
          }
        ),

      ],
    );
}

Widget LoadingWidget(title) {
  return Center(
    child: Text('$title'),
  );
}

Widget NiceTitle(title) {
  return Text('$title', style: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ));
}
Widget NiceTitle2(title) {
  return Text('$title', style: TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.w500,
    fontSize: 15,
  ));
}

NiceButton2(title) {
  return Container(
          alignment: Alignment.centerRight,
          // padding: EdgeInsets.only(top: 10, bottom: 10),
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
              onPressed: () {
                // add cart functionality here
              },
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  child: Text('$title', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  )),
                  alignment: Alignment.center,
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_forward_ios_outlined, size: 16.0),
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
      );
}


Widget NiceLinkItem(BuildContext context, IconData icon, String title) {
  // return GestureDetector(
  // onTap: () {
  //   Navigator.pushNamed(context, link);
  // },
  return Container(
    padding: EdgeInsets.only(top: 11, bottom: 11),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black12,
        ),
      ),
    ),
  child: Stack(
    alignment: Alignment.center,
    children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Container(
        child: Icon(icon,
        color: Colors.deepOrange,)
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        child: AutoSizeText('$title', style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
        )),
      ),
    ],),
    Container(
      alignment: Alignment.centerRight,
      child: Icon(Icons.arrow_forward_ios,
      size: 12.0,
      color: Colors.black38,
      ),
    )
  ],),
  );
  // );
}

Widget DefaultAlert(context, title, description) {
  return AlertDialog(
        title: Text('$title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '$description',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Продолжить', style: TextStyle(
              color: Colors.deepOrange,
            )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}

Widget AccountLogoutAlert(context, parent, model, title, description) {
  return AlertDialog(
        title: Text('$title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '$description',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Да', style: TextStyle(
              color: Colors.red,
            )),
            onPressed: () async {
              await model.clean_user_info();
              // Navigator.pushNamed(context, '/login_page');\
              parent.setState((){});
              // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false );
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Нет', style: TextStyle(
              color: Colors.black87,
            )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}

Widget NiceTitleGrey(title) {
  return Container(
  child: Text('$title', style: TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  )),
  );
}

Widget NiceTitleBold(title, font_size) {
  return Container(
  child: Text('$title', style: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontSize: font_size,
  )),
  );
}


showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
