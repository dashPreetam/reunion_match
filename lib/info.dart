import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reunion_match/customAppBar.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberCOntroller = new TextEditingController();

  String name;
  String number;
  String sleeve;
  String neck;
  String size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ExpansionTile(
                title: Text(
                  "Name on Jersey",
                  style: TextStyle(fontSize: 20),
                ),
                children: [
                  nameInput(context),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ExpansionTile(
                title: Text("Number on Jersey", style: TextStyle(fontSize: 20)),
                children: [
                  numberInput(context),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ExpansionTile(
                title: Text(
                  "Jersey Sleeve",
                  style: TextStyle(fontSize: 20),
                ),
                children: [
                  sleeveInput(context),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ExpansionTile(
                title: Text("Jersey Neck Type", style: TextStyle(fontSize: 20)),
                children: [
                  neckInput(context),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ExpansionTile(
                title: Text("Jersey Size", style: TextStyle(fontSize: 20)),
                children: [
                  sizeInput(context),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: RaisedButton(
                child: Text("Done", style: TextStyle(fontSize: 20)),
                onPressed: () => uploadvalues(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  nameInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "XXXXXXXX"),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  numberInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: numberCOntroller,
              decoration: InputDecoration(hintText: "XX"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  number = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  sleeveInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              hint: Text("Sleeve"),
              value: sleeve,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
              ),
              onChanged: (String newValue) {
                setState(() {
                  sleeve = newValue;
                });
              },
              items: <String>['Half', 'Full']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  neckInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              hint: Text("Neck"),
              value: neck,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
              ),
              onChanged: (String newValue) {
                setState(() {
                  neck = newValue;
                });
              },
              items: <String>['Round', 'V-Neck']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  sizeInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
              child: DropdownButton<String>(
            hint: Text("Size"),
            value: size,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (String newValue) {
              setState(() {
                size = newValue;
              });
            },
            items: <String>['S', 'M', 'L', 'XL']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  void uploadvalues(BuildContext context) {
    if (name != null &&
        number != null &&
        size != null &&
        neck != null &&
        sleeve != null) {
      var user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Members').doc(user.uid).update({
        "jerseyName": name,
        "jerseySize": size,
        "jerseyNumber": number,
        "jerseyNeck": neck,
        "jerseySleeve": sleeve,
      });
      FocusScope.of(context).unfocus();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Info Updated")));
      Navigator.of(context).pushReplacementNamed("/votes");
    } else {
      FocusScope.of(context).unfocus();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Enter all fields")));
    }
  }
}
