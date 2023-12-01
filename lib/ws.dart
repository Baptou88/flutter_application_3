import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class Ws {
  static final  Ws _instance = Ws._internal();
  bool enable = false;
  var wsUrl = Uri.parse("ws://hydro.hydro-babiat.ovh/ws");
  late WebSocketChannel channel;
  
  factory Ws(){
    //channel = WebSocketChannel.connect(wsUrl);
    log('Ws constructeur');

    return _instance;
  }
  
  Ws._internal() {
    activate();

  }
  void activate(){
    log('Ws Activate');
    enable = true;
    channel = WebSocketChannel.connect(wsUrl);
  }
  void desacivate () {
    log('Ws Desactivate');
    enable = false;
    channel.sink.close(status.goingAway);
  }
  void toggle(){
    log('Ws Toggle');
    if (enable) {
      desacivate();
    } else {
      activate();
    }
  }
}