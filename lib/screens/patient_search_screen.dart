import 'package:HealthHelp/api/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../helper/utils/Colors.dart';
import '../models/others.dart';
import '../widgets/resuables.dart';

class ListOfPatientScreen extends StatefulWidget {
  const ListOfPatientScreen({super.key});

  @override
  State<ListOfPatientScreen> createState() => _ListOfPatientScreenState();
}

class _ListOfPatientScreenState extends State<ListOfPatientScreen> {
  List<Medicals> list = [];

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
                StreamBuilder(
                    stream: APIs.getAllDoctors(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: SpinKitFadingCircle(
                              color: color3,
                              size: 40,
                            ),
                          );
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done:
                          break;
                        default:
                      }
                      final data = snapshot.data;
                      list =
                          data?.map((e) => Medicals.fromJson(e)).toList() ?? [];
                      print(list);
                      if (list.isNotEmpty) {
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return DoctorCard(list[index]);
                            });
                      } else {
                        return Center(
                          child: Text('No Data found.'),
                        );
                      }
                    })
              ],
            ),
          ),
        ));
  }
}
