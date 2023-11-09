import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  const ToDoCard({
    required this.progress,
    required this.onTap, required this.title});

  final Function onTap;
  final String title;
  final  double progress;


  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap,
        child: Card(
elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
           ,
           LinearProgressIndicator(borderRadius:BorderRadius.circular(5) ,
             backgroundColor:Colors.grey[200],
             valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
           //  value: progress,
           )
            ],
            ),
          ),
        ));
  }
}