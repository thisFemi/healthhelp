// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../helper/utils/Colors.dart';
// import '../models/appointment.dart';

// // ignore: must_be_immutable
// class AppointmentCard extends StatelessWidget {
//   UserAppointment appointment;
//   AppointmentCard(this.appointment);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1,
//       child: Container(
//         width: MediaQuery.of(context).size.width * .65,
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//             color: appointment.status.toLowerCase() == 'completed'
//                 ? color3
//                 : color15,
//             borderRadius: BorderRadius.circular(10)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   child: Icon(CupertinoIcons.person),
//                 ),
//                 SizedBox(width: 5),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(' Specilization',
//                         style: TextStyle(
//                             color:
//                                 appointment.status.toLowerCase() == 'completed'
//                                     ? color6
//                                     : color3)),
//                     SizedBox(
//                       child: Text(' Hospital',
//                           style: TextStyle(
//                               color:
//                                   appointment.status.toLowerCase() == 'completed'
//                                       ? color6
//                                       : color3)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('01 June 2023',
//                         style: TextStyle(
//                           fontSize: 10,
//                             color:
//                                 appointment.status.toLowerCase() == 'completed'
//                                     ? color6
//                                     : color3)),
//                     Row(
//                       children: [
//                         Icon(
//                           CupertinoIcons.time,
//                           color: appointment.status.toLowerCase() == 'completed'
//                               ? color6
//                               : color3,
//                           size: 14,
//                         ),
//                         Text('11:00 AM- 12:00PM',
//                             style: TextStyle(
//                                fontSize: 10,
//                                 color: appointment.status.toLowerCase() ==
//                                         'completed'
//                                     ? color6
//                                     : color3))
//                       ],
//                     )
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Icon(
//                       appointment.status.toLowerCase() == 'completed'
//                           ? CupertinoIcons.checkmark_circle_fill
//                           : Icons.circle,
//                       color: appointment.status.toLowerCase() == 'completed'
//                           ? color13
//                           : color1,
//                       size: 16,
//                     ),
//                     SizedBox(
//                       width: 2,
//                     ),
//                     Text(appointment.status,
//                         style: TextStyle(
//                            fontSize: 12,
//                             color:
//                                 appointment.status.toLowerCase() == 'completed'
//                                     ? color6
//                                     : color3))
//                   ],
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
