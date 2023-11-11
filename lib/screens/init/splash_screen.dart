import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/apis.dart';
import '../../helper/utils/Colors.dart';
import '../../helper/utils/Common.dart';
import '../../helper/utils/Images.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:HealthHelp/screens/init/main_screen.dart';
import 'package:HealthHelp/screens/Auth/login.dart';
import 'package:HealthHelp/screens/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  bool isTimerInitialized = false;

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    if (isTimerInitialized) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color6,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: displaySize.width * 0.5,
                  child: Image.asset(logo),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SpinKitThreeBounce(color: color3, size: 30),
            ],
          ),
          // Positioned(
          //     bottom: 0.0,
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(bottom: 5.0),
          //           child: Text(
          //             'AAUA Health-Help',
          //             style:
          //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(bottom: 30.0),
          //           child: Text(
          //             'v1.0',
          //             style: const TextStyle(fontSize: 11.0),
          //           ),
          //         )
          //       ],
          //     ))
        ],
      )),
    );
  }

  void startApp() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      isTimerInitialized = true;
      _timer.cancel();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('first_time') ?? true;
     if (await APIs.localDataExist()) {

       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (_) => Dashboard()),
       );
     await APIs.initUser();

      } else {
       if (isFirstTime) {
         // First time opening the app, navigate to onboarding screen

         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (_) => MainScreen()),
         );
         prefs.setBool('first_time', false);
       }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
    }}});
  }
}
