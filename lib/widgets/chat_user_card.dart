import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HealthHelp/screens/chat_screen.dart';

import '../api/apis.dart';
import '../helper/utils/contants.dart';
import '../helper/utils/date_util.dart';
import '../models/message.dart';
import '../models/user.dart';

class ChatUserCard extends StatefulWidget {
  final UserInfo user;
  ChatUserCard(this.user);
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final _list = data
                        ?.map((e) =>
                            Message.fromJson(e.data() as Map<String, dynamic>))
                        .toList() ??
                    [];
                if (_list.isNotEmpty) {
                  _message = _list[0];
                }

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Screen.deviceSize(context).height * .03),
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

                  // CircleAvatar(
                  //   child: Icon(CupertinoIcons.person),
                  // ),
                  title: Text(widget.user.name),
                  subtitle: _message != null && _message!.type == Type.image
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.camera_fill,
                                size: 14,
                              ),
                              SizedBox(width: 3,),
                              Text(
                                'photo',
                              )
                            ],
                          ))
                      : Text(
                          _message != null ? _message!.msg : widget.user.email,
                          maxLines: 1,
                        ),
                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.userId
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green.shade400,
                              ),
                            )
                          : Text(
                              DateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: TextStyle(color: Colors.black54),
                            ),
                );
              })),
    );
  }
}
