// ignore_for_file: must_be_immutable

import 'package:HealthHelp/screens/chat_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/Common.dart';
import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/others.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';
import '../widgets/test_info_card.dart';

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
    print('here');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          'Patient Record',
          style: TextStyle(color: color3, fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                                '${ widget.record.school!=null?"Institution":"Doctor"}:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                ' ${ widget.record.school!=null?"${widget.record.school}":"${widget.record.docName
                                  }"}',
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
                                'Appointment Date:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),

                                Text(DateUtil.formatDateTime(widget.record.screeningDate),
                                style: TextStyle(fontWeight: FontWeight.w700),
                                )
                            ],
                          ),
                        ],
                      ))),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Text(
                  'Medical Tests',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.record.test!.length,
                  itemBuilder: (ctx, index) {
                    var test = widget.record.test![index];
                    print(
                      widget.record.test!.length,
                    );
                    return MedTestCard(test: test, onSubmit:handleTestSubmission);
                  })
            ],
          ),
        ),
      ),
    );
  }

  void handleTestSubmission(Test updatedTest) async{
    Dialogs.showProgressBar(context);
    try{

     await APIs.updateRecords(widget.record.patientId, updatedTest);
     int index = widget.record.test!.indexWhere((test) => test.title == updatedTest.title);
     if (index != -1) {
       setState(() {
         widget.record.test![index] = updatedTest;
       });

     }
     Navigator.pop(context);
    }catch(e){
      Navigator.pop(context);
      Dialogs.showSnackbar(context, e.toString());
    }


  }
}
