import 'package:flutter/material.dart';

class favorite extends StatefulWidget {
  final List? favoritePost;
  dynamic onUnfavourite;

  favorite({this.favoritePost, this.onUnfavourite});
  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  // _favoriteState(this.favoritePost, this.onUnfavourite);
  // final List favoritePost;
  dynamic onUnfavourite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: widget.favoritePost?.length,
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child:
                          Image.network(widget.favoritePost?[index]["image"]),
                    ),
                    Container(
                      child: Text('${widget.favoritePost?[index]["author"]}'),
                    ),
                    Container(
                        child: Text(
                            '${widget.favoritePost?[index]["description"]}')),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
