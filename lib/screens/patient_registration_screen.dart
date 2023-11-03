// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';

class PatientRegistrationScreen extends StatefulWidget {
  PatientRegistrationScreen(this.patient);
  UserInfo patient;

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          ' Medical Registration',
          style: TextStyle(color: color3, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //       onPressed: () {},
          //       icon: Icon(CupertinoIcons.chat_bubble_2, color: color3)),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.deviceSize(context).width * .01, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 1,
                color: Colors.white,
                child: Container(
                  height:Screen.deviceSize(context).width * .4 ,
                ),
                child:Row(children:[
                     SimpleCircularProgressBar(
                        size: 130,
                        animationDuration: 1,
                        valueNotifier: ValueNotifier(60),
                        progressStrokeWidth: 24,
                        backStrokeWidth: 24,
                        mergeMode: true,
                        backColor: Colors.grey.shade200,
                        // onGetText: (value) {
                        //   // return Text(
                        //   //   '${value.toInt()}',
                        //   //   style: centerTextStyle,
                        //   // );
                        // },
                        progressColors: const [Colors.green, Colors.green],
                      ),
                ])
              )
            ],
          ),
        ),
      ),
    );
  }
}
