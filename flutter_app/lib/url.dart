import 'package:flutter_dotenv/flutter_dotenv.dart';

Uri url(String path) {
  final springHost = dotenv.env['SPRING_HOST'];
  final springPort = int.parse(dotenv.env['SPRING_PORT']!);

  return Uri(
    scheme: "http",
    host: springHost,
    port: springPort,
    path: path,
  );
}
