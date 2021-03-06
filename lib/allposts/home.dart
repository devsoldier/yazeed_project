import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:yazeed_project/allposts/postdetail.dart';
import 'dart:convert';
import './homecomponents.dart';
import '../userpost.dart';
import './favorite.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // bool _isFavorite = true;
  // List<bool> likedList = [];
  List posts = [];
  List favPost = [];
  List alluser = [];
  int currentPosts = 15;
  final _scrollController = ScrollController();

  final channel =
      IOWebSocketChannel.connect(Uri.parse('ws://besquare-demo.herokuapp.com'));

  void getpost() {
    channel.sink.add(
        '{"type": "get_posts","data": {"limit": "${currentPosts.toString()}"}}');
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = alluser;
    } else {
      results = alluser
          .where((user) => user['author']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      alluser = results;
    });
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

  void onUnfavourite(id) {
    setState(() {
      favPost = favPost.where((i) => i != id).toList();
    });
  }

  void onFavorite(id) {
    setState(() {
      favPost.add(id);
    });
  }

  // void FavoritePage() {
  //   ;
  // }

  @override
  initState() {
    alluser = posts;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        currentPosts = currentPosts + 10;
        // } else if (_scrollController.position.pixels ==
        //     _scrollController.position.minScrollExtent) {
        //   channel.sink.add(
        //       '{"type": "get_posts","data": {"limit": "${currentPosts.toString()}"}}');
        // }
        setState(() {});
      }
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
        backgroundColor: Colors.deepPurpleAccent[100],
        appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent[700],
            title: Text('DollarStore Insta')),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: TextField(
                        onChanged: (value) => _runFilter(value),
                        decoration: InputDecoration(hintText: 'Search'),
                      ),
                    ),
                    Container(
                        child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => favorite(
                              favoritePost: favPost,
                              onUnfavourite: onUnfavourite,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.favorite),
                      color: Colors.red[400],
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 525,
                  width: 400,
                  child: Center(
                    child: posts.isNotEmpty
                        ? ListView.builder(
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: posts.length == 0 ? 0 : currentPosts,
                            itemBuilder: (context, index) {
                              bool isFavorited = favPost.contains(posts[index]);
                              return AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => postdetails(
                                              data: posts[index],
                                            ),
                                          ));
                                    },
                                    highlightColor: Colors.yellow,
                                    splashColor: Colors.red,
                                    child: Card(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 300,
                                            height: 300,
                                            child: Center(
                                              child: Image.network(
                                                "${posts[index]["image"]}",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 35),
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (isFavorited) {
                                                        favPost.remove(
                                                            posts[index]);
                                                      } else {
                                                        favPost
                                                            .add(posts[index]);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                      isFavorited
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: isFavorited
                                                          ? Colors.pink
                                                          : null),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      posts[index]["author"],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        "${posts[index]["description"]}"),
                                                    Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            0, 5, 0, 5),
                                                        child: Text(
                                                          posts[index]["date"],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        )),
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Text('deez nuts'),
                  ),
                ),
              ),
            ],
          ),
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
