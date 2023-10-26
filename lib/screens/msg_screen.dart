// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// import 'package:HealthHelp/widgets/call_tab_content.dart';

// import '../helper/utils/Colors.dart';
// import '../helper/utils/contants.dart';
// import '../widgets/chat_tab_content.dart';

// class MessagesScreen extends StatefulWidget {
//   const MessagesScreen({super.key});

//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   void _switchTab(int newIndex) {
//     setState(() {
//       _tabController.index = newIndex;
//     });
//   }

//   bool _isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: WillPopScope(
//         onWillPop: () {
//           if (_isSearching) {
//             setState(() {
//               _isSearching = !_isSearching;
//             });
//             return Future.value(false);
//           } else {
//             return Future.value(true);
//           }
//         },
//         child: Scaffold(
//             body: SingleChildScrollView(
//               physics: NeverScrollableScrollPhysics(),
//           child: Container(
//             height: Screen.deviceSize(context).height,
//             margin:
//                 EdgeInsets.only(top: Screen.deviceSize(context).height * .06),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   width: Screen.deviceSize(context).width * 0.8,
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey.shade200,
//                   ),
//                   child: TabBar(
//                     controller: _tabController,
//                     physics: NeverScrollableScrollPhysics(),
//                     splashBorderRadius: BorderRadius.circular(10),
//                     tabs: [
//                       Tab(
//                           child: Text(
//                         'Chats',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       )),
//                       Tab(
//                           child: Text(
//                         'Calls',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       )),
//                     ],
//                     indicator: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: color3,
//                     ),
//                     indicatorPadding: EdgeInsets.symmetric(horizontal: 1),
//                     labelColor: Colors.white,
//                     unselectedLabelColor: color3,
//                     onTap: _switchTab,
//                   ),
//                 ),
//                 Expanded(
//                     child: TabBarView(
//                         controller: _tabController,
//                         dragStartBehavior: DragStartBehavior.start,
//                         physics: NeverScrollableScrollPhysics(),
//                         children: [
//                       SingleChildScrollView(child: ChatTabContent(_isSearching)),
//                       CallTabContent()
//                     ])),
//               ],
//             ),
//           ),
//         )),
//       ),
//     );
//   }
// }
