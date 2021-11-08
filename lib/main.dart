import 'package:flutter/material.dart';
import 'allposts/home.dart';
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
    super.initState();
  }

  void submitData() {
    setState(() {
      final String enteredID = idController.text;
      if (enteredID.isNotEmpty) {
        channel.sink.add('{"type": "sign_in","data":{"name": "$enteredID"}}');
        _isOff = false;
      } else {
        _isOff = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 100.0),
            child: const Text('Username'),
          ),
          Container(
            padding: const EdgeInsets.all(50),
            child: TextField(
              controller: idController,
              onSubmitted: (_) => submitData,
            ),
          ),
          Container(
            alignment: AlignmentDirectional.bottomCenter,
            child: ElevatedButton(
              child: const Text('Enter!'),
              onPressed: !_isOff
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => home()),
                      );
                    }
                  : null,
            ),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    idController.dispose();
    channel.sink.close();
    super.dispose();
  }
}
