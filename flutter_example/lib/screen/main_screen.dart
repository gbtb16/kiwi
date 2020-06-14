import 'package:flutter/material.dart';
import 'package:flutter_example/screen/error_screen.dart';
import 'package:flutter_example/screen/resolve_screen.dart';
import 'package:flutter_example/screen/scoped_screen.dart';
import 'package:kiwi/kiwi.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: ListView(
        children: [
          Container(height: 16),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ResolveScreen()));
              KiwiContainer().clear();
            },
            child: Text(
              'Resolve Screen',
              style: Theme.of(context).accentTextTheme.bodyText1,
            ),
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ErrorScreen()));
              KiwiContainer().clear();
            },
            child: Text(
              'Error Screen',
              style: Theme.of(context).accentTextTheme.bodyText1,
            ),
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScopedScreen()));
              KiwiContainer().clear();
            },
            child: Text(
              'Scoped Container Screen',
              style: Theme.of(context).accentTextTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
