import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:HealthHelp/helper/utils/date_util.dart';

import 'package:HealthHelp/models/user.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/utils/Colors.dart';
import '../helper/utils/contants.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final UserInfo user;
  ChatScreen({required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              backgroundColor: color7,
              elevation: 1,
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return SizedBox();

                          case ConnectionState.active:
                          case ConnectionState.done:
                            break;
                          default:
                        }

                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10),
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                              });
                        } else {
                          return Center(
                            child: Text('No Messages yet,'),
                          );
                        }
                      }),
                ),
                if (_isUploading)
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: SizedBox(
                            height: Screen.deviceSize(context).height * .02,
                            width: Screen.deviceSize(context).height * .02,
                            child: CircularProgressIndicator(
                              backgroundColor: color3,
                              strokeWidth: 1,
                              color: color7,
                            ),
                          ))),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: Screen.deviceSize(context).height * .35,
                    child: EmojiPicker(
                      textEditingController: textController,
                      config: Config(
                        bgColor: Colors.white,
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {},
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => UserInfo.fromJson(e.data())).toList() ?? [];
              print("lenght${list.length}");
              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(CupertinoIcons.back, color: Colors.black54)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Screen.deviceSize(context).height * .03),
                    child: CachedNetworkImage(
                      height: Screen.deviceSize(context).height * .05,
                      width: Screen.deviceSize(context).height * .05,
                      fit: BoxFit.cover,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(
                      //   color: color3,
                      // ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.isNotEmpty ? list[0].name : widget.user.name,
                        style: TextStyle(
                            fontSize: 16,
                            color: color3,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'online'
                                : DateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : DateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                        style: TextStyle(
                          fontSize: 13,
                          color: color3,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        //  Navigator.pop(context);
                      },
                      icon: Icon(CupertinoIcons.phone, color: Colors.black54)),
                ],
              );
            }));
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Screen.deviceSize(context).height * 0.01,
          horizontal: Screen.deviceSize(context).width * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: Icon(
                        CupertinoIcons.smiley,
                        color: color3,
                        size: 26,
                      )),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: textController,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) {
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      }
                    },
                    decoration: InputDecoration(border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images) {
                          log('Image Path :${i.path}');
                          setState(() {
                            _isUploading = true;
                          });
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: color3,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path :${image.path}');
                          setState(() {
                            _isUploading = true;
                          });
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.camera,
                        color: color3,
                        size: 26,
                      )),
                ],
              ),
            ),
          ),
          textController.text.isNotEmpty
              ? MaterialButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      if (_list.isEmpty) {
                        APIs.sendFirstMessage(
                            widget.user, textController.text, Type.text);
                      } else {
                        APIs.sendMessage(
                            widget.user, textController.text, Type.text);
                        textController.text = '';
                      }
                    }
                  },
                  shape: CircleBorder(),
                  minWidth: 0,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                  color: color3,
                  child: Icon(
                    Icons.send,
                    color: color7,
                    size: 28,
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
