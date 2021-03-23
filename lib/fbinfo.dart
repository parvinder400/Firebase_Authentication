import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:new_auth/Loginpage.dart';

class FbInfo extends StatelessWidget {
  // final String udname;
  // final String udemail;

  // SignInInfo(this.udname, this.udemail);
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Facebook Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(_user.photoURL),
              backgroundColor: Colors.transparent,
            ),
            Text(_user.displayName),
            Text(_user.uid),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              child: Text("Log Out"),
              color: Color(0xFF6200EE),
              textColor: Colors.white,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPage()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
