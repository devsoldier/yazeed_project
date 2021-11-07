import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:yazeed_project/allposts/home.dart';
import 'package:yazeed_project/allposts/response.dart';
import './home.dart';

class postdetails extends StatefulWidget {
  dynamic data;

  postdetails({this.data});

  @override
  State<postdetails> createState() => _postdetailsState();
}

class _postdetailsState extends State<postdetails> {
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
          Center(
            child: Container(
              width: 350,
              height: 350,
              margin: EdgeInsets.only(top: 5),
              child: Image.network('${widget.data["image"]}'),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '${widget.data["author"]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Container(
            child: Text('${widget.data["description"]}'),
          ),
        ],
      ),
    );
  }
}
