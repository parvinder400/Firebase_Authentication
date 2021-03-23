import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:new_auth/Loginpage.dart';

class Show extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.displayName),
            Text(user.email),
            Text(user.phoneNumber),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              child: Text("Log OUt"),
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
