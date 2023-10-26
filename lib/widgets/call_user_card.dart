import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/utils/contants.dart';
import '../models/user.dart';

class CallUserCard extends StatefulWidget {
  final UserInfo user;
  CallUserCard(this.user);

  @override
  State<CallUserCard> createState() => _CallUserCardState();
}

class _CallUserCardState extends State<CallUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: Screen.deviceSize(context).width * .04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: .5,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => ChatScreen(
          //               user: widget.user,
          //             )));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius:
                BorderRadius.circular(Screen.deviceSize(context).height * .03),
            child: CachedNetworkImage(
              height: Screen.deviceSize(context).height * .055,
              width: Screen.deviceSize(context).height * .055,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(
              //   color: color3,
              // ),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          title: Text(widget.user.name),
          subtitle: Row(
            children: [
              Icon(Icons.phone),
              SizedBox(
                width: 3,
              ),
              Text('Missed')
            ],
          ),
        ),
      ),
    );
  }
}
