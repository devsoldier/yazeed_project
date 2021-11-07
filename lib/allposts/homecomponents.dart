import 'package:flutter/material.dart';

class homecomponents extends StatefulWidget {
  const homecomponents({Key? key}) : super(key: key);

  @override
  _homecomponentsState createState() => _homecomponentsState();
}

class _homecomponentsState extends State<homecomponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50, left: 30),
            child: IconButton(
              iconSize: 30,
              onPressed: () {},
              icon: Icon(Icons.settings),
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 160),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black)),
            margin: EdgeInsets.only(top: 50, left: 30),
            child: IconButton(
              iconSize: 30,
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
                iconSize: 30,
                onPressed: () {},
                icon: Icon(Icons.favorite),
                color: Colors.red[400],
              )),
        ],
      ),
    );
  }
}
