import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Color color;
  final Color bgColor;
  final Function onTap;

  ServiceCard({
    required this.iconData,
    required this.title,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: bgColor,
      child: InkWell(
        borderRadius:  BorderRadius.circular(10.0),
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(iconData, size: 25.0, color: color),
              SizedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
