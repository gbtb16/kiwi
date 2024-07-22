import 'package:flutter/material.dart';
import 'package:flutter_kiwi/screens/error_screen.dart';
import 'package:flutter_kiwi/screens/resolve_screen.dart';
import 'package:flutter_kiwi/screens/scoped_screen.dart';
import 'package:kiwi/kiwi.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
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
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
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
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
