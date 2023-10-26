import 'dart:async';

import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../helper/utils/Colors.dart';
import '../../helper/utils/Common.dart';
import '../../helper/utils/Images.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Auth/login.dart';
import '../dashboard.dart';

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
      //  Navigator.pushReplacement(
      //        context, MaterialPageRoute(builder: (_) => MainScreen()));
      //UserInfo? user = await SharedHelper.getUserInfo();
      if (APIs.auth.currentUser != null) {
        APIs.initUser(context);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }
}
