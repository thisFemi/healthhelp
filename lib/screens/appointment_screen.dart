// ignore_for_file: prefer_const_constructors

import 'package:HealthHelp/api/apis.dart';
import 'package:HealthHelp/widgets/appointment_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';

import '../helper/utils/Colors.dart';
import '../models/appointment.dart';
import '../models/user.dart';
import '../widgets/empty_list.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  void _switchTab(int newIndex) {
    setState(() {
      _tabController.index = newIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<UserAppointment> upcomingAppointments = [];
    List<UserAppointment> requestAppointments = [];
    List<UserAppointment> completedAppointments = [];
    List<UserAppointment> cancelledAppointments = [];

    void removeFromRequestList(UserAppointment appointment) {
      setState(() {
        // requestAppointments.remove(appointment);
      });
    }

    bool isDoctor =
        APIs.userInfo.userType.toLowerCase() == 'doctor' ? true : false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Appointments',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // titleTextStyle:TextStyle(fontWeight: FontWeight.bold ,color: color3),
        centerTitle: true,
        backgroundColor: color7,
        elevation: 0,
      ),
      backgroundColor: color7,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            TabBar(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                splashFactory: NoSplash.splashFactory,
                isScrollable: false,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                splashBorderRadius: BorderRadius.zero,
                indicator: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 3, color: color3))),
                tabs: [
                  Tab(
                    child: SizedBox(
                      child: Text(
                        'Upcoming',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      child: Text(
                        'Completed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  !isDoctor
                      ? Tab(
                          child: SizedBox(
                            child: Text(
                              'Requests',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Tab(
                          child: SizedBox(
                            child: Text(
                              'Cancelled',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                ]),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<List<UserAppointment>>(
                stream: APIs.getMyAppointments(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return SizedBox();
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      break;
                    default:
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Error in aoppt: ${snapshot.error}'), // Display an error message
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                          'No appointments found.'), // Display a message when there are no appointments
                    );
                  }
                  final userStreams = snapshot.data!.map((appointment) {
                    return APIs.getUserInfoById(appointment.patientId);
                  }).toList();
                  for (var appointment in snapshot.data!) {
                    switch (appointment.status) {
                      case AppointmentStatus.pending:
                        requestAppointments.add(appointment);
                        break;
                      case AppointmentStatus.approved:
                        upcomingAppointments.add(appointment);
                        break;
                      case AppointmentStatus.rejected:
                        cancelledAppointments.add(appointment);
                        break;
                      case AppointmentStatus.completed:
                        completedAppointments.add(appointment);
                        break;
                    }
                  }
                  // Merge all user info streams into one
                  final mergedUserStream = Rx.combineLatest(userStreams,
                      (List<UserInfo> userList) => userList.toSet().toList());

                  return StreamBuilder<List<UserInfo>>(
                      stream: mergedUserStream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SizedBox();
                          case ConnectionState.none:
                            return Center(child: SizedBox());

                          case ConnectionState.active:
                          case ConnectionState.done:
                            break;
                          default:
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                'Error in feth: ${snapshot.error}'), // Display an error message
                          );
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                                'No user details found.'), // Display a message when there are no user details
                          );
                        }
                        final userInfos = snapshot.data as List<UserInfo>;
                        return Expanded(
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                              upcomingAppointments.isEmpty
                                  ? EmptyList(
                                      label: "No Upcoming Appointments",
                                    )
                                  : ListView.builder(
                                      itemCount: upcomingAppointments.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        // print('chechking ');
                                        // print(upcomingAppointments.length);
                                        var appointment =
                                            upcomingAppointments[index];
                                        var userInfo = userInfos.firstWhere(
                                            (user) =>
                                                user.id ==
                                                    appointment.patientId ||
                                                user.id ==
                                                    appointment.doctorId);
                                        return AppointmentUpcomingCard(
                                          appointment: appointment,
                                          userInfo: userInfo,
                                        );
                                      }),
                              completedAppointments.isEmpty
                                  ? EmptyList(
                                      label: "No Appointments",
                                    )
                                  : ListView.builder(
                                      itemCount: completedAppointments.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var appointment =
                                            completedAppointments[index];
                                        var userInfo = userInfos.firstWhere(
                                            (user) =>
                                                user.id ==
                                                    appointment.patientId ||
                                                user.id ==
                                                    appointment.doctorId);
                                        return AppointmentCompletedCard(
                                          appointment: appointment,
                                          userInfo: userInfo,
                                        );
                                      }),
                              isDoctor && requestAppointments.isEmpty ||
                                      !isDoctor && cancelledAppointments.isEmpty
                                  ? EmptyList(
                                      label: "No Appointments",
                                    )
                                  : ListView.builder(
                                      itemCount: isDoctor
                                          ? requestAppointments.length
                                          : cancelledAppointments.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        print('l');
                                        print(requestAppointments.length);
                                        var appointment = isDoctor
                                            ? requestAppointments[index]
                                            : cancelledAppointments[index];
                                        var userInfo = userInfos.firstWhere(
                                            (user) =>
                                                user.id ==
                                                    appointment.patientId ||
                                                user.id ==
                                                    appointment.doctorId);
                                        return isDoctor
                                            ? AppointmentRequestCard(
                                                appointment: appointment,
                                                userInfo: userInfo,
                                                removeFromRequestList:
                                                    removeFromRequestList,
                                              )
                                            : AppointmentCancelledCard(
                                                appointment: appointment,
                                                userInfo: userInfo,
                                              );
                                      }),
                            ]));
                      });
                })
          ],
        ),
      ),
    );
  }

  // Widget buildAppointmentCard(UserAppointment appointment, UserInfo userInfo) {
  //   if (upcomingAppointments.contains(appointment)) {
  //     return AppointmentUpcomingCard(
  //         appointment: appointment, userInfo: userInfo);
  //   } else if (completedAppointments.contains(appointment)) {
  //     return AppointmentCompletedCard(
  //         appointment: appointment, userInfo: userInfo);
  //   } else if (requestAppointments.contains(appointment) && !isDoctor) {
  //     return AppointmentRequestCard(
  //         appointment: appointment, userInfo: userInfo);
  //   } else if (cancelledAppointments.contains(appointment)) {
  //     return AppointmentCancelledCard(
  //         appointment: appointment, userInfo: userInfo);
  //   } else {
  //     return SizedBox(); // Handle other cases as needed
  //   }
  // }
}
