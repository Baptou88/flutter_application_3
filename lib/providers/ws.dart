import 'dart:convert';
import 'dart:developer';

import 'package:flutter_application_3/global.dart';
import 'package:flutter_application_3/models/ws_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class Ws {
  final Uri wsUrl = Uri.parse("ws://hydro.hydro-babiat.ovh/ws");
  late final WebSocketChannel channel;
  late var stream = channel.stream.asBroadcastStream();
  bool enable = false;
  static const data = "data";
  Ws() {
    activate();
  }
  Stream<WsData> get dataEtangStream => stream
  
  .map<WsData>((event) {
        //log('ws map $event');

        //var data = event?['data'];
        //log('data $data');

        return WsData.fromJson(jsonDecode(event));
      });

  void activate() {
    log('Ws Activate');
    if (!enable) {
      channel = WebSocketChannel.connect(wsUrl);
    }
    enable = true;
    ws = true;
    log('Ws Enaled');
  }

  void desacivate() {
    log('Ws Desactivate');
    //enable = false;
    channel.sink.close(status.goingAway);
    ws = false;
  }

  void toggle() {
    log('Ws Toggle');
    if (enable) {
      desacivate();
    } else {
      activate();
    }
  }
}
