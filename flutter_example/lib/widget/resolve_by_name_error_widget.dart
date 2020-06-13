import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class ResolveByNameError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KiwiContainer().resolve<String>('named');
    return Container();
  }
}
