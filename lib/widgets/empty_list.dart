// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  String label;
  EmptyList({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no_appt.png',
          scale: 1,
        ),
        Text(label, style: TextStyle(fontWeight: FontWeight.w600),)
      ],
    ));
  }
}
