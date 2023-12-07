// ignore_for_file: must_be_immutable

import 'package:HealthHelp/providers/DUMMY_DATA.dart';
import 'package:HealthHelp/screens/doctors_search_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/predictive_model.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/others.dart';
import '../models/user.dart';
import '../widgets/doctor_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/resuables.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
  TextEditingController _school = TextEditingController();
  TextEditingController _doctor = TextEditingController();
  bool selectedOthers = false;
  String customTest = "";
  String selectedType = 'No';
  List<Test> userAddedTests = [];
  List<String> availableTests = [];
  UserInfo? doctorInfo;
  DateTime? closestAvailableDateTime;
  @override
  void initState() {
    super.initState();
    availableTests = APIs.fetchAllTest();

    init();
  }

  bool showReg() {
    return APIs.patientBio == null ? true : false;
  }

  List<Test> medTest = [];
  List<Test> studentDefinedTest = [
    Test(title: "Blood Test"),
    Test(title: "Urine Test"),
    Test(title: "Genotype and Blood Group"),
    Test(title: "Drug Test"),
    Test(title: "X-Rays"),
    Test(title: "Doctor's Appointment"),
  ];

  init() {
    if (!showReg()) {
      if (APIs.patientBio != null) {
        medTest = APIs.patientBio!.test!;
      } else {
        medTest = [];
      }
    }
  }

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
      body: APIs.isConnected
          ? SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: !showReg()
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                              elevation: 1,
                              color: Colors.white,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // height: Screen.deviceSize(context).width * .4,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircularPercentIndicator(
                                          radius: 70.0,
                                          curve: Curves.linear,
                                          animation: true,
                                          animationDuration: 1200,
                                          lineWidth: 15.0,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          percent:
                                              APIs.patientBio!.status == null
                                                  ? 0.01
                                                  : APIs.patientBio!.status!,
                                          center: new Text(
                                            "${APIs.patientBio!.status == null ? 0.01 * 100 : APIs.patientBio!.status! * 100}%",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                          backgroundColor: color7,
                                          progressColor: color3,
                                        ),
                                        !(APIs.patientBio!.status == null ||
                                                APIs.patientBio!.status! < 1)
                                            ? Center(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                    Chip(
                                                        backgroundColor:
                                                            color15,
                                                        label: const Text(
                                                          ' Completed',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              ' View Report',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Icon(Icons
                                                                  .cloud_download_outlined),
                                                            ),
                                                          ]),
                                                    )
                                                  ]))
                                            : Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Chip(
                                                        backgroundColor: color1,
                                                        label: Text(
                                                          'Overall: Pending',
                                                          style: TextStyle(
                                                              color: color3,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    SizedBox(
                                                        child: Text(
                                                            "Appointment:\n${DateUtil.formatDateTime(
                                                              APIs.patientBio!
                                                                  .screeningDate,
                                                            )}",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))
                                                  ],
                                                ),
                                              )
                                      ]))),
                          const SizedBox(height: 20),
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
                        ],
                      )
                    : Form(
                        key: _keyForm,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Are you currently enrolled in an institution?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () => _showUsertTypes(),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _usertType,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintStyle: TextStyle(
                                          color: color8, fontSize: 12),
                                      counterStyle: const TextStyle(
                                          height: double.minPositive),
                                      labelStyle: TextStyle(
                                          color: color8,
                                          fontFamily: 'Raleway-SemiBold',
                                          fontSize: 15.0),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      disabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.all(10),
                                      prefixIcon: const Icon(Icons.person),
                                      suffixIcon: const Icon(
                                          Icons.keyboard_arrow_down_outlined)),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${selectedType == 'Yes' ? "Select Institution" : "Select Your Doctor"}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (selectedType == 'Yes') {
                                      final selectedInstitution =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ListOfInstitutionScreen(),
                                        ),
                                      );

                                      if (selectedInstitution != null) {
                                        List<Medicals> existingMedical =
                                            await APIs.getMedicalRecords("",
                                                    true, selectedInstitution)
                                                .first;
                                        print("existingMedical.length");
                                        print(existingMedical.length);
                                        MedicalScheduler scheduler =
                                            MedicalScheduler(
                                                existingMedicals:
                                                    existingMedical);

                                        closestAvailableDateTime = scheduler
                                            .getClosestAvailableBookingDateTime();

                                        _school.text = selectedInstitution;
                                        setState(() {});
                                      }
                                    } else {
                                      doctorInfo = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ListOfDoctorsScreen(
                                              type: NavigatorType.toBioData),
                                        ),
                                      );

                                      if (doctorInfo != null) {
                                        _doctor.text = doctorInfo!.name;
                                        List<Medicals> existingMedical =
                                            await APIs.getMedicalRecords(
                                                    doctorInfo!.id, false, null)
                                                .first;
                                        print(doctorInfo!.id);
                                        MedicalScheduler scheduler =
                                            MedicalScheduler(
                                                existingMedicals:
                                                    existingMedical);

                                        closestAvailableDateTime = scheduler
                                            .getClosestAvailableBookingDateTime();
                                        print(
                                            "Next Screening is :${closestAvailableDateTime}");
                                        setState(() {});
                                      }
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: selectedType == 'Yes'
                                          ? _school
                                          : _doctor,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          hintStyle: TextStyle(
                                              color: color8, fontSize: 12),
                                          counterStyle: const TextStyle(
                                              height: double.minPositive),
                                          labelStyle: TextStyle(
                                              color: color8,
                                              fontFamily: 'Raleway-SemiBold',
                                              fontSize: 15.0),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          disabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10.0))),
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          prefixIcon: const Icon(
                                            Icons.person,
                                          ),
                                          suffixIcon: const Icon(
                                              Icons.keyboard_arrow_down_outlined)),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            selectedType == '') {
                                          return "value can't be empty";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Select your screening tests',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
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
                                hint: const SizedBox(
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
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ))));
                                }).toList(),
                                value: selectedTest,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTest = value!;
                                    if (selectedTest != "Others" &&
                                        selectedTest!.isNotEmpty) {
                                      var demoTest = Test(
                                          isDone: false, title: selectedTest!);
                                      userAddedTests.add(demoTest);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text('Test Title',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      const SizedBox(
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
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          disabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                          errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          contentPadding: const EdgeInsets.only(
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            String finalTest = customTest;
                                            if (finalTest.isNotEmpty) {
                                              var demoTest = Test(
                                                  isDone: false,
                                                  title: selectedTest!);
                                              setState(() {
                                                userAddedTests.add(demoTest);
                                              });
                                            }
                                            customTest = "";
                                            selectedOthers = false;
                                          },
                                          child: const Chip(
                                            label: Text('Add',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
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
                                : const SizedBox.shrink(),
                            const SizedBox(
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
                                      title: Text(test.title),
                                      trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              final removedTest = userAddedTests
                                                  .removeAt(index);
                                              if (availableTests
                                                  .contains(removedTest)) {
                                                availableTests
                                                    .remove(removedTest);
                                                availableTests
                                                    .add(removedTest.title);
                                              }
                                            });
                                          },
                                          icon: Icon(CupertinoIcons.delete,
                                              color: color12)),
                                    ),
                                  );
                                }),

                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: SizedBox(
                                    height: 50.0,
                                    width: Screen.deviceSize(context).width,
                                    child: TextButton(
                                      onPressed: userAddedTests.isEmpty
                                          ? null
                                          : () {
                                              submitData();
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
                      ),
              ),
            )
          : ErrorScreen(label: "An Error Occured"),
    );
  }

  void _showUsertTypes() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: const Text('Yes'),
                      onTap: () {
                          medTest.clear();
                          medTest.addAll(studentDefinedTest);
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
                      title: const Text('No'),
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
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    "${test!.docName ?? ""}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          collapsed: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${test.date == null ? "No fill" : DateUtil.formatRelativeTime(test.date!)}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${test.comment == null ? "No fill" : test.comment}",
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
                                "${test.date == null ? "No fill" : DateUtil.formatRelativeTime(test.date!)}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "${test.comment == null ? "No fill" : test.comment}",
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

  final _keyForm = GlobalKey<FormState>();
  void submitData() async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    if (userAddedTests.isEmpty) {
      Dialogs.showSnackbar(context, 'You need to select your tests');
      return;
    }
    _keyForm.currentState!.save();
    Dialogs.showProgressBar(context);
    try {
      final data = Medicals(
          docName: selectedType == "Yes" ? null : doctorInfo!.name,
          docId: selectedType == "Yes" ? null : doctorInfo!.id,
          school: selectedType == "Yes" ? _school.text : null,
          screeningDate: closestAvailableDateTime!,
          patientId: APIs.userInfo.id,
          patientName: APIs.userInfo.name,
          test: userAddedTests);
      await APIs.bioDataApplication(data);
      Navigator.pop(context);
      Dialogs.showSnackbar(context, "Application Sent Successfully");
      Navigator.pop(context);
    } catch (error) {
      Navigator.pop(context);
      Dialogs.showSnackbar(context, error.toString());
    }
  }
}
