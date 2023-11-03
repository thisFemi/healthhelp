// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'dart:io';
import 'dart:ui';

import 'package:HealthHelp/models/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _homeController = TextEditingController();
  TextEditingController _officeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  PlatformFile? pickedfile;
  String? selectedPeriod;
  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = (result.files.first);
      setState(() {
        pickedfile = file;
      });
      debugPrint(file.path);
    } else {
      // User canceled the picker
    }
  }

  void addCertificate() {
    if
  }
  List<Certificate> _certificates = [];
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
                maxLines: 1,
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
                maxLines: 1,
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
                'Upload certificate ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                  height: Screen.deviceSize(context).height * .17,
                  decoration: DottedDecoration(
                    dash: [10, 15],
                    borderRadius: BorderRadius.circular(10),
                    strokeWidth: 2,
                    shape: Shape.box,
                  ),
                  //             DottedBorder(
                  //  borderType: BorderType.RRect,
                  //  radius: Radius.circular(20),
                  //  dashPattern: [10, 10],
                  //  color: Colors.black,
                  //  strokeWidth: 2,
                  child: Card(
                    color: color9,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.square_arrow_up,
                          color: color8,
                          size: 40,
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${pickedfile == null ? 'Drag file here to upload' : pickedfile!.name}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Alternatively, you can select file by',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: color8),
                        ),
                        SizedBox(height: 3),
                        GestureDetector(
                          onTap: () async {
                            selectFile();
                          },
                          child: Text(
                            'Clicking here',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    )),
                  )),
              SizedBox(height: 15),
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
                        lastDate: DateTime.now(),
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text('Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Certificates',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  Chip(
                    backgroundColor: color12,
                    label: Text('Clear All',
                        style: TextStyle(
                          color: color7,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
