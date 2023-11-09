import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import '../helper/utils/Colors.dart';
import '../models/others.dart';

class MedTestCard extends StatelessWidget {
  MedTestCard({required this.test});
  Test test;
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2.0,
            margin: EdgeInsets.only(top: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: false,
                        tapHeaderToExpand: true),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(test.title,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    collapsed: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: []),
                    expanded: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Doctor's Comment",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              // initialValue: widget.userInfo.email,
                              //  onSaved: (newValue) => APIs.userInfo.email ?? '',

                              maxLines: 3,

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
                                contentPadding: EdgeInsets.all(10),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "email can't be empty";
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Chip(
                                  label: Text('Submit',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ))
            ])));
  }
}
