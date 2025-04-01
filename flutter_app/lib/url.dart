import 'package:flutter_dotenv/flutter_dotenv.dart';

Uri url(String path) {
  final protocol = dotenv.env['PROTOCOL'];
  final host = dotenv.env['HOST'];
  final port = int.parse(dotenv.env['PORT'] ?? "8080");

  return Uri(
    scheme: protocol,
    host: host,
    port: port,
    path: path,
  );
}
