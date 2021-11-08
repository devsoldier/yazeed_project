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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final channel =
      IOWebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));

  final idController = TextEditingController();
  bool _isOff = true;
  late AnimationController _controller;
  late Animation _animation;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    idController.addListener(submitData);
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
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
  void dispose() {
    idController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.deepPurpleAccent[700],
          body: Column(
            children: <Widget>[
              Container(
                height: 50,
                padding: EdgeInsets.only(top: 120.0, left: 125),
                child: Row(children: <Widget>[
                  Container(
                    child: Icon(Icons.account_circle,
                        size: 150, color: Colors.black38),
                  ),
                  // Container(
                  //
                  //   child: Text('Username'),
                  // ),
                ]),
              ),
              InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: _animation.value),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.topCenter,
                        child: Material(
                          elevation: 10.0,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.indigoAccent)),
                            ),
                            controller: idController,
                            onSubmitted: (_) => submitData,
                            focusNode: _focusNode,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 100,
                alignment: AlignmentDirectional.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 8.0,
                        primary: Colors.purpleAccent[100],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35))),
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
                ),
              ),
            ],
          )),
    );
  }
}
