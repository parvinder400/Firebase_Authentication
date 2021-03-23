import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:new_auth/show.dart';

class UserDetail extends StatefulWidget {
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final formKey = GlobalKey<FormState>();

  bool processing = false;

  void submit(
    BuildContext context, {
    String email,
    String username,
    String displayName,
  }) async {
    setState(() {
      processing = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    await user.updateEmail(email);
    await user.updateProfile(displayName: displayName);
    user.sendEmailVerification();

    ///// Write data to firestore
    await FirebaseFirestore.instance.collection('usersdata').add({
      'displayname': displayName,
      'email': email,
      'username': username,
      'phone': user.phoneNumber,
    });
    setState(() {
      processing = false;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Show(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String email, username, displayName;
// ayse try kr
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter the details'),
      ),
      body: processing
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Unique User Name',
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Enter valid username' : null,
                            onChanged: (value) => username = value,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Display Name',
                            ),
                            validator: (value) => value.isEmpty
                                ? 'Enter valid DisplayName'
                                : null,
                            onChanged: (value) => displayName = value,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            validator: (value) =>
                                value.isEmpty ? 'Enter valid email' : null,
                            onChanged: (value) => email = value,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                  child: Text('Submit'),
                                  color: Color(0xFF6200EE),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ==
                                        true) {
                                      submit(
                                        context,
                                        displayName: displayName,
                                        email: email,
                                        username: username,
                                      );
                                    }
                                  },
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
    );
  }
}
