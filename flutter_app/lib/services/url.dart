import 'package:flutter_dotenv/flutter_dotenv.dart';

Uri url(String path, {Map<String, dynamic>? queryParams}) {
  final springHost = dotenv.env['SPRING_HOST'];
  final springPort = int.parse(dotenv.env['SPRING_PORT']!);

  return Uri(
    scheme: "http",
    host: springHost,
    port: springPort,
    path: path,
    queryParameters: queryParams?.map((key, value) {
      if (value is List) {
        return MapEntry(key, value.join(','));
      }
      return MapEntry(key, value.toString());
    }),
  );
}
