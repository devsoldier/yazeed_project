import 'package:flutter/material.dart';
import './home.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final channel =
      IOWebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));

  final idController = TextEditingController();
  bool _isOff = true;

  @override
  void initState() {
    idController.addListener(submitData);
    Navigator.push;
    super.initState();
  }

  void submitData() {
    setState(() {
      final String enteredID = idController.text;
      channel.sink.add('{"type": "sign_in","data":{"name": "$enteredID"}}');
      if (enteredID.isEmpty) {
        _isOff = true;
      } else {
        _isOff = false;
      }
    });
  }

  @override
  void dispose() {
    idController.dispose();
    // channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 100.0),
            child: Text('Username'),
          ),
          Container(
            padding: EdgeInsets.all(50),
            child: TextField(
              controller: idController,
              onSubmitted: (_) => submitData,
            ),
          ),
          StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              }),
          Container(
            alignment: AlignmentDirectional.bottomCenter,
            child: ElevatedButton(
              child: Text('Enter!'),
              onPressed: !_isOff
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => home(channel: channel)),
                      );
                    }
                  : null,
            ),
          )
        ],
      )),
    );
  }
}
