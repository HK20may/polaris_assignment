import 'package:flutter/material.dart';

class ValidationErrorWidget extends StatelessWidget {
  final String errorMsg;
  const ValidationErrorWidget(
      {super.key, this.errorMsg = "**This Field can't be empty**"});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMsg,
      style: const TextStyle(
          color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
    );
  }
}
