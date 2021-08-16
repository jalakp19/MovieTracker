import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_list_app/AUTH/auth.dart';
import 'package:movie_list_app/CRUD/database.dart';
import 'package:movie_list_app/EXTRAS/constants.dart';
import 'package:movie_list_app/EXTRAS/my_card.dart';
import 'package:sqflite/sqflite.dart';

class MyMovies extends StatefulWidget {
  @override
  _MyMoviesState createState() => _MyMoviesState();
}

class _MyMoviesState extends State<MyMovies> {
  TextEditingController myController = new TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  User user = FirebaseAuth.instance.currentUser;
  List<ML> anss = [];
  List<ML> displayList = [];
  List<ML> tempanss;
  int itemctr = 0;
  MLProvider mymlist = MLProvider();

  refreshState() {
    setState(() {
      displayList = anss;
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
        anss.add(tempanss[i]);
      }
    }

    refreshState();
  }

  updateScreen(String searchText) {
    displayList = [];
    for (int i = 0; i < anss.length; i++) {
      if (anss[i]
          .name
          .toString()
          .contains(RegExp(myController.text, caseSensitive: false))) {
        displayList.add(anss[i]);
      } else if (anss[i]
          .director
          .toString()
          .contains(RegExp(myController.text, caseSensitive: false))) {
        displayList.add(anss[i]);
      } else if (anss[i]
          .year
          .toString()
          .contains(RegExp(myController.text, caseSensitive: false))) {
        displayList.add(anss[i]);
      } else if (anss[i]
          .imdb
          .toString()
          .contains(RegExp(myController.text, caseSensitive: false))) {
        displayList.add(anss[i]);
      }
    }
    setState(() {
      displayList = displayList;
    });
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
        color: Colors.white54,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: wt * 0.025,
                vertical: ht * 0.015,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: myController,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontSize: ht * 0.02,
                      ),
                      decoration: searchDecoration(ht, wt),
                      onChanged: (val) {
                        updateScreen(myController.text);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return searchInfoDialog(ht, context, 1);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            (displayList == null || displayList.length == 0)
                ? Flexible(
                    child: Container(
                      height: ht * 0.65,
                      child: Center(
                        child: Text(
                          myController.text.length == 0
                              ? 'Your movie collection is empty :('
                              : 'Search not found :(',
                          style: TextStyle(
                            color: Colors.black45,
                            letterSpacing: 1,
                            fontSize: ht * 0.02,
                          ),
                        ),
                      ),
                    ),
                  )
                : Flexible(
                    child: ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return MovieCard(
                          name: displayList[i].name,
                          director: displayList[i].director,
                          year: displayList[i].year,
                          imdb: displayList[i].imdb,
                          image: displayList[i].img,
                          watched: displayList[i].watched,
                          id: displayList[i].id,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
