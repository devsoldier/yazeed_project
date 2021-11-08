import 'package:flutter/material.dart';

class favorite extends StatefulWidget {
  dynamic favoritePost;
  dynamic onUnfavourite;

  favorite({this.favoritePost, this.onUnfavourite});
  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(widget.favoritePost['description']));
  }
}
