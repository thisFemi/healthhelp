// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:HealthHelp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../widgets/resuables.dart';

class PractitionerRegistrationScreen extends StatefulWidget {
  UserInfo userInfo;
  PractitionerRegistrationScreen(this.userInfo);

  @override
  State<PractitionerRegistrationScreen> createState() =>
      _PractitionerRegistrationScreenState();
}

class _PractitionerRegistrationScreenState
    extends State<PractitionerRegistrationScreen> {
  TextEditingController _dateController = TextEditingController();
  final List<Specialization> specialization = [
    Specialization(title: 'Dentist'),
    Specialization(title: 'Surgeon'),
    Specialization(title: 'Pharmacist')
  ];

  final List<String> periods = [
    'A Month',
    'Next 3 Month',
    'Next 6 Months',
    'Always Available'
  ];
  final List<String> workHours = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3.00 PM',
    '4.00 PM',
    '5.00 PM',
  ];
  String? selectedPeriod;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
        title: Text(
          'Medical Verification',
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
              horizontal: Screen.deviceSize(context).width * .04, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                // initialValue: widget.userInfo.email,
                // onSaved: (newValue) => APIs.userInfo.email ?? '',
                // enabled: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'as it appears on documents',
                  fillColor: Colors.grey[200],
                  hintStyle: TextStyle(color: color8),
                  labelStyle: TextStyle(
                      color: color8,
                      fontFamily: 'Raleway-SemiBold',
                      fontSize: 15.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding: EdgeInsets.all(10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "name can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Home Address ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                // initialValue:
                //     widget.userInfo.patientContactInfo!.clinicAddress ?? "",
                maxLines: 2,
                // onSaved: (newValue) => APIs.userInfo.patientContactInfo!
                //     .clinicAddress = newValue ?? '',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: TextStyle(color: color8),
                  labelStyle: TextStyle(
                      color: color8,
                      fontFamily: 'Raleway-SemiBold',
                      fontSize: 15.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "address can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Current Workplace and  Address ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                // initialValue:
                //     widget.userInfo.patientContactInfo!.clinicAddress ?? "",
                maxLines: 2,
                // onSaved: (newValue) => APIs.userInfo.patientContactInfo!
                //     .clinicAddress = newValue ?? '',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: TextStyle(color: color8),
                  labelStyle: TextStyle(
                      color: color8,
                      fontFamily: 'Raleway-SemiBold',
                      fontSize: 15.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "address can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Certification Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  var result = await showCalendarDatePicker2Dialog(
                    context: context,

                    config: CalendarDatePicker2WithActionButtonsConfig(
                        calendarType: CalendarDatePicker2Type.single,
                        okButton: Text(
                          'Select',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        cancelButton: Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    dialogSize: Size(Screen.deviceSize(context).width * .9,
                        Screen.deviceSize(context).height / 2.5),
                    // value: _dates,
                    borderRadius: BorderRadius.circular(15),
                  );
                  print(result);
                  if (result != null) {
                    setState(() {
                      _dateController.text = result[0].toString();
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
            
                    decoration: InputDecoration(
                        enabled: false,
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintStyle: TextStyle(color: color8, fontSize: 12),
                        hintText: "select  certification date",
                        counterStyle: TextStyle(height: double.minPositive),
                        labelStyle: TextStyle(
                            color: color8,
                            fontFamily: 'Raleway-SemiBold',
                            fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                    validator: (value) {
                      if (value == null) {
                        return 'you need to select a date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
