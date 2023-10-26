// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:HealthHelp/screens/reviews_screen.dart';
import 'package:HealthHelp/widgets/review_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';

import '../helper/utils/date_util.dart';
import '../models/user.dart';
import '../widgets/resuables.dart';

class DoctorInfoScreen extends StatefulWidget {
  DoctorInfoScreen({required this.doctor});
  final UserInfo doctor;

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
  @override
  void initState() {
    super.initState();
    print('starting');
    print(widget.doctor.doctorContactInfo!.selectedDuration.name);
    availaleDays = DateUtil.generateAvailableDays(
        widget.doctor.doctorContactInfo!.selectedDuration);
    selectedDate = availaleDays[0];
  }

  TextEditingController noteController = TextEditingController();
  List<DateTime> availaleDays = [];
  final List<String> workHours = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3.00 PM',
    '4.00 PM',
    '5.00 PM',
  ];
  final loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  List<String> filterWorkHoursByAvailability() {
    final List<String> filteredWorkHours = [];

    for (String timeSlot in workHours) {
      if (isTimeSlotAvailable(timeSlot)) {
        filteredWorkHours.add(timeSlot);
      }
    }

    return filteredWorkHours;
  }

  bool isTimeSlotAvailable(String timeSlot) {
    final formattedDate =
        "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";

    print("Formatted Date: $formattedDate");
    print(
        "Appointments Data: ${widget.doctor.doctorContactInfo!.appointments}");

    final slotData = widget.doctor.doctorContactInfo!.appointments
        .map((availability) => availability[formattedDate])
        .firstWhere((slotData) => slotData != null, orElse: () => null);

    print("Slot Data for $formattedDate: $slotData");

    if (slotData != null) {
      for (final slot in slotData) {
        print("Checking Slot: ${slot.time}");
        if (slot.time == timeSlot && slot.isBooked) {
          return false;
        }
      }
    }

    return true;
  }

  DateTime? selectedDate;
  String? selectedHour;
  @override
  Widget build(BuildContext context) {
    final List<String> filteredWorkHours = filterWorkHoursByAvailability();
    bool showBooking = widget.doctor.doctorContactInfo!.selectedDuration !=
            AvailabilityDuration.notAvailable ||
        widget.doctor.doctorContactInfo!.isVerified;
    return GestureDetector(
      onTap: () => Focus.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color7,
          elevation: 0,
          leading: Reausables.arrowBackIcon(context),
          title: Text(
            'About Doctor',
            style: TextStyle(color: color3, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.chat_bubble_2, color: color3)),
            )
          ],
        ),
        backgroundColor: color7,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Screen.deviceSize(context).width * .04,
                vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          Screen.deviceSize(context).height * .03),
                      child: CachedNetworkImage(
                        height: Screen.deviceSize(context).height * .07,
                        width: Screen.deviceSize(context).height * .07,
                        fit: BoxFit.cover,
                        imageUrl: widget.doctor.image,
                        // placeholder: (context, url) => CircularProgressIndicator(
                        //   color: color3,
                        // ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.doctor.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              widget.doctor.doctorContactInfo!.isVerified
                                  ? CupertinoIcons.checkmark_seal_fill
                                  : Icons.pending_outlined,
                              color: widget.doctor.doctorContactInfo!.isVerified
                                  ? color13
                                  : color1,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        widget.doctor.doctorContactInfo!.specilizations
                                .isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.doctor.doctorContactInfo!.specilizations[0].title}',
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
                        //  Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         '${} ',
                        //         style: TextStyle(
                        //             color: color8,
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 12),
                        //       ),
                        //       Text(
                        //         'Hosptal Address ',
                        //         style: TextStyle(
                        //             color: color8,
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 12),
                        //       )
                        //     ],
                        //   ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(children: [
                          RatingBarIndicator(
                            rating:
                                widget.doctor.doctorContactInfo!.totalRatingAvg,
                            itemSize: 16,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.orange.shade500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            " (${widget.doctor.doctorContactInfo!.reviews.length} Reviews)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          )
                        ])
                      ],
                    )
                  ],
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
                            header: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "About Doctor",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            collapsed: Text(
                              loremIpsum,
                              softWrap: true,
                              maxLines: 2,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                            ),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      loremIpsum,
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Specializations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        // Use SizedBox to control the height
                        height: 40,
                        child: ListView.builder(
                            itemCount: widget.doctor.doctorContactInfo!
                                .specilizations.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final currentSpec = widget.doctor
                                  .doctorContactInfo!.specilizations[index];
                              return Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(right: 10, top: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        Colors.blue.shade100.withOpacity(.4)),
                                child: Text(
                                  currentSpec.title,
                                  style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ReviewListScreen(
                                            widget.doctor.doctorContactInfo!
                                                .reviews,
                                          )));
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                          // Use SizedBox to control the height
                          height: Screen.deviceSize(context).height * .13,
                          child: widget
                                  .doctor.doctorContactInfo!.reviews.isNotEmpty
                              ? ListView.builder(
                                  itemCount: widget
                                      .doctor.doctorContactInfo!.reviews.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final currentRev = widget.doctor
                                        .doctorContactInfo!.reviews[index];
                                    return ReviewCard(currentRev);
                                  })
                              : Center(
                                  child: Text(
                                    'No Reviews Yet',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ))
                    ],
                  ),
                ),
                showBooking
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        height: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Schedules',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: availaleDays.length,
                                  itemBuilder: (ctx, index) {
                                    // print(
                                    //   availaleDays.length,
                                    // );
                                    final DateTime day = availaleDays[index];
                                    final String formattedDate =
                                        '${DateUtil.getShortWeekday(day)}\n${DateUtil.getMonth(day)}\n${day.day}';
                                    final bool isSelected =
                                        selectedDate!.day == day.day;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDate = day;
                                          selectedHour = null;
                                        });
                                        print(selectedDate);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        width: 60,
                                        //    padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? color3
                                                : Colors.white,
                                            border: Border.all(
                                                color: isSelected
                                                    ? color3
                                                    : color8),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            formattedDate,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : color3,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Expanded(
                              //  height: 200,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  // Number of work hours per day
                                  // mainAxisSpacing: 2/4,
                                  childAspectRatio: 2.2,
                                ),
                                itemCount: filteredWorkHours.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String hour = filteredWorkHours[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedHour = hour;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: selectedHour == hour
                                              ? color3
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: selectedHour == hour
                                                  ? Colors.transparent
                                                  : color8)),
                                      child: Center(
                                        child: Text(
                                          hour,
                                          style: TextStyle(
                                              color: selectedHour == hour
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                showBooking
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: noteController,
                              maxLines: 7,
                              onSaved: (newValue) {},
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintStyle: TextStyle(color: color8),
                                labelStyle: TextStyle(
                                    color: color8,
                                    fontFamily: 'Raleway-SemiBold',
                                    fontSize: 15.0),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 1, color: color3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 1, color: color3),
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
                                  return "notes can't be empty";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                showBooking
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: SizedBox(
                            height: 50.0,
                            width: Screen.deviceSize(context).width,
                            child: TextButton(
                              onPressed: () {
                                bookAppointment();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: color3,
                              ),
                              child: Text('Book Appointment',
                                  style: TextStyle(
                                      color: color5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            )))
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String appMsg =
      'Your Appointment request has been sent to the doctor. You will receive a notification when its been accepted.';
  Future<void> bookAppointment() async {
    if (selectedHour == null) {
      Dialogs.showSnackbar(context, 'You need to select an appointment time');
      return;
    }
    if (noteController.text.isEmpty) {
      Dialogs.showSnackbar(
          context, 'You need to write a short note about your appointment');
      return;
    }
    Dialogs.showProgressBar(context);
    final note = noteController.text;
    try {
      await APIs.sendAppointmentRequest(
          DateTime.now(), note, widget.doctor, selectedHour!, selectedDate!);
      Navigator.pop(context);
      Dialogs.showSuccessDialog(
          context, 'Schedule Successful', appMsg, 'See Appointments', () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
      // Navigator.pop(context);
      print('booking sent');
    } catch (error) {
      Navigator.pop(context);
      Dialogs.showSnackbar(context, error.toString());
    }
  }
}
