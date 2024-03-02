import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final _firestore = FirebaseFirestore.instance;
late var loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextC = TextEditingController();

  var textMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessage() async {
    var messages = await _firestore.collection('messages').get();
    for (var m in messages.docs) {
      print(m['text']);
    }
  }

  void mStream() async {
    print("~############");
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagingStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextC,
                      onChanged: (value) {
                        //Do something with the user input.
                        textMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () {
                        //Implement send functionality.
                        // text + email
                        _firestore.collection('messages').add({
                          'text': textMessage,
                          'sender': loggedInUser.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        messageTextC.clear();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagingStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            );
          }
          final messages = snapshot.data?.docs.reversed;
          List<MessageBubble> mWidgets = [];
          for (var message in messages!) {
            final mText = message.get('text');
            final mSender = message.get('sender');

            final cUser = loggedInUser.email;

            final mWidget = MessageBubble(
              mText: mText,
              mSender: mSender,
              isMe: cUser == mSender,
            );
            mWidgets.add(mWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: mWidgets,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String mText;
  final String mSender;
  final bool isMe;
  MessageBubble(
      {required this.mText, required this.mSender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            mSender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$mText',
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
