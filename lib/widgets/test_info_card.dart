import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/Colors.dart';
import '../models/others.dart';

class MedTestCard extends StatefulWidget {
  MedTestCard({required this.test, required this.onSubmit});
  Test test;
  final Function(Test) onSubmit;

  @override
  State<MedTestCard> createState() => _MedTestCardState();
}

class _MedTestCardState extends State<MedTestCard> {
  TextEditingController _report = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.test.comment);
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
                        child: Text(widget.test.title,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    collapsed: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: []),
                    expanded: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key:  _keyForm,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Test Report",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextFormField(
                               controller: _report,
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
                                    return "comment can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    submit();
                                  },
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
                    ),
                  ))
            ])));
  }

  final _keyForm = GlobalKey<FormState>();

  Future<void> submit()async{

      if(!_keyForm.currentState!.validate()){
        return;
      }
      _keyForm.currentState!.save();
setState(() {
  widget.test.comment=_report.text;
  widget.test.date=DateTime.now();
  widget.test.docName=APIs.userInfo.name;
  widget.test.isDone = true;
  print(widget.test.comment);
  widget.onSubmit(widget.test);
});



  }
}
