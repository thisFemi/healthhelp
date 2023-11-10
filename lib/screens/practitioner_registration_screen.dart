// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'dart:io';
import 'package:path/path.dart'as path;

import 'package:HealthHelp/models/user.dart' as user;
import 'package:HealthHelp/screens/institution_search_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/others.dart'as others;
import '../widgets/resuables.dart';

class PractitionerRegistrationScreen extends StatefulWidget {
  user.UserInfo userInfo;
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
  TextEditingController _usertType = TextEditingController();
  TextEditingController _school = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  String selectedType = 'No';
  File? pickedfile;
  String? selectedPeriod;
  String? filePath  ;
  String? fileName  ;
  DateTime? selectedDate;
  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      File selectedFile = File(file.path!);

      setState(() {
        pickedfile = selectedFile;
         fileName = path.basename(selectedFile.path);
      });

      debugPrint(selectedFile.path);
    } else {
      // User canceled the picker
    }
  }

  others.FileType checkType(File file) {
    final fileExtension = file.path
        .split('.')
        .last;
    if (fileExtension == 'jpg' ||
        fileExtension == 'jpeg' ||
        fileExtension == 'png'||
        fileExtension == 'gif'

    ) {
      return others.FileType.img;
    } else

    {
      return others.FileType.pdf;
    }
  }
  void addCertificate() {
    FocusScope.of(context).unfocus();
    if (_dateController == null || _dateController.text.isEmpty) {
      Dialogs.showSnackbar(context, 'You forgot to select certificate date');
      return;
    }
    if (pickedfile == null) {
      Dialogs.showSnackbar(
          context, 'You forgot to select the certificate file');
      return;
    }

    final newCert = others.Certificate(
        type: checkType(pickedfile!),
        date: selectedDate!,
        fileName: pickedfile!); // Use pickedfile directly

    _certificates.add(newCert);
    setState(() {
      pickedfile = null;
      selectedDate = null;
      _dateController.text = '';
    });
  }

bool showReg(){
  if(APIs.docReg==null){
    return true;
  }else if(
  APIs.docReg!.status==others.ApprovalStatus.approved||APIs.docReg!.status==others.ApprovalStatus.pending
  ){
    return false;
  }
  return true;
}
bool isApproval(){
    if(APIs.docReg!.status==others.ApprovalStatus.approved){
      return true;
    }return false;
}
  List<others.Certificate> _certificates = [];
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
          showReg()?Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 20),
            child: GestureDetector(
                onTap: () {
                  submitData();
                },
                child: Text('Submit', style:TextStyle(

                    fontWeight: FontWeight.bold))),
          ):SizedBox.shrink()
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.deviceSize(context).width * .04, vertical: 10),
          child: !showReg()? Card(child: ListTile(title: Text('Licence Verification'),
            trailing: Chip(
                backgroundColor: isApproval()?color10:color1,
                label: Text("${(isApproval()&&APIs.userInfo.doctorContactInfo!.isVerified)?"Approved":"Pending "}",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:color3 ),)),

          ),): Form(
            key: _keyForm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(

          controller:_nameController,
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
                  controller:_homeController,
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
                    contentPadding:EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "address can't be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                const Text(
                  'Do you work in a University Hospital?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showUsertTypes(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _usertType,


                      decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.grey[200],
                          hintStyle:
                          TextStyle(color: color8, fontSize: 12),
                         // hintText: "select answer",
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
                        final selectedInstitution = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListOfInstitutionScreen(),
                          ),
                        );

                        if (selectedInstitution != null) {

                          _school.text = selectedInstitution;
                          setState(() {});
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _school,

                          decoration: InputDecoration(

                              filled: true,
                              fillColor: Colors.grey[200],
                              hintStyle: TextStyle(
                                  color: color8, fontSize: 12),
                              //hintText: "select answer",
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
                              return 'you need to select an institution';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                )
                    :
Column(crossAxisAlignment: CrossAxisAlignment.start,
children: [
  SizedBox(height: 10,),
  Text(
    'Current Workplace and  Address ',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  SizedBox(height: 10),   TextFormField(
 controller:_officeController,
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
      contentPadding: EdgeInsets.only(
          top: 20, left: 10, right: 10, bottom: 20),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "address can't be empty";
      }
      return null;
    },
  ),
],
),



                SizedBox(height: 10),
                Text(
                  'Upload certificate ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                    height: Screen.deviceSize(context).height * .2,
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
                            '${pickedfile == null ? 'Drag file here to upload' : fileName}',
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
                        selectedDate = result[0];
                        _dateController.text =
                            DateUtil.getNormalDate(selectedDate!);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(

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
                          suffixIcon: Icon(CupertinoIcons.calendar)),
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
                  child: GestureDetector(
                    onTap: () => addCertificate(),
                    child: Chip(
                      label: Text('Add',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
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
                    _certificates.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _certificates.clear();
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
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    itemCount: _certificates.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final cert = _certificates[index];
                      return Card(
                        color: Colors.white,
                        elevation: .5,
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            child: Image.asset(
                                'assets/images/${cert.type == others.FileType.img ? 'img' : "pdf"}_logo.png'),
                          ),

                          title: Text(path.basename(cert.fileName.path)),
                          subtitle: Text(DateUtil.getNormalDate(
                              _certificates[index].date)),
                          trailing: IconButton(
                              onPressed: () {
                                _certificates.remove(_certificates[index]);
                                setState(() {});
                              },
                              icon:
                                  Icon(CupertinoIcons.delete, color: color12)),
                        ),
                      );
                    })
              ],
            ),
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
                  'Select Answer',
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
                      _usertType.text=selectedType;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      selectedType = 'No';
                      _usertType.text=selectedType;
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
void submitData()async{
    if(!_keyForm.currentState!.validate()){
      return;
  }if(_certificates.isEmpty){
  Dialogs.showSnackbar(context, 'You need to upload your certificates');
  return;}
    _keyForm.currentState!.save();
    Dialogs.showProgressBar(context);
    try{
final data=others.DocReg(name: _nameController.text,
    homeAddress: _homeController.text,
status: others.ApprovalStatus.pending,
    isUniStaff: selectedType=="Yes"?true:false,
    officeAddress:selectedType=="Yes"?null:_officeController.text ,
    schoolName: selectedType=="Yes"?_school.text:null,
    certificates: _certificates);
await APIs.docApplication(data);
Navigator.pop(context);
Navigator.pop(context);
    }catch(error){
      Navigator.pop(context);
      Dialogs.showSnackbar(context, error.toString());
    }
}
}
