import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/env/.env");

  final String envName = dotenv.env['ENV'] ?? 'device';
  final bool local = bool.parse(dotenv.env['LOCAL'] ?? 'false');
  final String envFile =
      'assets/env/.env' + (local ? '.local' : '.server') + "." + envName + '';

  await dotenv.load(fileName: envFile);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
