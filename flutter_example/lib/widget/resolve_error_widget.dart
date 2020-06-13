import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ResolveError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KiwiContainer().resolve<String>();
    return Container();
  }
}
