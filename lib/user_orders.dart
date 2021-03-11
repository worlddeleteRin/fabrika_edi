import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';
import 'useful_widgets.dart';

class UserOrdersPage extends StatefulWidget {

  const UserOrdersPage({ Key key}) : super(key: key);

  // final Destination destination;

  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: MainAppBar(),
          body: Center(
              child: Text('user orders is here'),
            ),
        );
      }
    );
  }
}