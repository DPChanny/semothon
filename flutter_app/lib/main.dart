import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final googleSignIn = GoogleSignIn();

  if (await googleSignIn.isSignedIn()) {
    await googleSignIn.disconnect();
  }

  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}
