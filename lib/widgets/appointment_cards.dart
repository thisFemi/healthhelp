// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:HealthHelp/api/apis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/appointment.dart';
import '../models/user.dart';
import '../screens/chat_screen.dart';

class AppointmentUpcomingCard extends StatelessWidget {
  AppointmentUpcomingCard({required this.appointment, required this.userInfo});
  UserAppointment appointment;
  UserInfo userInfo;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: .5,
      color: color3,
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
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
        title: Text(
          userInfo.name,
          style: TextStyle(color: color6, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 3,
            ),
            userInfo.userType == 'patient'
                ? Text(
                    'Surgeon',
                    style: TextStyle(
                      color: color6,
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(  

              height: 3,
            ),
            Row(
              children: [
                Icon(
                  Icons.alarm,
                  color: color6,
                  size: 16,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  '${appointment.time} ${DateUtil.getBookingDate(appointment.date)}',
                  style: TextStyle(color: color6, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 3,
            ),
          ],
        ),
        trailing: Icon(
          Icons.more_vert_rounded,
          color: color6,
        ),
      ),
    );
  }
}

class AppointmentCompletedCard extends StatelessWidget {
  AppointmentCompletedCard({required this.appointment, required this.userInfo});
  UserAppointment appointment;
  UserInfo userInfo;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      color: color6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(5),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                  Screen.deviceSize(context).height * .03),
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
            title: Text(
              userInfo.name,
              style: TextStyle(color: color3, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Text(
                      userInfo.doctorContactInfo!.specilizations[0].title,
                      style: TextStyle(
                        color: color3,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: color10)),
                      child: Center(
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color10,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      color: color3,
                      size: 16,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${appointment.time} ${DateUtil.getBookingDate(appointment.date)}',
                      style:
                          TextStyle(color: color3, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.black26.withOpacity(.1),
                    shape: BoxShape.circle),
                child: Icon(
                  CupertinoIcons.chat_bubble_2,
                  color: color3,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 10.0, right: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: color3)),
                    child: Center(
                      child: Text(
                        'Leave a review',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: color3),
                      color: color3,
                    ),
                    child: Center(
                      child: Text(
                        'Book Again',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: color6),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AppointmentRequestCard extends StatefulWidget {
  AppointmentRequestCard({
    required this.appointment,
    required this.userInfo,
    required this.removeFromRequestList,
  });
  UserAppointment appointment;
  UserInfo userInfo;
  final Function(UserAppointment) removeFromRequestList;

  @override
  State<AppointmentRequestCard> createState() => _AppointmentRequestCardState();
}

class _AppointmentRequestCardState extends State<AppointmentRequestCard> {
  bool isAcceptBtnClicked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      color: color6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(5),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                  Screen.deviceSize(context).height * .03),
              child: CachedNetworkImage(
                height: Screen.deviceSize(context).height * .055,
                width: Screen.deviceSize(context).height * .055,
                fit: BoxFit.cover,
                imageUrl: widget.userInfo.image,
                // placeholder: (context, url) => CircularProgressIndicator(
                //   color: color3,
                // ),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            title: Text(
              widget.userInfo.name,
              style: TextStyle(color: color3, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3,
                ),
                GestureDetector(
                  onTap: () => showAppointmentDetails(
                      context, widget.appointment.details),
                  child: Text(
                    'See details',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.timer_sharp,
                      color: color3,
                      size: 16,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${widget.appointment.time} ${DateUtil.getBookingDate(widget.appointment.date)}',
                      style:
                          TextStyle(color: color3, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatScreen(
                              user: widget.userInfo,
                            )));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.black26.withOpacity(.1),
                    shape: BoxShape.circle),
                child: Icon(
                  CupertinoIcons.chat_bubble_2,
                  color: color3,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 10.0, right: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      APIs.updateAppointment(widget.userInfo,
                          widget.appointment, AppointmentStatus.rejected);
                      widget.removeFromRequestList(widget.appointment);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: color12)),
                      child: Center(
                        child: Text(
                          'Reject',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: color12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: isAcceptBtnClicked
                        ? null
                        : () {
                            setState(() {
                              isAcceptBtnClicked = true;
                            });
                            APIs.updateAppointment(widget.userInfo,
                                widget.appointment, AppointmentStatus.approved);

                            setState(() {
                              isAcceptBtnClicked = false;
                            });
                            widget.removeFromRequestList(widget.appointment);
                          },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: isAcceptBtnClicked ? color8 : color3),
                        color: isAcceptBtnClicked ? color8 : color3,
                      ),
                      child: Center(
                        child: isAcceptBtnClicked
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                              )
                            : Text(
                                'Accept',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: color6),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showAppointmentDetails(BuildContext context, String text) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: Screen.deviceSize(context).height * 0.03,
                bottom: Screen.deviceSize(context).height * 0.05),
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ScrollOnExpand(
                        scrollOnExpand: true,
                        scrollOnCollapse: false,
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                widget.userInfo.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          collapsed: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' ${DateUtil.formatDateTime(widget.appointment.createdAt)}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                text,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                ' ${DateUtil.formatDateTime(widget.appointment.createdAt)}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: color8),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    text,
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.fade,
                                  )),
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              )),
            ],
          );
        });
  }
}

class AppointmentCancelledCard extends StatelessWidget {
  AppointmentCancelledCard({required this.appointment, required this.userInfo});
  UserAppointment appointment;
  UserInfo userInfo;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 1,
      color: color6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(5),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                  Screen.deviceSize(context).height * .03),
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
            title: Text(
              userInfo.name,
              style: TextStyle(color: color3, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Text(
                      'Chat',
                      style: TextStyle(
                        color: color3,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.red)),
                      child: Center(
                        child: Text(
                          'Cancelled',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      color: color3,
                      size: 16,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${appointment.time} ${DateUtil.getBookingDate(appointment.date)}',
                      style:
                          TextStyle(color: color3, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
            // trailing: Container(
            //   padding: EdgeInsets.all(5),
            //   decoration: BoxDecoration(
            //       color: Colors.black26.withOpacity(.1),
            //       shape: BoxShape.circle),
            //   child: Icon(
            //     CupertinoIcons.chat_bubble_2,
            //     color: color3,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
