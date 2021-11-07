import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:yazeed_project/allposts/postdetail.dart';
import 'dart:convert';
import './homecomponents.dart';
import '../userpost.dart';
import './response.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List posts = [];
  final _scrollController = ScrollController();
  int currentPosts = 15;

  final channel =
      IOWebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));

  void getpost() {
    channel.sink.add(
        '{"type": "get_posts","data": {"limit": "${currentPosts.toString()}"}}');
  }

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

  @override
  initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        currentPosts = currentPosts + 10;
      } else if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        channel.sink.add(
            '{"type": "get_posts","data": {"limit": "${currentPosts.toString()}"}}');
      }
      setState(() {});
    });
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
            homecomponents(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 550,
                width: 400,
                child: Center(
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: posts.length == 0 ? 0 : currentPosts,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        postdetails(data: posts[index]),
                                  ),
                                );
                              },
                              highlightColor: Colors.yellow,
                              splashColor: Colors.red,
                              child: Card(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              style:
                                                  const TextStyle(fontSize: 12),
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
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => userpost()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
