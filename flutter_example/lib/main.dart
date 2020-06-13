import 'package:flutter/material.dart';
import 'package:flutter_example/di/test01.dart';
import 'package:flutter_example/widget/resolve_by_name_error_widget.dart';
import 'package:flutter_example/widget/resolve_error_widget.dart';
import 'package:kiwi/kiwi.dart';

void main() {
  setup();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(height: 16),
            Text(
              'Counter instances:',
              textAlign: TextAlign.center,
            ),
            Text(
              KiwiContainer().resolve<Counter>('display').value.toString(),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text(
              KiwiContainer().resolve<Counter>().value.toString(),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Text(
              KiwiContainer().resolve<Test>().toString(),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            Container(height: 16),
            Container(
              height: 600,
              child: ResolveError(),
            ),
            Container(height: 16),
            Container(
              height: 600,
              child: ResolveByNameError(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _incrementCounter() {
    setState(() => KiwiContainer().resolve<Counter>('display').add());
  }
}
