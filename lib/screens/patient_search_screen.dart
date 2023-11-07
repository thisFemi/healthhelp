import 'package:HealthHelp/api/apis.dart';
import 'package:HealthHelp/widgets/patient_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/others.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';

class ListOfPatientScreen extends StatefulWidget {
  const ListOfPatientScreen({super.key});

  @override
  State<ListOfPatientScreen> createState() => _ListOfPatientScreenState();
}

class _ListOfPatientScreenState extends State<ListOfPatientScreen> {
  List<Medicals> list = [
    Medicals(
        status: MedStatus.pending,
        patientId: APIs.userId,
        patientName: 'patientName',
        test: [
          Test(
              comment: 'comment',
              date: DateTime.now(),
              docName: 'docName',
              title: 'title')
        ])
  ];

  List<Medicals> _searchList = [];
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: color7,
          elevation: 0,
          leading: Reausables.arrowBackIcon(context),
          title: Text(
            'Medical Records',
            style: TextStyle(color: color3, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the radius as needed
                    color:
                        Colors.grey[200], // Customize the fill color as needed
                  ),
                  child: TextFormField(
                    // controller: _name,

                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(CupertinoIcons.search, color: color3),
                    ),
                    onChanged: (value) {
                      isSearching = true;
                      _searchList.clear();
                      for (var i in list) {
                        if (i.patientName
                            .toLowerCase()
                            .contains(value.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  ),
                ),
                ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return PatientCard(
                                        userInfo: APIs.userInfo,
                                        medical: list[index]);
                                  })
                // StreamBuilder<List<Medicals>>(
                //     stream: Stream.empty(),
                //     builder: (context, snapshot) {
                //       switch (snapshot.connectionState) {
                //         case ConnectionState.waiting:
                //           return SizedBox();
                //         case ConnectionState.none:
                //         case ConnectionState.active:
                //         case ConnectionState.done:
                //           break;
                //         default:
                //       }
                //       if (snapshot.hasError) {
                //         return Center(
                //           child: Text(
                //               'Error : ${snapshot.error}'), // Display an error message
                //         );
                //       }
                //       if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //         return Center(
                //           child: Text(
                //               'No patient found.'), // Display a message when there are no appointments
                //         );
                //       }
                //       final userStreams = snapshot.data!.map((appointment) {
                //         return APIs.getUserInfoById(appointment.patientId);
                //       }).toList();
                //       for (var med in snapshot.data!) {
                //         list.add(med);
                //       }
                //       final mergedUserStream = Rx.combineLatest(
                //           userStreams,
                //           (List<UserInfo> userList) =>
                //               userList.toSet().toList());

                //       return StreamBuilder(
                //           stream: mergedUserStream,
                //           builder: (context, snapshot) {
                //             switch (snapshot.connectionState) {
                //               case ConnectionState.waiting:
                //                 return SizedBox();
                //               case ConnectionState.none:
                //                 return Center(child: SizedBox());

                //               case ConnectionState.active:
                //               case ConnectionState.done:
                //                 break;
                //               default:
                //             }
                //             if (snapshot.hasError) {
                //               return Center(
                //                 child: Text(
                //                     'Error in feth: ${snapshot.error}'), // Display an error message
                //               );
                //             }
                //             if (!snapshot.hasData) {
                //               return Center(
                //                 child: Text(
                //                     'No user details found.'), // Display a message when there are no user details
                //               );
                //             }
                //             if (!snapshot.hasData) {
                //               return Center(
                //                 child: Text(
                //                     'No user details found.'), // Display a message when there are no user details
                //               );
                //             }
                //             final userInfos = snapshot.data as List<UserInfo>;
                //             if (list.isNotEmpty && userInfos.isNotEmpty) {
                //               return ListView.builder(
                //                   physics: BouncingScrollPhysics(),
                //                   shrinkWrap: true,
                //                   padding: EdgeInsets.only(top: 10),
                //                   itemCount: list.length,
                //                   itemBuilder: (context, index) {
                //                     return PatientCard(
                //                         userInfo: APIs.userInfo,
                //                         medical: list[index]);
                //                   });
                //             } else {
                //               return Center(
                //                 child: Text('No Data found.'),
                //               );
                //             }
                //           });
                //     })
              ],
            ),
          ),
        ));
  }
}
