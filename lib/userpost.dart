import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import './allposts/home.dart';

class userpost extends StatefulWidget {
  @override
  _userpostState createState() => _userpostState();
}

class _userpostState extends State<userpost> {
  final channel =
      IOWebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  bool _isOff = true;

  @override
  void initState() {
    titleController.addListener(submitData);
    descriptionController.addListener(submitData);
    imageController.addListener(submitData);
    super.initState();
  }

  void submitData() {
    setState(() {
      final String enteredtitle = titleController.text;
      final String entereddesc = descriptionController.text;
      final String enteredimage = imageController.text;

      if (enteredtitle.isNotEmpty ||
          entereddesc.isNotEmpty ||
          enteredimage.isNotEmpty) {
        channel.sink.add(
            '{ “type”: “create_post”, “data”: { “title”: "$enteredtitle", “description”: "$entereddesc", “image”: "$enteredimage" }}');
        _isOff = false;
      } else {
        _isOff = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 35),
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => home()),
                );
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50, left: 40, right: 40),
            child: TextField(
              decoration: InputDecoration(hintText: 'title'),
              controller: titleController,
              onSubmitted: (_) => submitData,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50, left: 40, right: 40),
            child: TextField(
              decoration: InputDecoration(hintText: 'description'),
              controller: descriptionController,
              onSubmitted: (_) => submitData,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50, left: 40, right: 40),
            child: TextField(
              decoration: InputDecoration(hintText: 'Url'),
              controller: imageController,
              onSubmitted: (_) => submitData,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => home()),
              );
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }
}
