import 'package:flutter/material.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';

class AddReviewScreen extends StatefulWidget {
  AddReviewScreen({required this.doctor});
  final UserInfo doctor;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          'Share Your Experience',
          style: TextStyle(color: color3, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: color7,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.deviceSize(context).width * .04, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
