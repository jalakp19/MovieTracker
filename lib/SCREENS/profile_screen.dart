import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_list_app/AUTH/auth.dart';
import 'package:movie_list_app/CRUD/database.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthMethods authMethods = new AuthMethods();
  User user = FirebaseAuth.instance.currentUser;
  MLProvider mymlist = MLProvider();
  List<ML> tempanss = [];
  int wcctr = 0;
  int ctr = 0;

  refreshState() {
    setState(() {
      wcctr = wcctr;
      ctr = ctr;
    });
  }

  printList() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'wishlist.db';

    await mymlist.open(path);

    tempanss = await mymlist.getML();

    for (int i = tempanss.length - 1; i >= 0; i--) {
      print(tempanss[i].name);
      print(tempanss[i].director);
      print(tempanss[i].year);
      print(tempanss[i].imdb);
      print(tempanss[i].id);
      print(tempanss[i].watched);
      print('-----------------------');
      if (tempanss[i].email == user.email) {
        ctr++;
        if (tempanss[i].watched == 'true') {
          wcctr++;
        }
      }
    }

    refreshState();
  }

  @override
  void initState() {
    printList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(),
              ),
              Container(
                padding: EdgeInsets.only(left: wt * 0.08, right: wt * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: wt * 0.025),
                      child: Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ht * 0.018,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0005,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      // color: Color(0xFF128C7E),
                      color: Colors.amber[900],
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: wt * 0.05, vertical: ht * 0.015),
                        child: Text(
                          user.displayName,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: wt * 0.08, right: wt * 0.08, top: ht * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: wt * 0.025),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ht * 0.018,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0005,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      // color: Color(0xFF128C7E),
                      color: Colors.amber[900],
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: wt * 0.05, vertical: ht * 0.015),
                        child: Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.only(top: ht * 0.1),
                child: CircularPercentIndicator(
                  radius: ht * 0.25,
                  lineWidth: ht * 0.035,
                  animation: true,
                  percent: ctr != 0 ? wcctr / ctr : 0.0,
                  center: new Text(
                    wcctr.toString() + '/' + ctr.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: ht * 0.025),
                  ),
                  footer: Padding(
                    padding: EdgeInsets.only(top: ht * 0.0225),
                    child: Container(
                      child: Text(
                        "Watched " +
                            wcctr.toString() +
                            " movie(s),\n " +
                            (ctr-wcctr).toString() +
                            " remaining",
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ht * 0.02,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.amber[900],
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
