import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../screens/Auth/login.dart';
import '../screens/dashboard.dart';

class ErrorScreen extends StatelessWidget{
  String label;
  ErrorScreen({required this.label});
  @override
  Widget build(BuildContext context){
    return Container(
      color: color7,
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/not_connected.png',
          scale: 1,
        ),
        SizedBox(height: 2,),
        Text(label, style:TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold)),

        SizedBox(height: 5,),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(
                height: 50.0,
                width: Screen.deviceSize(context).width*.8,
                child: TextButton(
                  onPressed:
                       ()async {
                    Dialogs.showProgressBar(context);
                   await APIs.hasNetwork();
   if(APIs.isConnected){
  if(APIs.auth.currentUser != null){
      await APIs.getSelfInfo();

      await APIs.fetchApplication();


      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Dashboard()),
      (Route<dynamic> route) => false,
      );
      } else {
      final checker = await APIs.localDataExist();
      if (checker) {
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Dashboard()),
      (Route<dynamic> route) => false,
      );
      } else {
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (Route<dynamic> route) => false,
      );
      }
      }



}else{
       Navigator.pop(context);
       Dialogs.showSnackbar(context, "No Internet Connection");
   }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                         color3,
                  ),
                  child: Text('Try again',
                      style: TextStyle(
                          color: color5,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                )))
      ],
      ),),
    );
  }
}