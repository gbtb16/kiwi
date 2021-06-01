import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final VoidCallback error;

  const ErrorContainer({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    error();
    return Container();
  }
}
