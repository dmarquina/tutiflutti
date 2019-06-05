import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final MainModel model;

  ChatMessageListItem(this.messageSnapshot, this.animation, this.model);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: model.username == messageSnapshot.value['username']
                  ? getSentMessageLayout(context)
                  : getReceivedMessageLayout(),
            )));
  }

  List<Widget> getSentMessageLayout(BuildContext context) {
    return <Widget>[
      Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Text(messageSnapshot.value['username'],
            style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
        Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: messageSnapshot.value['imageUrl'] != null
              ? Image.network(
                  messageSnapshot.value['imageUrl'],
                  width: 250.0,
                )
              : Text(messageSnapshot.value['message']),
        ),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Text(
                    messageSnapshot.value['username'].toString().substring(0, 1).toUpperCase(),
                    style: TextStyle(color: Colors.white))))
      ])
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
                child: Text(
                    messageSnapshot.value['username'].toString().substring(0, 1).toUpperCase())))
      ]),
      Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(messageSnapshot.value['username'],
            style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
        Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: messageSnapshot.value['imageUrl'] != null
                ? Image.network(
                    messageSnapshot.value['imageUrl'],
                    width: 250.0,
                  )
                : Text(messageSnapshot.value['message']))
      ]))
    ];
  }
}
