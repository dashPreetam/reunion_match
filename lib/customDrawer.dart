import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Column(
        children: [
          Container(
            child: DrawerHeader(
                child: Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  child: FadeInImage.assetNetwork(
                      placeholder: 'images/robot.png', image: user.photoURL),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      user.displayName,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                )
              ],
            )),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed("/votes"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.where_to_vote),
                  SizedBox(),
                  Text("Votes", style: TextStyle(fontSize: 35)),
                  SizedBox(),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          FlatButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed("/info"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.info),
                  SizedBox(),
                  Text("Info", style: TextStyle(fontSize: 35)),
                  SizedBox(),
                ],
              )),
          /*SizedBox(
            height: 20,
          ),
          FlatButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed("/teams"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.people),
                  SizedBox(),
                  Text("Teams", style: TextStyle(fontSize: 35)),
                  SizedBox(),
                ],
              )),*/
          /*SizedBox(
            height: 20,
          ),
          FlatButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed("/build"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.create),
                  SizedBox(),
                  Text("Divide", style: TextStyle(fontSize: 35)),
                  SizedBox(),
                ],
              )),*/
          Spacer(),
          Divider(),
          FlatButton(
            onPressed: () => exit(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.power),
                SizedBox(),
                Text("Exit", style: TextStyle(fontSize: 35)),
                SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
