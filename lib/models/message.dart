class Message {
  late String toId;
  late String fromId;
  late String msg;
  late String read;
  late Type type;
  late String sent;

  Message(
      {required this.fromId,
      required this.msg,
      required this.read,
      required this.sent,
      required this.toId,
      required this.type});
  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }
  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'msg': msg,
      'read': read,
      'type': type.name,
      'fromId': fromId,
      'sent': sent,
    };
  }
}

enum Type { text, image }

class Notification {
  String title;
  DateTime time;
  Notification({required this.title, required this.time});
}
