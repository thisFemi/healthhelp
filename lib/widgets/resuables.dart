import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reausables {
  static arrowBackIcon(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pop(context), child: Icon(CupertinoIcons.back));
  }
}
