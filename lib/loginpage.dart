import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:new_auth/fbinfo.dart';

import 'package:new_auth/otpScreen.dart';
import 'package:new_auth/signininfo.dart';

import 'auth.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  void signinfunction() {
    signInWithGoogle().then((onValue) async {
      setState(() {
        processing = true;
      });
      await FirebaseFirestore.instance.collection('usersdata').add({
        'displayname': dname,
        'email': demail,
        'imageURL': dimage,
        'username': '',
        'phone': '',
      });
      setState(() {
        processing = false;
      });
    }).then((onValue) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInInfo()));
    });
  }

  TextEditingController _controller = TextEditingController();
  String _code;
  bool processing = false;

  String fbdname;
  String fbdemail;
  String fbdimage;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future _handleLogin() async {
    FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print('CancelledByUser');
        break;
      case FacebookLoginStatus.error:
        print('error');
        break;
      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(_result);
        break;
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    setState(() {
      processing = true;
    });
    FacebookAccessToken _accessToken = _result.accessToken;

    AuthCredential _credential =
        FacebookAuthProvider.credential(_accessToken.token);
    var a = await auth.signInWithCredential(_credential);
    User _user = (await auth.signInWithCredential(_credential)).user;
    assert(_user.email != null);
    assert(_user.displayName != null);
    assert(_user.photoURL != null);

    fbdname = _user.displayName;
    fbdemail = _user.email;
    fbdimage = _user.photoURL;

    await FirebaseFirestore.instance.collection('usersdata').add({
      'displayname': fbdname,
      'email': fbdemail,
      'imageURL': fbdimage,
      'username': '',
      'phone': '',
    });

    setState(() {
      processing = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => FbInfo()));
  }

  // void onLoginStatusChanged(bool isLoggedIn) {
  //   setState(() {
  //     this.processing = processing;
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => FbInfo()));
  //   });
  // }

  // void initiateFacebookLogin() async {
  //   // var _facebookLogin = FacebookLogin();
  //   // FacebookLoginResult facebookLoginResult =
  //   //     await _facebookLogin.logIn(['email']);
  //   var facebookLoginResult =
  //       await facebookLogin.logInWithReadPermissions(['email']);
  //   switch (facebookLoginResult.status) {
  //     case FacebookLoginStatus.error:
  //       print("Error");
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("CancelledByUser");
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       print("LoggedIn");
  //       onLoginStatusChanged(true);
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text('Firebase Phone Auth'),
      // ),
      body: !processing
          ? SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 150,
                          // width: 40,
                          child: Image(
                              image: AssetImage('assets/images/firebase.png'))),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Firebase Auth',
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          // color: const Color(0xff7c94b6),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              CountryCodePicker(
                                // initialSelection: 'IN',
                                // favorite: ['IN'],
                                onChanged: (CountryCode code) {
                                  // print(code.name);
                                  // print(code.code);
                                  _code = code.dialCode;
                                  print(_code);
                                },
                              ),
                              Container(
                                height: 20,
                                width: .2,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    hintText: "Enter Mobile Number",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 200,
                                  height: 50.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      if (_controller.text != '') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => OTPScreen(
                                                  _code.toString(),
                                                  _controller.text)),
                                        );
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xff374ABE),
                                              Color(0xff64B6FF)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 300.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Continue",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/google.jpeg'))),
                                  onTap: () {
                                    signinfunction();
                                    // FirebaseAuth auth = FirebaseAuth.instance;
                                    // await AuthMehtods()
                                    //     .signInWithGoogle()
                                    //     .then((value) {
                                    //   print(value);
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) => SignInInfo()));
                                    // });
                                  },
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                InkWell(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/facebook.jpeg'))),
                                  onTap: () {
                                    _handleLogin();
                                    // initiateFacebookLogin();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

// final FacebookLogin facebookLogin = new FacebookLogin();
// void signInUsingFacebook() async {
//   final FacebookLoginResult facebookLoginResult =
//       await facebookLogin.logInWithReadPermissions(['email']);
//   User user;
//   try {
//     user = await mAuth.signInWithFacebook(
//         // User user = (await _auth.signInWithCredential(credential)).user;
//         accessToken: facebookLoginResult.accessToken.token);
//   } catch (e) {
//     print(e);
//   } finally {
//     if (user != null) {
//       print('User is Logged in');
//     }
//   }
// }
