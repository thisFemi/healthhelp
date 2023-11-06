import 'package:HealthHelp/screens/doctors_search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:HealthHelp/api/apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:HealthHelp/screens/notification_screen.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../providers/DUMMY_DATA.dart';
import '../widgets/appointment_banner_card.dart';
import '../widgets/notification_icon.dart';
import '../widgets/service_card.dart';

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
  Widget build(BuildContext context) {
    bool isDoctor =
        APIs.userInfo.userType.toLowerCase() == 'doctor' ? true : false;
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
                  Text(
                    'Welcome back,',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    APIs.userInfo.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => NotificationScreen()));
                },
                child: NotificationIcon(
                  iconData: Icons.notifications_none_rounded,
                  showDot: true,
                ),
              )
            ],
          ),
          SingleChildScrollView(
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
                          color: Colors.grey[
                              200], // Customize the fill color as needed
                        ),
                        child: TextFormField(
                          // controller: _name,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                              'Medical Tests',
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
                              () {},
                              () {
                                print('hi');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ListOfDoctorsScreen()));
                              },
                              () {},
                              () {}
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
                              () {},
                              () {
                                print('hi');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ListOfDoctorsScreen()));
                              },
                              () {},
                              () {}
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
                      Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do',
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
        ],
      ),
    );
  }
}
