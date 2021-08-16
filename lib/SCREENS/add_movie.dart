import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_list_app/AUTH/auth.dart';
import 'package:movie_list_app/CRUD/database.dart';
import 'package:movie_list_app/EXTRAS/constants.dart';
import 'package:movie_list_app/EXTRAS/rounded_bottom.dart';
import 'package:movie_list_app/SCREENS/home_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddMovie extends StatefulWidget {
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  TextEditingController movieNameTEC = new TextEditingController();
  TextEditingController directorNameTEC = new TextEditingController();
  TextEditingController yearTEC = new TextEditingController();
  TextEditingController imdbTEC = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  User user = FirebaseAuth.instance.currentUser;

  MLProvider mymlist = MLProvider();
  var uuid = Uuid();

  int watched = 1;
  String img64;
  var bytes2;
  bool validateImage = false;
  bool spinner = false;

  final _formKey = GlobalKey<FormState>();
  _saveForm() async {
    ML mlobj = ML();
    mlobj.name = movieNameTEC.text;
    mlobj.director = directorNameTEC.text;
    mlobj.year = yearTEC.text;
    mlobj.imdb = imdbTEC.text;
    mlobj.img = img64;
    mlobj.watched = watched == 0 ? 'true' : 'false';
    mlobj.email = user.email;
    mlobj.id = uuid.v1();

    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'wishlist.db';

    await mymlist.open(path);

    mymlist.insert(mlobj);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          goToIndex: 1,
        ),
      ),
    );

    Fluttertoast.showToast(
        msg: "New movie added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _saveForm();
    }
  }

  File newProfilePic;
  Future getImage() async {
    var tempImg = await ImagePicker().getImage(source: ImageSource.gallery);
    newProfilePic = File(tempImg.path);
    bytes2 = newProfilePic.readAsBytesSync();
    setState(() {
      img64 = base64Encode(bytes2);
    });
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white54,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: wt * 0.05),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Container(
                                              width: wt,
                                              height: ht / 2.5,
                                              padding: EdgeInsets.all(1.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: validateImage
                                                        ? Colors.red[700]
                                                        : Colors.black,
                                                    width: 1),
                                                shape: BoxShape.rectangle,
                                                color: Colors.grey[300],
                                              ),
                                              child: bytes2 != null
                                                  ? Image.memory(bytes2,
                                                      fit: BoxFit.cover)
                                                  : null,
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: wt / 1.8,
                                    height: ht / 3.5,
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: validateImage
                                              ? Colors.red[700]
                                              : Colors.black,
                                          width: 1),
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey[300],
                                    ),
                                    child: bytes2 != null
                                        ? Image.memory(bytes2,
                                            fit: BoxFit.cover)
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: wt / 2.0, top: ht / 4.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.white,
                                      onPressed: () {
                                        getImage();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: validateImage,
                            child: Text(
                              'Please upload an image',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.05,
                                      vertical: ht * 0.0075),
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: movieNameTEC,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: textFieldAddMovieDecoration(
                                        'Enter movie name'),
                                    validator: (input) => (input
                                                    .trim()
                                                    .length ==
                                                0 ||
                                            input.trim().length > 60)
                                        ? 'Name should be less than or equal to 60 characters'
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.05,
                                      vertical: ht * 0.0075),
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: directorNameTEC,
                                    decoration: textFieldAddMovieDecoration(
                                        'Enter directors\'s name.'),
                                    validator: (input) => (input
                                                    .trim()
                                                    .length ==
                                                0 ||
                                            input.trim().length > 30)
                                        ? 'Name should be less than or equal to 30 characters'
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.05,
                                      vertical: ht * 0.0075),
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: yearTEC,
                                    keyboardType: TextInputType.number,
                                    decoration: textFieldAddMovieDecoration(
                                        'Enter release year.'),
                                    validator: (input) => (input
                                                    .trim()
                                                    .length ==
                                                0 ||
                                            int.parse(input) < 1800 ||
                                            int.parse(input) > 2021)
                                        ? 'Year should be in between 1800 and 2021'
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.05,
                                      vertical: ht * 0.0075),
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: imdbTEC,
                                    keyboardType: TextInputType.number,
                                    decoration: textFieldAddMovieDecoration(
                                        'Enter imdb rating.'),
                                    validator: (input) => (input
                                                    .trim()
                                                    .length ==
                                                0 ||
                                            double.parse(input) < 0.0 ||
                                            double.parse(input) > 10.0)
                                        ? 'imdb should be in between 0 and 10'
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.06,
                                      vertical: ht * 0.005),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: wt * 0.03, top: ht * 0.01),
                                        child: Text(
                                          'Watched ?',
                                          style: TextStyle(
                                              fontSize: ht * 0.02,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      ToggleSwitch(
                                        minWidth: 90.0,
                                        cornerRadius: 20.0,
                                        activeBgColors: [
                                          Colors.cyan,
                                          Colors.redAccent
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        labels: ['', ''],
                                        initialLabelIndex: 1,
                                        icons: [Icons.done, Icons.close],
                                        onToggle: (index) {
                                          print('switched to: $index');
                                          watched = index;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: RoundedButton(
                                    color: Colors.amber[900],
                                    txt: 'Add New Movie',
                                    onpressed: () {
                                      if (img64 == null) {
                                        setState(() {
                                          validateImage = true;
                                        });
                                      } else {
                                        setState(() {
                                          validateImage = false;
                                        });
                                        _submit();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
