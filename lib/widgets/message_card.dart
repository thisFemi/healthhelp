import 'package:HealthHelp/helper/utils/Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HealthHelp/helper/utils/contants.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/date_util.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.userId == widget.message.fromId;
    return Builder(builder: (context) {
      return isMe ? _blueMessages(isMe) : _greyMessages(isMe);
    });
  }

  copyText(String text) async {
    await Clipboard.setData(new ClipboardData(text: text));
  }

  deleteMsg(Message msg) async {
    print('deletng');
    await APIs.deleteMessage(msg);
    // APIs.updateMessage(msg, updatedMsg);
  }

  saveImage() async {
    try {
      await GallerySaver.saveImage(widget.message.msg, albumName: 'HealthHelp')
          .then((success) {
        if (success != null) {
          Dialogs.showSnackbar(context, 'Image Successfully Saved');
        }
      });
    } catch (e) {
      rethrow;
    }
  }

// editMsg()async{
//   setState(() {
    
//   });
// }
  showPopMenu(Offset offset, bool isMe) {
    print('pop menu');
    List<PopupMenuEntry<dynamic>> textMenu = widget.message.type == Type.text
        ? isMe
            ? [
                PopupMenuItem(
                    onTap: () {
                      copyText(widget.message.msg);
                    },
                    child: Row(children: [
                      Icon(
                        Icons.content_copy_rounded,
                      ),
                      Flexible(child: Text('   ${'Copy'}'))
                    ])),
                // PopupMenuItem<int>(
                //     onTap: () {
                //       print('copy tapped');
                //       Navigator.pop(context);
                //     },
                //     child: Row(children: [
                //       Icon(
                //         Icons.edit,
                //       ),
                //       Flexible(child: Text('   ${'Edit'}'))
                //     ])),
                PopupMenuItem<int>(
                    onTap: () {
                      deleteMsg(widget.message);
                    },
                    child: Row(children: [
                      Icon(
                        CupertinoIcons.delete,
                      ),
                      Flexible(child: Text('   ${'Delete'}'))
                    ])),
                PopupMenuItem<int>(
                    onTap: () {
                      showInfoModal(widget.message.read, widget.message.sent);
                    },
                    child: Row(children: [
                      Icon(
                        Icons.info,
                      ),
                      Flexible(child: Text('   ${'Info'}'))
                    ]))
              ]
            : [
                PopupMenuItem(
                    onTap: () {
                      copyText(widget.message.msg);
                    },
                    child: Row(children: [
                      Icon(
                        Icons.content_copy_rounded,
                      ),
                      Flexible(child: Text('   ${'Copy'}'))
                    ])),
                PopupMenuItem<int>(
                    onTap: () {
                      showInfoModal(widget.message.read, widget.message.sent);
                    },
                    child: Row(children: [
                      Icon(
                        Icons.info,
                      ),
                      Flexible(child: Text('   ${'Info'}'))
                    ]))
              ]
        : [
            PopupMenuItem<int>(
                onTap: () {
                  saveImage();
                },
                child: Row(children: [
                  Icon(
                    CupertinoIcons.floppy_disk,
                  ),
                  Flexible(child: Text('   ${'Save image'}'))
                ])),
            PopupMenuItem<int>(
                onTap: () {
                  deleteMsg(widget.message);
                },
                child: Row(children: [
                  Icon(
                    CupertinoIcons.delete,
                  ),
                  Flexible(child: Text('   ${'Delete'}'))
                ])),
            PopupMenuItem<int>(
                onTap: () {
                  showInfoModal(widget.message.read, widget.message.sent);
                },
                child: Row(children: [
                  Icon(
                    Icons.info_outline_rounded,
                  ),
                  Flexible(child: Text('   ${'Info'}'))
                ]))
          ];
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy + 20,
          MediaQuery.of(context).size.width - offset.dx,
          MediaQuery.of(context).size.height - offset.dy,
        ),
        items: textMenu);

    // return PopupMenuButton<int>(itemBuilder: (ctx) {
    //   return [
    //     // _OptionItems(
    //     //     icon: Icon(Icons.content_copy_rounded), title: 'Copy', onTap: () {})
    //     PopupMenuItem<int>(
    //         onTap: () {
    //           print('delete tapped');
    //           Navigator.pop(context);
    //         },
    //         child: Row(children: [
    //           Icon(CupertinoIcons.delete),
    //           Flexible(child: Text('   ${'Delete'}'))
    //         ])),
    //     PopupMenuItem<int>(
    //         onTap: () {
    //           print('copy tapped');
    //           Navigator.pop(context);
    //         },
    //         child: Row(children: [
    //           Icon(Icons.content_copy_rounded),
    //           Flexible(child: Text('   ${'Copy'}'))
    //         ]))
    //   ];
    // });
  }

  showInfoModal(String readTime, String sentTime) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.grey.shade100,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: Screen.deviceSize(context).height * 0.01,
                  bottom: Screen.deviceSize(context).height * 0.05),
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: Screen.deviceSize(context).height * 0.005,
                  margin: EdgeInsets.symmetric(
                      horizontal: Screen.deviceSize(context).height * 0.7),
                  width: 20,
                  decoration: BoxDecoration(
                      color: color8, borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: color6, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.done_all,
                              size: 18,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Read'),
                            Spacer(),
                            Text(DateUtil.getMessageTime(
                                context: context, time: readTime))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Divider(
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.done_all,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Delivered'),
                            Spacer(),
                            Text(
                                '${widget.message.sent.isEmpty ? 'Not seen yet' : DateUtil.getMessageTime(context: context, time: sentTime)}')
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

//me message
  Widget _blueMessages(bool isMe) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.deviceSize(context).width * .04,
        vertical: Screen.deviceSize(context).height * .01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPressStart: (details) async {
              final offset = details.globalPosition;
              // onLongPress: () {
              showPopMenu(offset, isMe);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.message.type == Type.text
                      ? Text(
                          widget.message.msg,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                              // height: Screen.deviceSize(context).height * .3,
                              width: Screen.deviceSize(context).height * .3,
                              fit: BoxFit.cover,
                              imageUrl: widget.message.msg,
                              // placeholder: (context, url) => Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: CircularProgressIndicator(
                              //         color: color3,
                              //         strokeWidth: 3,
                              //       ),
                              //     ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.image, size: 70)),
                        ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateUtil.getFormattedTime(
                    context: context,
                    time: widget.message.sent,
                  ),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                if (widget.message.read.isNotEmpty)
                  Icon(
                    Icons.done_all,
                    size: 12,
                    color: Colors.blue,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //other sender
  Widget _greyMessages(bool isMe) {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print('read updated');
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.deviceSize(context).width * .04,
        vertical: Screen.deviceSize(context).height * .01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPressStart: (details) async {
              final offset = details.globalPosition;
              // onLongPress: () {
              showPopMenu(offset, isMe);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    // Adjust the bottomLeft radius
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.message.type == Type.text
                      ? Text(
                          widget.message.msg,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                              height: Screen.deviceSize(context).height * .3,
                              //    width: Screen.deviceSize(context).height * .3,
                              fit: BoxFit.cover,
                              imageUrl: widget.message.msg,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.image, size: 70)),
                        ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateUtil.getFormattedTime(
                      context: context, time: widget.message.sent),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class _OptionItems extends StatelessWidget {
//   final Icon icon;
//   final String title;
//   final VoidCallback onTap;
//   _OptionItems({required this.icon, required this.title, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuItem(
//         onTap: () => onTap(),
//         child: Row(children: [icon, Flexible(child: Text('      ${title}'))]));
//   }
// }
