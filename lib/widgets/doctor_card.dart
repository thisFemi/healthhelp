import 'package:HealthHelp/screens/doctor_info_sreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/user.dart';
enum NavigatorType{
  toDetails,
  toBioData,
}
class DoctorCard extends StatelessWidget {
  DoctorCard({required this.doctor, this.navigatorType} );
  final UserInfo doctor;
  NavigatorType? navigatorType;
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
            if(navigatorType==NavigatorType.toDetails){


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DoctorInfoScreen(
                        doctor: doctor,
                        )));
          }else{
              Navigator.pop(context,doctor);
            }

            },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                  Screen.deviceSize(context).height * .03),
              child: CachedNetworkImage(
                height: Screen.deviceSize(context).height * .055,
                width: Screen.deviceSize(context).height * .055,
                fit: BoxFit.cover,
                imageUrl: doctor.image,
                // placeholder: (context, url) => CircularProgressIndicator(
                //   color: color3,
                // ),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            title: Text(
              '${doctor.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3,
                ),
                doctor.doctorContactInfo!.specilizations.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${doctor.doctorContactInfo!.specilizations[0].title}',
                            style: TextStyle(
                                color: color8,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                          //   Text(
                          //  '${doctor.doctorContactInfo!.clinicAddress}',
                          //     style: TextStyle(
                          //         color: color8,
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 12),
                          //   )
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.star_rate_rounded,
                            size: 16, color: Colors.orange.shade500),
                        Text(
                          '${doctor.doctorContactInfo!.totalRatingAvg} ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${doctor.doctorContactInfo!.reviews.length} Reviews ',
                      style: TextStyle(
                          color: color4,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    )
                  ],
                )
              ],
            ),
            trailing: Icon(
              CupertinoIcons.checkmark_seal_fill,
              size: 16,
              color: color13,
            ),
            contentPadding:
                EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
          )),
    );
  }
}
