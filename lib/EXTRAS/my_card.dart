import 'package:flutter/material.dart';
import 'package:movie_list_app/SCREENS/home_screen.dart';
import 'dart:convert';

import 'package:movie_list_app/SCREENS/movie_page.dart';

class MovieCard extends StatefulWidget {
  final String image;
  final String name;
  final String director;
  final String year;
  final String imdb;
  final String watched;
  final String id;
  final String email;

  MovieCard(
      {this.image,
      this.name,
      this.director,
      this.year,
      this.imdb,
      this.watched,
      this.id,
      this.email});

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    var bytes = base64Decode(widget.image);
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoviePage(
                bytes: bytes,
                name: widget.name,
                director: widget.director,
                year: widget.year,
                imdb: widget.imdb,
                watched: widget.watched,
                id: widget.id,
                email: widget.email,
              ),
            ),
          ).then((value) {
            print(value);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  goToIndex: value,
                ),
              ),
            );
          });
        },
        child: Card(
          margin:
              EdgeInsets.symmetric(vertical: ht * 0.008, horizontal: wt * 0.02),
          elevation: 5,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: ht * 0.008, horizontal: wt * 0.02),
              height: ht * 0.175,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        bytes: bytes,
                        name: widget.name,
                        director: widget.director,
                        year: widget.year,
                        imdb: widget.imdb,
                        watched: widget.watched,
                        id: widget.id,
                        email: widget.email,
                      ),
                    ),
                  ).then(
                    (value) {
                      print(value);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            goToIndex: value,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: <Widget>[
                    Container(
                        height: ht * 0.17,
                        width: wt * 0.275,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        child: Image.memory(bytes, fit: BoxFit.cover)),
                    Container(
                      height: ht * 0.175,
                      width: wt * 0.625,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 1),
                              child: Container(
                                width: wt / 1.6,
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  widget.name,
                                  style: TextStyle(
                                    fontSize: ht * 0.02,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 1),
                              child: Container(
                                width: wt / 1.6,
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  'Director: ${widget.director}',
                                  style: TextStyle(
                                    fontSize: ht * 0.02,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 1),
                              child: Container(
                                width: wt / 1.6,
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  'Year: ${widget.year}',
                                  style: TextStyle(
                                    fontSize: ht * 0.02,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.teal),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  'Imdb: ${widget.imdb}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
