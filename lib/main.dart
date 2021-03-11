import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_donor/model/app_state_model.dart';
import 'package:flutter_donor/profile.dart';
import 'package:flutter_donor/sms_confirm_page.dart';
import 'package:flutter_donor/stock.dart';
import 'package:flutter_donor/user_orders.dart';


import 'package:scoped_model/scoped_model.dart';
// my imports here
import 'categories.dart';
import 'login_page.dart';
import 'model/app_state_model.dart';
import 'more_info.dart';
import 'product_page.dart';
import 'stock_page.dart';
import 'profile_main_page.dart';
import 'register_page.dart';


class Destination {
  Destination(this.index, this.initial_route, this.title, this.icon, this.color);
  final int index;
  final Widget initial_route;
  final String title;
  final IconData icon;
  final MaterialColor color;
}

  List<Destination> allDestinations = <Destination>[
  Destination(0, ProfilePage(), 'Профиль', Icons.account_circle, Colors.grey),
  Destination(1, StocksPage(), 'Акции', Icons.star, Colors.cyan),
  Destination(2, CategoriesList(), 'Меню', Icons.local_dining_rounded, Colors.orange),
  Destination(3, UserOrdersPage(), 'Заказы', Icons.shopping_bag, Colors.blue),
  Destination(4, InfoPage(), 'Еще', Icons.menu, Colors.blue),
];


class ViewNavigatorObserver extends NavigatorObserver {
  ViewNavigatorObserver(this.onNavigation);

  final VoidCallback onNavigation;

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
}

class DestinationView extends StatefulWidget {
  const DestinationView({ Key key, this.destination, this.onNavigation }) : super(key: key);

  final Destination destination;
  final VoidCallback onNavigation;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: <NavigatorObserver>[
        ViewNavigatorObserver(widget.onNavigation),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return widget.destination.initial_route;
              case '/category': 
                return CategoryPage();
              case '/product': 
                return ProductPage();
              case '/stock': 
                return StockPage();
              case '/login_page':
                return LoginPage();
              case '/register':
                return RegisterPage();
              case '/sms_confirm_page':
                return SmsConfirmPage();
              case '/profile':
                return ProfilePage();
            }
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final AppStateModel model;
  const HomePage({Key key, @required this.model}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(model);
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  
  final AppStateModel model;
  _HomePageState(this.model);

  List<Key> _destinationKeys;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _destinationKeys = List<Key>.generate(allDestinations.length, (int index) => GlobalKey()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppStateModel>(
      model: model,
    child: NotificationListener<ScrollNotification>(
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: allDestinations.map((Destination destination) {
              final Widget view = KeyedSubtree(
                  key: _destinationKeys[destination.index],
                  child: DestinationView(
                    destination: destination,
                    onNavigation: () {
                    },
                  ),
                );
              if (destination.index == _currentIndex) {
                return view;
              } else {
                return Offstage(child: view);
              }
            }).toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: true,
              unselectedFontSize: 13,
              selectedFontSize: 13,
              selectedItemColor: Colors.deepOrange[400],
              unselectedItemColor: Colors.white,
              currentIndex: _currentIndex,
              backgroundColor: Colors.grey[800],
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: allDestinations.map((Destination destination) {
                return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  backgroundColor: Colors.grey[800],
                  label: '${destination.title}',
                );
              }).toList(),
            ),
      ),
    ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(
    model: AppStateModel(),
  )));
}


Widget TestWidget() {
  return Center(
    child: Text('any page'),
  );
}










