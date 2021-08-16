import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:movie_list_app/AUTH/auth.dart';
import 'package:movie_list_app/AUTH/forgot_password.dart';
import 'package:movie_list_app/AUTH/register_screen.dart';
import 'package:movie_list_app/EXTRAS/constants.dart';
import 'package:movie_list_app/EXTRAS/rounded_bottom.dart';
import 'package:movie_list_app/MODALS/user.dart';
import 'package:movie_list_app/SCREENS/home_screen.dart';

//ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  String error;
  LoginScreen({this.error});
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool spinner = false;
  AuthMethods authMethods = new AuthMethods();
  String error;

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //login the user with firebase
      setState(() {
        spinner = true;
      });

      try {
        FBUser currUser;
        currUser = await authMethods.signInWithEmailAndPassword(
            emailTEC.text, passwordTEC.text);
        if (currUser != null) {
          User user = FirebaseAuth.instance.currentUser;

          if (!user.emailVerified) {
            print(user.email);
            await user.sendEmailVerification();
            setState(() {
              error =
                  'A link has been sent to verify your email. Please verify your email and then login';
            });
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        }
        setState(() {
          spinner = false;
        });
      } catch (e) {
        setState(() {
          error = e.message;
          spinner = false;
        });
        print(e.toString());
      }
    }
  }

  Widget showAlert() {
    if (error != null || widget.error != null) {
      if (error == null) {
        error = widget.error;
        widget.error = null;
      }
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        margin: EdgeInsets.only(top: 35.0),
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                error,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            showAlert(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: ht * 0.05),
                        child: Text(
                          'MovieTracker',
                          style: TextStyle(
                            color: Colors.orange[900],
                            // color: Color(0xFF12867E),
                            fontWeight: FontWeight.w500,
                            fontSize: wt * 0.2,
                            fontFamily: 'Billabong',
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: wt * 0.05, vertical: ht * 0.0125),
                              child: TextFormField(
                                controller: emailTEC,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.emailAddress,
                                decoration:
                                    textFieldDecoration('Enter you email.'),
                                validator: (input) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(input)
                                      ? null
                                      : 'Enter a valid email address';
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: wt * 0.05, vertical: ht * 0.0125),
                              child: TextFormField(
                                controller: passwordTEC,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                decoration:
                                    textFieldDecoration('Enter your password.'),
                                validator: (input) => input.length < 6
                                    ? 'Password must be atleast 6 characters'
                                    : null,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          ForgotPassword()).then((value) {
                                    setState(() {
                                      if (value == true) {
                                        error =
                                            'A link to reset your password has been sent to your registered email address';
                                      }
                                    });
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.075,
                                      vertical: ht * 0.01),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.02,
                            // ),
                            RoundedButton(
                              color: Colors.blueAccent,
                              txt: 'Log In',
                              onpressed: _submit,
                            ),
                            RoundedButton(
                              color: Colors.red[700],
                              txt: 'Sign In with Google',
                              onpressed: () async {
                                setState(() {
                                  spinner = true;
                                });

                                try {
                                  FBUser currUser;
                                  currUser =
                                      await authMethods.signInWithGoogle();

                                  if (currUser != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  }
                                  setState(() {
                                    spinner = false;
                                  });
                                } catch (e) {
                                  setState(() {
                                    error = e.message;
                                    spinner = false;
                                  });
                                  print(e.toString());
                                }
                              },
                            ),
                            SizedBox(
                              height: ht * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ht * 0.018,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  child: Text(
                                    'Register Now!!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ht * 0.018,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
