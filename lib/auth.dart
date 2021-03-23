import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

String dname;
String demail;
String dimage;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  User user = (await _auth.signInWithCredential(credential)).user;
  print(user.providerData);

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoURL != null);

  dname = user.displayName;
  demail = user.email;
  dimage = user.photoURL;

  // final FirebaseUser currentUser = await _auth.currentUser(
  // assert(user.uid == currentUser.uid);

  return 'signInWithGoogle Succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print('User Sign out');
}
