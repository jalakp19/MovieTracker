import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_list_app/AUTH/auth.dart';
import 'package:movie_list_app/AUTH/login_screen.dart';
import 'package:movie_list_app/CRUD/database.dart';
import 'package:movie_list_app/EXTRAS/rounded_bottom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toggle_switch/toggle_switch.dart';

//ignore: must_be_immutable
class MoviePage extends StatefulWidget {
  var bytes;
  String name;
  String director;
  String year;
  String imdb;
  String watched;
  String id;
  String email;
  MoviePage({
    this.bytes,
    this.name,
    this.director,
    this.year,
    this.imdb,
    this.watched,
    this.id,
    this.email,
  });
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  TextEditingController movieNameTEC = new TextEditingController();
  TextEditingController directorNameTEC = new TextEditingController();
  TextEditingController yearTEC = new TextEditingController();
  TextEditingController imdbTEC = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  User user = FirebaseAuth.instance.currentUser;
  MLProvider mymlist = MLProvider();

  int watched = 0;
  String img64;
  var bytes2;
  bool validateImage = false;

  File newProfilePic;
  Future getImage() async {
    var tempImg = await ImagePicker().getImage(source: ImageSource.gallery);
    newProfilePic = File(tempImg.path);
    bytes2 = newProfilePic.readAsBytesSync();
    setState(() {
      img64 = base64Encode(bytes2);
    });
  }

  initializeTextControllers() {
    movieNameTEC.text = widget.name;
    directorNameTEC.text = widget.director;
    yearTEC.text = widget.year;
    imdbTEC.text = widget.imdb;
  }

  updateDataBase() async {
    ML mlobj = ML();
    mlobj.name = movieNameTEC.text;
    mlobj.director = directorNameTEC.text;
    mlobj.year = yearTEC.text;
    mlobj.imdb = imdbTEC.text;
    mlobj.img = img64;
    mlobj.watched = watched == 0 ? 'true' : 'false';
    mlobj.email = user.email;
    mlobj.id = widget.id;

    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'wishlist.db';

    await mymlist.open(path);

    mymlist.update(mlobj);
  }

  deleteMovie() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'wishlist.db';

    await mymlist.open(path);

    mymlist.delete(widget.id);
  }

  @override
  void initState() {
    img64 = base64Encode(widget.bytes);
    bytes2 = widget.bytes;
    watched = widget.watched == 'true' ? 0 : 1;
    initializeTextControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ht * 0.07),
        child: AppBar(
          // backgroundColor: Color(0xFF12867E),
          backgroundColor: Colors.amber[900],
          leading: Padding(
            padding: EdgeInsets.only(
              left: ht * 0.01,
              top: ht * 0.0075,
            ),
            child: Icon(
              Icons.slow_motion_video,
              size: ht * 0.045,
            ),
          ),
          titleSpacing: 0.0,
          title: Padding(
            padding: EdgeInsets.only(left: wt * 0.02, top: ht * 0.01),
            child: Text(
              'Movie Tracker',
              style: TextStyle(
                fontSize: ht * 0.0275,
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                try {
                  await authMethods.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: ht * 0.008, right: wt * 0.04),
                child: Icon(
                  Icons.logout,
                  size: ht * 0.0325,
                ),
              ),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, watched);
          return false;
        },
        child: Container(
          child: SingleChildScrollView(
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
                          padding: EdgeInsets.only(
                              top: ht * 0.02, bottom: ht * 0.02),
                          child: Column(
                            children: [
                              Stack(
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
                                                    : Image.memory(widget.bytes,
                                                        fit: BoxFit.cover),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: wt / 1.8,
                                      height: ht / 3.5,
                                      padding: EdgeInsets.all(10.0),
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
                                          : Image.memory(widget.bytes,
                                              fit: BoxFit.cover),
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
                                          updateDataBase();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ht * 0.02,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: wt * 0.05,
                                    vertical: ht * 0.0075),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: wt * 0.05,
                                            top: ht * 0.013,
                                            bottom: ht * 0.013),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                movieNameTEC.text,
                                                style: TextStyle(
                                                    fontSize: ht * 0.019,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(
                                        right: 10.0,
                                        left: 10.0,
                                      ),
                                      icon: Icon(Icons.edit),
                                      color: Colors.amber[900],
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            final _formKey =
                                                GlobalKey<FormState>();

                                            return AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.red[700],
                                                    size: ht * 0.03,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '  Edit Movie Name',
                                                      style: TextStyle(
                                                        fontSize: ht * 0.02,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              content: Form(
                                                key: _formKey,
                                                child: TextFormField(
                                                  autofocus: true,
                                                  cursorColor: Colors.black,
                                                  controller: movieNameTEC,
                                                  textAlign: TextAlign.center,
                                                  validator: (input) => (input
                                                                  .trim()
                                                                  .length ==
                                                              0 ||
                                                          input.trim().length >
                                                              60)
                                                      ? 'Name should be less than or equal to 60 characters'
                                                      : null,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black54),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    'Done',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      _formKey.currentState
                                                          .save();
                                                      updateDataBase();

                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: wt * 0.05,
                                    vertical: ht * 0.0075),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: wt * 0.05,
                                            top: ht * 0.013,
                                            bottom: ht * 0.013),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Director : ' +
                                                    directorNameTEC.text,
                                                style: TextStyle(
                                                    fontSize: ht * 0.019,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(
                                        right: 10.0,
                                        left: 10.0,
                                      ),
                                      icon: Icon(Icons.edit),
                                      color: Colors.amber[900],
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            final _formKey =
                                                GlobalKey<FormState>();

                                            return AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.red[700],
                                                    size: ht * 0.03,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '  Edit Director Name',
                                                      style: TextStyle(
                                                        fontSize: ht * 0.02,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              content: Form(
                                                key: _formKey,
                                                child: TextFormField(
                                                  autofocus: true,
                                                  cursorColor: Colors.black,
                                                  controller: directorNameTEC,
                                                  textAlign: TextAlign.center,
                                                  validator: (input) => (input
                                                                  .trim()
                                                                  .length ==
                                                              0 ||
                                                          input.trim().length >
                                                              30)
                                                      ? 'Name should be less than or equal to 30 characters'
                                                      : null,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black54),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                    child: Text(
                                                      'Done',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (_formKey.currentState
                                                          .validate()) {
                                                        _formKey.currentState
                                                            .save();
                                                        updateDataBase();

                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: wt * 0.05,
                                    vertical: ht * 0.0075),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: wt * 0.05,
                                            top: ht * 0.013,
                                            bottom: ht * 0.013),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Year : ' + yearTEC.text,
                                                style: TextStyle(
                                                    fontSize: ht * 0.019,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(
                                        right: 10.0,
                                        left: 10.0,
                                      ),
                                      icon: Icon(Icons.edit),
                                      color: Colors.amber[900],
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            final _formKey =
                                                GlobalKey<FormState>();

                                            return AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.red[700],
                                                    size: ht * 0.03,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '  Edit Release Year',
                                                      style: TextStyle(
                                                        fontSize: ht * 0.02,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              content: Form(
                                                key: _formKey,
                                                child: TextFormField(
                                                  autofocus: true,
                                                  cursorColor: Colors.black,
                                                  controller: yearTEC,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  validator: (input) => (input
                                                                  .trim()
                                                                  .length ==
                                                              0 ||
                                                          int.parse(input) <
                                                              1800 ||
                                                          int.parse(input) >
                                                              2021)
                                                      ? 'Year should be in between 1800 and 2021'
                                                      : null,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black54),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                    child: Text(
                                                      'Done',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (_formKey.currentState
                                                          .validate()) {
                                                        _formKey.currentState
                                                            .save();
                                                        updateDataBase();

                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: wt * 0.05,
                                    vertical: ht * 0.0075),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.grey[300],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: wt * 0.05,
                                            top: ht * 0.013,
                                            bottom: ht * 0.013),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Imdb Rating : ' + imdbTEC.text,
                                                style: TextStyle(
                                                    fontSize: ht * 0.019,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(
                                        right: 10.0,
                                        left: 10.0,
                                      ),
                                      icon: Icon(Icons.edit),
                                      color: Colors.amber[900],
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            final _formKey =
                                                GlobalKey<FormState>();

                                            return AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.red[700],
                                                    size: ht * 0.03,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '  Edit Imdb Rating',
                                                      style: TextStyle(
                                                        fontSize: ht * 0.02,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              content: Form(
                                                key: _formKey,
                                                child: TextFormField(
                                                  autofocus: true,
                                                  cursorColor: Colors.black,
                                                  controller: imdbTEC,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  validator: (input) => (input
                                                                  .trim()
                                                                  .length ==
                                                              0 ||
                                                          double.parse(input) <
                                                              0.0 ||
                                                          double.parse(input) >
                                                              10.0)
                                                      ? 'imdb should be in between 0 and 10'
                                                      : null,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black54),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    'Done',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      _formKey.currentState
                                                          .save();
                                                      updateDataBase();

                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: wt * 0.06, vertical: ht * 0.01),
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
                                            fontSize: ht * 0.0225,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500),
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
                                      initialLabelIndex: watched,
                                      icons: [Icons.done, Icons.close],
                                      onToggle: (index) {
                                        print('switched to: $index');
                                        watched = index;
                                        if (watched == 1) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Item removed from Watched Movies",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Item added to Watched Movies",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                        updateDataBase();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              RoundedButton(
                                color: Colors.red,
                                txt: 'Delete this Movie',
                                onpressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_rounded,
                                              color: Colors.red[700],
                                              size: 40.0,
                                            ),
                                            Text(' Are you sure ?')
                                          ],
                                        ),
                                        content: Text(
                                            'This record will be permanently deleted'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.red[700],
                                              ),
                                            ),
                                            onPressed: () {
                                              deleteMovie();
                                              Fluttertoast.showToast(
                                                msg: "Movie deleted",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
        ),
      ),
    );
  }
}
