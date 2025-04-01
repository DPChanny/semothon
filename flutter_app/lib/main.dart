import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_app/app.dart';
import 'package:flutter_app/firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/env/.env");

  final String envName = dotenv.env['ENV'] ?? 'device';
  final bool local = bool.parse(dotenv.env['LOCAL'] ?? 'false');
  print(dotenv.env['LOCAL']);
  print(local);
  final String envFile = 'assets/env/.env' + (local ? '.local' : '.server') + "." + envName + '';
  print(envFile);

  await dotenv.load(fileName: envFile);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final googleSignIn = GoogleSignIn();

  if (await googleSignIn.isSignedIn()) {
    await googleSignIn.disconnect();
  }
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}
