import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Screens/home_screen.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class chat extends StatefulWidget {
  final String topicname;
  chat({this.topicname});
  @override
  _chatState createState() => _chatState(topicname: this.topicname);
}

class _chatState extends State<chat> {
  final String topicname;
  _chatState({this.topicname});
  final messagetextcontroler = TextEditingController();
  userData cuserdata;
  String message;
  bool k = false;
  @override
  void initState() {
    super.initState();
    getus();
  }

  getus() async {
    userData scuserdata = await authServices().Currentuser();
    print('fgh');
    setState(() {
      cuserdata = scuserdata;
    });
    k = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(topicname),
          centerTitle: true,
        ),
        body: k == true
            ? SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: chatref
                          .document(topicname)
                          .collection("messages")
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                                //       backgroundColor: Colors.lightBlue,
                                ),
                          );
                        }
                        final messages = snapshot.data.documents;
                        List<MessageBuble> messagebubles = [];
                        for (var message in messages) {
                          final messageText = message.data['text'];
                          final mesageSender = message.data['sender'];

                          String currentUseremail = cuserdata.email;
                          final messageBuble = MessageBuble(
                            sender: mesageSender,
                            text: messageText,
                            isme: currentUseremail == message.data['email'],
                            timestamp: message.data['time'],
                          );
                          messagebubles.add(messageBuble);
                        }

                        return Expanded(
                          child: ListView(
                            reverse: true,
                            children: messagebubles,
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              //color: Colors.lightBlueAccent,
                              width: 2.0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: messagetextcontroler,
                              onChanged: (value) {
                                //Do something with the user input.
                                message = value;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                hintText: 'Type your message here...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              messagetextcontroler.clear();
                              chatref
                                  .document(topicname)
                                  .collection('messages')
                                  .add({
                                'text': message,
                                'sender': cuserdata.name,
                                'email': cuserdata.email,
                                'time': timestamp,
                              });
                            },
                            child: Text(
                              'Send',
                              style: TextStyle(
                                //    color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : circularProgress());
  }
}

class MessageBuble extends StatelessWidget {
  MessageBuble({this.text, this.sender, this.isme, this.timestamp});
  final String text;
  final String sender;
  final bool isme;
  final Timestamp timestamp;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              //     color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isme ? Colors.grey[700] : Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isme ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Text(timeago.format(timestamp.toDate()))
        ],
      ),
    );
  }
}
