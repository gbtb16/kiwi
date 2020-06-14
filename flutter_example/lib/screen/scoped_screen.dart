import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ScopedScreen extends StatefulWidget {
  @override
  _ScopedScreenState createState() => _ScopedScreenState();
}

class _ScopedScreenState extends State<ScopedScreen> {
  final container1 = KiwiContainer.scoped();
  final container2 = KiwiContainer.scoped();

  @override
  void initState() {
    super.initState();
    container1.registerInstance('TEST CONTAINER 1');
    container2.registerInstance('TEST CONTAINER 2');
    container2.registerInstance('TEST CONTAINER 2 NAMED', name: 'named');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Screen'),
      ),
      body: ListView(
        children: [
          Container(height: 16),
          Text(container1.resolve<String>()),
          Container(height: 16),
          Text(container2.resolve<String>()),
          Container(height: 16),
          Text(container2.resolve<String>('named')),
          Container(height: 16),
        ],
      ),
    );
  }
}
