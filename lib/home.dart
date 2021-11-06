import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List posts = [];
  //ScrollController _scrollController = ScrollController();
  int currentPosts = 10;

  final channel =
      IOWebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));
  void listenStream() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      if (decodedMessage['type'] == 'all_posts') {
        posts = decodedMessage['data']['posts'];
        print(posts);
      }
      setState(() {});
    });
  }

  void getpost() {
    channel.sink.add(
        '{"type": "get_posts","data": {"limit": "${currentPosts.toString()}"}}');
    //channel.sink.add('{"type": "get_posts","data": {"limit": "15"}}');
  }

  // void getMorePosts(){
  //   for (int i = _currentPosts; i<_currentPosts+10;i++){
  //     channel
  //   }
  // }

  @override
  initState() {
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _getMorePosts();
    //   }
    // });
    listenStream();
    getpost();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 30),
                    child: Icon(
                      Icons.settings,
                      color: Colors.grey[700],
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 160),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black)),
                    margin: EdgeInsets.only(top: 50, left: 30),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.sort),
                      color: Colors.black,
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          //borderRadius: BorderRadius(50),
                          border: Border.all(width: 2, color: Colors.black)),
                      margin: EdgeInsets.only(top: 50, left: 30),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite),
                        color: Colors.red[400],
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 550,
                width: 400,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Center(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: posts.length == 0 ? 0 : currentPosts,
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
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          posts[index]["date"],
                                          style: const TextStyle(fontSize: 12),
                                        )),
                                    Text("${posts[index]["description"]}")
                                  ],
                                )),
                                Column(
                                  children: <Widget>[
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.favorite)),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // );
  }
}
