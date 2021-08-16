import 'package:flutter/material.dart';
import 'package:movie_list_app/AUTH/auth.dart';
import 'package:movie_list_app/AUTH/login_screen.dart';
import 'package:movie_list_app/SCREENS/add_movie.dart';
import 'package:movie_list_app/SCREENS/my_movies.dart';
import 'package:movie_list_app/SCREENS/profile_screen.dart';
import 'package:movie_list_app/SCREENS/watched_movies.dart';

class HomeScreen extends StatefulWidget {
  final int goToIndex;
  HomeScreen({this.goToIndex});
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthMethods authMethods = new AuthMethods();

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    WatchedMovies(),
    MyMovies(),
    AddMovie(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.goToIndex == null ? 0 : widget.goToIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
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
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.done_rounded),
            label: 'Watched',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'MyMovies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        // backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[900],
        unselectedItemColor: Colors.black54,
        unselectedFontSize: ht * 0.015,
        selectedFontSize: ht * 0.015,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
