import 'package:bookhub/models/message.dart';

class Conversation{
  String userId;
  String user2Id;
  String user2imageUrl;
  String user2userName;
  String lastMsgId;
  Message lastMsg;
  Conversation({this.user2Id,this.userId,this.lastMsgId});
}
