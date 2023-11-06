import 'package:flutter/material.dart';
import 'package:HealthHelp/helper/utils/Colors.dart';

class ServiceCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Color color;
  final Color bgColor;
  final String desc;
  final Function onTap;

  ServiceCard({
    required this.iconData,
    required this.title,
    required this.color,
    required this.bgColor,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () => onTap(),
      child: Card(
        elevation: .1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: bgColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(color: color7, shape: BoxShape.circle),
                  child: Icon(iconData, size: 20.0, color: color)),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                child: Text(
                  desc,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.0,
                      color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
