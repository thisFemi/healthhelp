import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:HealthHelp/helper/utils/Colors.dart';
import 'package:HealthHelp/screens/edit_profile_screen.dart';

import '../../api/apis.dart';
import '../../helper/utils/contants.dart';
import 'practitioner_registration_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    print('updated');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: Screen.deviceSize(context).height,
        color: color6,
        padding: EdgeInsets.only(top: 40, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: Screen.deviceSize(context).width,
              padding: EdgeInsets.only(bottom: 10, top: 0),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: .5, color: color8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Screen.deviceSize(context).height * .03),
                    child: CachedNetworkImage(
                      height: Screen.deviceSize(context).height * .08,
                      width: Screen.deviceSize(context).height * .08,
                      fit: BoxFit.cover,
                      imageUrl: APIs.userInfo.image,
                      // placeholder: (context, url) => CircularProgressIndicator(
                      //   color: color3,
                      // ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    APIs.userInfo.name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    APIs.userInfo.email,
                    style: TextStyle(
                        color: color8,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ),
            profileTiles(CupertinoIcons.person, 'Edit profile', () async {
              final profileUpdated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                            userInfo: APIs.userInfo,
                          )));
              if (profileUpdated == true) {
                setState(() {});
              }
            }),
            profileTiles(CupertinoIcons.bell, 'Notification', () {}),
            profileTiles(Icons.settings_outlined, 'Security', () {}),
            APIs.userInfo.userType.toLowerCase() == 'patients'
                ? profileTiles(
                    CupertinoIcons.bandage, 'Medical registration', () {})
                : ListTile(
                    minLeadingWidth: 2,
                    leading: Icon(
                      CupertinoIcons.checkmark_seal,
                      color: color3,
                    ),
                    title: Text(
                      'Medical License Verification',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      child: !APIs.userInfo.doctorContactInfo!.isVerified
                          ? Chip(
                              backgroundColor: color10,
                              padding: EdgeInsets.all(5),
                              label: Text(
                                'Verified',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ))
                          : Chip(
                              backgroundColor: color12,
                              padding: EdgeInsets.all(5),
                              label: Text(
                                'Not verified',
                                style: TextStyle(
                                    color:color7,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                    onTap: () {
                      if ((APIs.userInfo.doctorContactInfo!.isVerified)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PractitionerRegistrationScreen(
                                      APIs.userInfo,
                                    )));
                      }
                    },
                  ),
            // : profileTiles(Icons.medical_services_rounded,
            //     'Medical License Verification', () {

            //   }),
            // profileTiles(CupertinoIcons.ellipsis_circle, 'Language', () {}),
            profileTiles(CupertinoIcons.phone, 'Help center', () {}),
            // profileTiles(CupertinoIcons.person_3, 'Invite friends', () {}),
            profileTiles(CupertinoIcons.info, 'App info', () {}),

            ListTile(
              minLeadingWidth: 2,
              leading: Icon(
                Icons.logout,
                color: color12,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: color12, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                logoutDialog();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget profileTiles(
    IconData icon,
    String title,
    Function() function,
  ) {
    return ListTile(
      minLeadingWidth: 2,
      leading: Icon(
        icon,
        color: color3,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        CupertinoIcons.forward,
        color: color8,
      ),
      onTap: function,
    );
  }

  void logoutDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsPadding: EdgeInsets.only(bottom: 11, left: 10, right: 10),
          titlePadding: EdgeInsets.only(top: 20, bottom: 1),
          title: Text(
            "Logout",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to logout this accoount?.You will loose all information and can't undo this action.",
            textAlign: TextAlign.center,
            style: TextStyle(color: color8),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                      side: BorderSide(color: Colors.grey),
                    ),
                    // Customize the button's appearance
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: color8),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                SizedBox(width: 8), // Add a small space between buttons
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      backgroundColor: color12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                    ),
                    //color: Colors.green, // Customize the button's appearance
                    child: Text(
                      "Logout",
                      style: TextStyle(color: color6),
                    ),
                    onPressed: () {
                      APIs.logOut(context);
                      // Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
