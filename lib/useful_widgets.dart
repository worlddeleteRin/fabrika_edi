
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget CartButton(product_id, font_size) {
  return Container(
          alignment: Alignment.centerRight,
          // padding: EdgeInsets.only(top: 10, bottom: 10),
          child: TextButton(
            onPressed: () {
              // add cart functionality here
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


Widget MainAppBar() {
    // final leading;
    // MainAppBar({this.leading});
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      title: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
             return Container(
                alignment: Alignment.topLeft,
                child: CachedNetworkImage(
                  imageUrl: model.main_url + 'static/images/logo2.png',
                  placeholder: (context, url) => CircularProgressIndicator.adaptive(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 100,
                  height: 110,
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
              });
          }
        ),
        ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
         return Badge(
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 500),
            animationType: BadgeAnimationType.scale,
            badgeColor: Colors.green,
            badgeContent: Text('3',
            style: TextStyle(
              color: Colors.white,
            ),
            ),
            child: IconButton(
              color: Colors.deepOrange,
              icon: Icon(Icons.shopping_cart), 
              onPressed: () {
                // navigate to cart
              }),
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


Widget NiceLinkItem(BuildContext context, IconData icon, String title, String link) {
  return GestureDetector(
  onTap: () {
    Navigator.pushNamed(context, link);
  },
  child: Container(
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
  ),
  );
}