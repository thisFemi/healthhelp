import 'package:HealthHelp/models/others.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/user.dart';

class PatientCard extends StatelessWidget {
  PatientCard({required this.userInfo, required this.medical});
  final UserInfo userInfo;
  Medicals medical;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: Screen.deviceSize(context).width * .04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: .5,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => DoctorInfoScreen(
          //               doctor: doctor,
          //             )));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius:
                BorderRadius.circular(Screen.deviceSize(context).height * .03),
            child: CachedNetworkImage(
              height: Screen.deviceSize(context).height * .055,
              width: Screen.deviceSize(context).height * .055,
              fit: BoxFit.cover,
              imageUrl: userInfo.image,
              // placeholder: (context, url) => CircularProgressIndicator(
              //   color: color3,
              // ),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          title: Text(userInfo.name),
          subtitle: Text('DateUtil.getBookingDate(medica'),
        ),
      ),
    );
  }
}
