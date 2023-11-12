import 'dart:ffi';

import 'package:HealthHelp/screens/doctors_search_screen.dart';
import 'package:HealthHelp/screens/patient_registration_screen.dart';
import 'package:HealthHelp/screens/patient_search_screen.dart';
import 'package:HealthHelp/screens/practitioner_registration_screen.dart';
import 'package:HealthHelp/widgets/chat_tab_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:HealthHelp/api/apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:HealthHelp/screens/notification_screen.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/others.dart';
import '../providers/DUMMY_DATA.dart';
import '../widgets/appointment_banner_card.dart';
import '../widgets/doctor_card.dart';
import '../widgets/notification_icon.dart';
import '../widgets/service_card.dart';
import '../widgets/to_do_card.dart';
import 'chat_screen.dart';
import 'edit_profile_screen.dart';
import 'init/coming_soon_screen.dart';
import 'messages_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _sigOut() async {
    await APIs.auth.signOut();
    await GoogleSignIn().signOut();

  }
  @override
  void initState() {


    super.initState();
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   init();
      // });
  }
  void init(){
    _todo.clear();
    print('init');

    if(APIs.isConnected){
      if (APIs.userInfo.phoneNumber==""){
        print('checking phone');
        _todo.add(ToDoItem(title: 'Complete your profile', onTap: ()async{
          final profileUpdated = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    userInfo: APIs.userInfo,
                  )));
          // if (profileUpdated == true) {
          //   setState(() {});
          // }
        }, progress: .10));
      }
      if(isDoctor){
    if(APIs.docReg==null){
print('null true');
      _todo.add(ToDoItem(title: 'Start Your License Verification', onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PractitionerRegistrationScreen(
                  APIs.userInfo,
                )));
      }, progress: .05));
    }else if(
    APIs.docReg!.status==ApprovalStatus.rejected || !APIs.userInfo.doctorContactInfo!.isVerified
    ){
      _todo.add(ToDoItem(title: 'Continue Your License Verification', onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PractitionerRegistrationScreen(
                  APIs.userInfo,
                )));
      }, progress: .30));

    }

  }
    else{
      print('cheecjking med');
      if(APIs.patientBio==null){
        _todo.add(ToDoItem(title: 'Register your medical information', onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PatientRegistrationScreen(
                    APIs.userInfo,
                  )));
        }, progress: .05));
      }
      }


    }
else{
  debugPrint('not connected');
    }
    setState(() {

    });
  }
List<ToDoItem> _todo=[

];
  bool isDoctor =
  APIs.userInfo.userType.toLowerCase() == 'doctor' ? true : false;

  @override
  Widget build(BuildContext context) {
    init();
    // if(isDoctor){
    //   print('init doc');
    //   initDoc();
    //   print('todo len ${_todo.length}');
    //
    // }
    // if(APIs.do)
    // print(APIs.docReg!.name);
    return Container(
      //
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      width: Screen.deviceSize(context).width,
      color: color6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    Screen.deviceSize(context).height * .03),
                child: CachedNetworkImage(
                  height: Screen.deviceSize(context).height * .05,
                  width: Screen.deviceSize(context).height * .05,
                  fit: BoxFit.cover,
                  imageUrl: APIs.userInfo.image,
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Screen.deviceSize(context).width/2,
                    child:
                  Text(
                    'Hello ${APIs.userInfo.name} 🎉',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16 ),
                  ),),
                  SizedBox(height: 5,),
                  Text(
                    'Priotize your health',
                    style: TextStyle(
                        color: color8,
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => NotificationScreen()));
                },
                child: NotificationIcon(
                  iconData: Icons.notifications_none_rounded,
                  showDot: true,
                ),
              )
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                        padding: EdgeInsets.only(
                          top: Screen.deviceSize(context).height * .015,
                          bottom: Screen.deviceSize(context).height * .010,
                          left: 1,
                          right: 1,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                            color: Colors
                                .grey[200], // Customize the fill color as needed
                          ),
                          child: TextFormField(
                            // controller: _name,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              prefixIcon:
                                  Icon(CupertinoIcons.search, color: color3),
                            ),
                          ),
                        )),
                    Text(
                      'Top Services',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    isDoctor
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 1.0,
                              // crossAxisSpacing: 10.0,
                              childAspectRatio: 1.3,


                            ),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              final List<IconData> icons = [
                                CupertinoIcons.bandage,
                                CupertinoIcons.time,
                                CupertinoIcons.thermometer_sun,
                                CupertinoIcons.chat_bubble_2,
                              ];
                              final List<String> titles = [
                                'Medical Records',
                                'Instant Messaging',
                                'General Checkup',
                                'Instant Messaging',
                              ];
                              final List<String> descs = [
                                'Home Visit from doctor',
                                'Experience Real-time messaging',

                              ];
                              final List<Color> bGcolors = [
                                Colors.blue.shade50,
                                Colors.green.shade100,

                              ];
                              final List<Color> colors = [
                                Colors.blue,
                                Colors.green,

                              ];
                              final List<Function> functions = [
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ListOfPatientScreen()));
                                },
    () {
    Navigator.push(context,
    MaterialPageRoute(builder: (_) => MessagesScreen()));
    }
                                ,

                              ];
                              return ServiceCard(
                                  iconData: icons[index],
                                  title: titles[index],
                                  bgColor: bGcolors[index],
                                  color: colors[index],
                                  desc: descs[index],
                                  onTap: functions[index]);
                            },
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 1.0,
                              // crossAxisSpacing: 10.0,
                              childAspectRatio: 1.3,
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              final List<IconData> icons = [
                                Icons.people_rounded,
                                CupertinoIcons.time,
                                CupertinoIcons.thermometer_sun,
                                CupertinoIcons.chat_bubble_2,
                              ];
                              final List<String> titles = [
                                'Home Visit from doctor',
                                'Setup An Appointment',
                                'General Checkup',
                                'Instant Messaging',
                              ];
                              final List<String> descs = [
                                'Home Visit from doctor',
                                'Setup An Appointment',
                                'General Checkup',
                                'Instant Messaging',
                              ];
                              final List<Color> bGcolors = [
                                Colors.blue.shade50,
                                Colors.purple.shade50,
                                Colors.orange.shade100,
                                Colors.green.shade100,
                              ];
                              final List<Color> colors = [
                                Colors.blue,
                                Colors.purple,
                                Colors.orange,
                                Colors.green,
                              ];
                              final List<Function> functions = [
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ComingSoon(
                                            label: 'Home Visit',
                                          )));
                                },
                                () {
                                  print('hi');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ListOfDoctorsScreen(type:NavigatorType.toDetails)));
                                },
                                () {

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PatientRegistrationScreen(
                                            APIs.userInfo,
                                          )));
                                },
                                () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => MessagesScreen()));
                                }
                              ];
                              return ServiceCard(
                                  iconData: icons[index],
                                  title: titles[index],
                                  bgColor: bGcolors[index],
                                  color: colors[index],
                                  desc: descs[index],
                                  onTap: functions[index]);
                            },
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Appointments',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'See All',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),

                    _todo.isNotEmpty?  Text(
                            'To Do',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ):SizedBox.shrink(),




 ListView.builder(
    itemCount: _todo.length,
    shrinkWrap: true,
    itemBuilder: (context,index){
      final todo=_todo[index];
              return ToDoCard(onTap:todo.onTap ,title: todo.title, progress: todo.progress,);

}),

                    // ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     shrinkWrap: true,
                    //     itemCount: _todo.length,
                    //     itemBuilder: (context, index){
                    //       final todo=_todo[index];
                    //       return ToDoCard(onTap:todo.onTap ,title: todo.title, progress: todo.progress,);
                    // }),



                    // Container(
                    //   height: 150,
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: DUMMY_DATA.appointments.length,
                    //       itemBuilder: (context, index) {
                    //         return Padding(
                    //           padding: EdgeInsets.all(8.0),
                    //           child: AppointmentCard(
                    //               DUMMY_DATA.appointments[index]),
                    //         );
                    //       }),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
