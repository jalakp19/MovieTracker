import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}

InputDecoration searchDecoration(double ht, double wt) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
    hintText: 'Search your movie...',
    hintStyle: TextStyle(
      fontSize: ht * 0.02,
    ),
    contentPadding: EdgeInsets.only(
      left: wt * 0.025,
      top: ht * 0.01,
      bottom: ht * 0.012,
      right: wt * 0.025,
    ),
  );
}

AlertDialog searchInfoDialog(double ht, BuildContext context, int i) {
  return AlertDialog(
    title: Text(i == 0
        ? 'List of watched movies\nYou can search by:'
        : 'Your movie collection\nYou can search by:'),
    content: Text('Movie name\nDirectors\'s name\nRelease Year\nImdb Rating'),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'Done',
          style: TextStyle(
            fontSize: ht * 0.02,
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

InputDecoration textFieldAddMovieDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );
}
