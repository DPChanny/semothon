import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/env/.env");

  final String envName = dotenv.env['ENV'] ?? 'device';
  final bool local = bool.parse(dotenv.env['LOCAL'] ?? 'false');
  final String envFile =
      'assets/env/.env' + (local ? '.local' : '.server') + "." + envName + '';

  await dotenv.load(fileName: envFile);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final GoogleSignIn? googleSignIn;
  if (bool.parse(dotenv.env['WEB'] ?? 'false')) {
    googleSignIn = GoogleSignIn(
      clientId:
          "254852353422-kcl2cd2d287plmqrr2vdui80coh9koq3.apps.googleusercontent.com",
    );
  } else {
    googleSignIn = GoogleSignIn();
  }

  if (await googleSignIn.isSignedIn()) {
    await googleSignIn.disconnect();
  }
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}
