import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'response.dart';
import './main.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/src/rendering/box.dart';

class home extends StatefulWidget {
  home({required this.channel, Key? key}) : super(key: key);

  WebSocketChannel channel;
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List posts = [];

  // final channel =
  //     IOWebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));
  void listenStream() {
    widget.channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      if (decodedMessage['type'] == 'all_posts') {
        posts = decodedMessage['data']['posts'];
        print(posts);
      }
    });
  }

  void getpost() {
    widget.channel.sink.add('{"type": "get_posts","data": {"limit": 10}}');
  }

  initState() {
    listenStream();
    getpost();
    Navigator.push;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:
            // Column(
            //   children: <Widget>[
            //     Row(
            //       children: <Widget>[
            //         Container(
            //           margin: EdgeInsets.only(top: 50, left: 30),
            //           child: Icon(
            //             Icons.settings,
            //             color: Colors.grey[700],
            //             size: 30,
            //           ),
            //         ),
            //         SizedBox(width: 160),
            //         Container(
            //           decoration: BoxDecoration(
            //               border: Border.all(width: 2, color: Colors.black)),
            //           margin: EdgeInsets.only(top: 50, left: 30),
            //           child: IconButton(
            //             onPressed: () {},
            //             icon: Icon(Icons.sort),
            //             color: Colors.black,
            //           ),
            //         ),
            //         Container(
            //             decoration: BoxDecoration(
            //                 //borderRadius: BorderRadius(50),
            //                 border: Border.all(width: 2, color: Colors.black)),
            //             margin: EdgeInsets.only(top: 50, left: 30),
            //             child: IconButton(
            //               onPressed: () {},
            //               icon: Icon(Icons.favorite),
            //               color: Colors.red[400],
            //             )),
            //       ],
            //     ),
            Center(
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                child: Image.network(
                                  "${posts[index]["image"]}",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  posts[index]["author"],
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Text(
                                      posts[index]["date"],
                                      style: TextStyle(fontSize: 12),
                                    )),
                                Text("${posts[index]["description"]}")
                              ],
                            )),
                            Column(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.favorite)),
                              ],
                            )
                          ],
                        ),
                      );
                    })),
        //],
      ),
    );
    // );
  }
}
