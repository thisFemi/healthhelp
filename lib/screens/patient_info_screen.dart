import 'package:HealthHelp/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/Common.dart';
import '../helper/utils/contants.dart';
import '../models/others.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';

class PatientInfoScreen extends StatefulWidget {
  PatientInfoScreen({required this.patient, required this.record});
  final UserInfo patient;
  Medicals record;

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final number = parsePhoneNumber(widget.patient.phoneNumber);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          'Patient Record',
          style: TextStyle(
              color: color3, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatScreen(
                                user: widget.patient,
                              )));
                },
                icon: Icon(CupertinoIcons.chat_bubble_2, color: color3)),
          )
        ],
      ),
      backgroundColor: color7,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.deviceSize(context).width * .04, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Container(
                      // height: 150,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      // height: Screen.deviceSize(context).width * .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.patient.name,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Phone Number:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                number.phoneNumber.toString(),
                                style: TextStyle(fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Address:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                ' widget.patient.doctorContactInfo.a',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Date Applied:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateTime.now().toString(),
                                style: TextStyle(fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        
                        ],
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
