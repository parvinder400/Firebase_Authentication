import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:new_auth/Loginpage.dart';
import 'package:new_auth/auth.dart';

class SignInInfo extends StatelessWidget {
  // final String udname;
  // final String udemail;

  // SignInInfo(this.udname, this.udemail);
  // final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Google SignIN"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage("${dimage}"),
              backgroundColor: Colors.transparent,
            ),
            Text(dname),
            Text(demail),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              child: Text("Log OUt"),
              color: Color(0xFF6200EE),
              textColor: Colors.white,
              onPressed: () async {
                dimage = '';
                dname = '';
                demail = '';
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
