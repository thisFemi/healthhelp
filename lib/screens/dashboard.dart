import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:HealthHelp/screens/appointment_screen.dart';
import 'package:HealthHelp/screens/home_screen.dart';
import 'package:HealthHelp/screens/messages_screen.dart';
import 'package:flutter/services.dart';

import '../api/apis.dart';
import '../helper/utils/Colors.dart';
import 'account_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int _currentIndex = 0;
  late final _pageController = PageController();
  @override
  void initState() {
    super.initState();
    if(APIs.isConnected){
      APIs.fetchApplication();
    }

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          allowImplicitScrolling: false,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomeScreen(),
            AppointmentScreen(),
            MessagesScreen(),
            AccountScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        selectedItemColor: color3,
        unselectedItemColor: color8,

        type: BottomNavigationBarType
            .fixed, // Use 'fixed' to allow more than 3 items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
