import 'package:flutter/material.dart';
import 'package:flutter_kiwi/di/test01.dart';
import 'package:flutter_kiwi/widgets/error_widget.dart';
import 'package:kiwi/kiwi.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  void initState() {
    super.initState();
    Di.setup();
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
          Container(
            height: 600,
            child: ErrorContainer(
              error: () => KiwiContainer().resolve<String>(),
            ),
          ),
          Container(height: 16),
          Container(
            height: 600,
            child: ErrorContainer(
              error: () => KiwiContainer().resolve<String>('named'),
            ),
          ),
        ],
      ),
    );
  }
}
