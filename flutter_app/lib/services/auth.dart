import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn getGoogleSignIn() {
  final GoogleSignIn googleSignIn;
  if (bool.parse(dotenv.env['WEB'] ?? 'false')) {
    googleSignIn = GoogleSignIn(
      clientId:
          "254852353422-kcl2cd2d287plmqrr2vdui80coh9koq3.apps.googleusercontent.com",
    );
  } else {
    googleSignIn = GoogleSignIn();
  }

  return googleSignIn;
}
