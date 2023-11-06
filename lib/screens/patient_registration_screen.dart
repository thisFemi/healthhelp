// ignore_for_file: must_be_immutable

import 'package:HealthHelp/providers/DUMMY_DATA.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/others.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import 'institution_search_screen.dart';

class PatientRegistrationScreen extends StatefulWidget {
  PatientRegistrationScreen(this.patient);
  UserInfo patient;

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  String? selectedTest;
  TextEditingController _usertType = TextEditingController();
  bool selectedOthers = false;
  String customTest = "";
  String selectedType = 'No';
  List<String> userAddedTests = [];
  List<String> availableTests = [];
  @override
  void initState() {
    super.initState();
    availableTests = APIs.fetchAllTest();
  }

  List<Test> medTest = [
    Test(
        comment: '0+',
        isDone: true,
        date: DateTime.now(),
        docName: 'docName',
        title: 'blood test'),
    Test(
        comment: 'negative',
        date: DateTime.now(),
        docName: 'docName',
        title: 'urine test'),
  ];
  bool isApplied = true;
  @override
  Widget build(BuildContext context) {
    _usertType.text = selectedType;

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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      // height: Screen.deviceSize(context).width * .4,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SimpleCircularProgressBar(
                              size: 100,
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
                              progressColors: [color3, color3],
                            ),
                            Center(
                                child: !isApplied
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Chip(
                                              backgroundColor: color15,
                                              label: Text(
                                                ' Completed',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(' View Report'),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(Icons
                                                    .cloud_download_outlined),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    : Chip(
                                        backgroundColor: color15,
                                        label: Text(
                                          'Not yet Applied',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )))
                          ]))),
              !isApplied
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          SizedBox(height: 20),
                          ListView.builder(
                              itemCount: medTest.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                final test = medTest[index];
                                return Card(
                                  elevation: .5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text("${test.title}"),
                                    onTap: () {
                                      showTestDetails(context, test);
                                    },
                                    trailing: Chip(
                                        backgroundColor:
                                            test.isDone ? color13 : color1,
                                        label: Text(
                                            "${test.isDone ? "Completed" : "Pending"}",
                                            style: TextStyle(
                                                color: test.isDone
                                                    ? color7
                                                    : color3))),
                                  ),
                                );
                              })
                        ])
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Are you currently enrolled in an institution?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => _showUsertTypes(),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _usertType,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  enabled: false,
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintStyle:
                                      TextStyle(color: color8, fontSize: 12),
                                  hintText: "select answer",
                                  counterStyle:
                                      TextStyle(height: double.minPositive),
                                  labelStyle: TextStyle(
                                      color: color8,
                                      fontFamily: 'Raleway-SemiBold',
                                      fontSize: 15.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  contentPadding: EdgeInsets.all(10),
                                  prefixIcon: Icon(Icons.person),
                                  suffixIcon:
                                      Icon(Icons.keyboard_arrow_down_outlined)),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    selectedType == '') {
                                  return 'you need to select a user type';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        selectedType == 'Yes'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Select Institution',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final profileUpdated = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ListOfInstitutionScreen()));
                                      if (profileUpdated == true) {
                                        setState(() {});
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: _usertType,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            enabled: false,
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            hintStyle: TextStyle(
                                                color: color8, fontSize: 12),
                                            hintText: "select answer",
                                            counterStyle: TextStyle(
                                                height: double.minPositive),
                                            labelStyle: TextStyle(
                                                color: color8,
                                                fontFamily: 'Raleway-SemiBold',
                                                fontSize: 15.0),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            contentPadding: EdgeInsets.all(10),
                                            prefixIcon: Icon(
                                              Icons.person,
                                            ),
                                            suffixIcon: Icon(Icons
                                                .keyboard_arrow_down_outlined)),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              selectedType == '') {
                                            return 'you need to select a user type';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),

                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Select your screening tests',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          // width: Screen.deviceSize(
                          //             context)
                          //         .width *
                          //     .3,
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: SizedBox(
                              child: Text('Select your test',
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                            items: DUMMY_DATA.availableTests
                                .map<DropdownMenuItem<String>>((test) {
                              return DropdownMenuItem<String>(
                                  value: test,
                                  child: SizedBox(
                                      child: Text(test,
                                          style: TextStyle(
                                            fontSize: 11,
                                          ))));
                            }).toList(),
                            value: selectedTest,
                            onChanged: (value) {
                              setState(() {
                                selectedTest = value!;
                                if (selectedTest != "Others" &&
                                    selectedTest!.isNotEmpty) {
                                  userAddedTests.add(selectedTest!);
                                  DUMMY_DATA.availableTests
                                      .remove(selectedTest!);
                                }
                                if (selectedTest == "Others") {
                                  selectedOthers = true;
                                }
                                selectedTest = null;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                                // height: deviceSize.height * .04,
                                // padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                          ),
                        ),
                        // ListView.builder(
                        //   itemCount: 10,
                        //   itemBuilder: (cxt, index){

                        // }) SizedBox(height: 20),
                        selectedOthers
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('Test Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setState(() {
                                        customTest = value;
                                      });
                                    },
                                    // onSaved: (newValue) => APIs
                                    //     .userInfo
                                    //     .doctorContactInfo!
                                    //     .clinicAddress = newValue ?? '',
                                    // autovalidateMode:
                                    //   AutovalidateMode.onUserInteraction,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: EdgeInsets.only(
                                          top: 20,
                                          left: 10,
                                          right: 10,
                                          bottom: 20),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "value can't be empty";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        String finalTest = customTest;
                                        if (finalTest.isNotEmpty) {
                                          setState(() {
                                            userAddedTests.add(finalTest);
                                          });
                                        }
                                        customTest = "";
                                        selectedOthers = false;
                                      },
                                      child: Chip(
                                        label: Text('Add',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 20,
                        ),
                        userAddedTests.isNotEmpty
                            ? Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    userAddedTests.clear();
                                    setState(() {});
                                  },
                                  child: Chip(
                                    backgroundColor: color12,
                                    label: Text('Clear All',
                                        style: TextStyle(
                                          color: color7,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                            itemCount: userAddedTests.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final test = userAddedTests[index];
                              return Card(
                                color: Colors.white,
                                elevation: .5,
                                child: ListTile(
                                  title: Text(test),
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          final removedTest =
                                              userAddedTests.removeAt(index);
                                          if (availableTests
                                              .contains(removedTest)) {
                                            availableTests.remove(removedTest);
                                            availableTests.add(removedTest);
                                          }
                                        });
                                      },
                                      icon: Icon(CupertinoIcons.delete,
                                          color: color12)),
                                ),
                              );
                            }),

                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(
                                height: 50.0,
                                width: Screen.deviceSize(context).width,
                                child: TextButton(
                                  onPressed: userAddedTests.isEmpty
                                      ? null
                                      : () {
                                          print('object');
                                        },
                                  style: TextButton.styleFrom(
                                    backgroundColor: userAddedTests.isEmpty
                                        ? color8
                                        : color3,
                                  ),
                                  child: Text('Submit Application',
                                      style: TextStyle(
                                          color: color5,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                )))
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUsertTypes() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Select Type',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                ListView(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text('Yes'),
                      onTap: () {
                        setState(() {
                          selectedType = 'Yes';
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          selectedType = 'No';
                        });
                        Navigator.pop(context);
                      },
                      title: Text('No'),
                    )
                  ],
                )
              ],
            ));
  }

  void showTestDetails(BuildContext context, Test test) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: Screen.deviceSize(context).height * 0.03,
                bottom: Screen.deviceSize(context).height * 0.05),
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ScrollOnExpand(
                        scrollOnExpand: true,
                        scrollOnCollapse: false,
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    test.docName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          collapsed: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateUtil.formatRelativeTime(test.date),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                test.comment,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DateUtil.formatRelativeTime(test.date),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    test.comment,
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.fade,
                                  )),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              )),
            ],
          );
        });
  }
}
