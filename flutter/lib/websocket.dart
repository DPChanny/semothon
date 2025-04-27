import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';

class StompService {
  static final StompService _instance = StompService._internal();

  static StompService get instance => _instance;

  StompService._internal();

  StompClient? _client;

  final Map<String, StompUnsubscribe> _subscriptions = {};

  bool get connected => _client?.connected ?? false;

  Future<void> connect() async {
    if (connected) return;

    final springHost = dotenv.env['SPRING_HOST'];
    final springPort = int.parse(dotenv.env['SPRING_PORT']!);
    final idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);

    final url =
        Uri(
          scheme: 'ws',
          host: springHost,
          port: springPort,
          path: 'ws-stomp',
        ).toString();

    _client = StompClient(
      config: StompConfig(
        url: url,
        onConnect: _onConnect,
        onWebSocketError: (error) => print('[STOMP] WebSocket error: $error'),
        webSocketConnectHeaders: {'Authorization': 'Bearer $idToken'},
        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
      ),
    );

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    print('[STOMP] Connected');
  }

  void subscribe(
    String destination,
    void Function(StompFrame frame) onMessage,
  ) {
    if (_subscriptions.containsKey(destination)) {
      print('[STOMP] Already subscribed to $destination');
      return;
    }

    final subscription = _client?.subscribe(
      destination: destination,
      callback: onMessage,
    );

    if (subscription != null) {
      _subscriptions[destination] = subscription;
      print('[STOMP] Subscribed to $destination');
    }
  }

  void unsubscribe(String destination) {
    final subscription = _subscriptions[destination];
    if (subscription != null) {
      subscription.call();
      _subscriptions.remove(destination);
      print('[STOMP] Unsubscribed from $destination');
    } else {
      print('[STOMP] No active subscription to $destination');
    }
  }

  void send(String destination, String body) async {
    final idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);

    if (!connected) {
      print('[STOMP] Not connected. Message not sent.');
      return;
    }

    _client?.send(
      destination: destination,
      body: body,
      headers: {'Authorization': 'Bearer $idToken'},
    );
    print('[STOMP] Sent to $destination: $body');
  }

  void disconnect() {
    _client?.deactivate();
    _subscriptions.clear();
    print('[STOMP] Disconnected');
  }
}
