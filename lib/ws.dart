import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class Ws {
  bool enable = false;
  var wsUrl = Uri.parse("ws://hydro.hydro-babiat.ovh/ws");
  late WebSocketChannel channel;
  Ws(){
    //channel = WebSocketChannel.connect(wsUrl);
    activate();
  }
  void activate(){
    enable = true;
    channel = WebSocketChannel.connect(wsUrl);
  }
  void desacivate () {
    enable = false;
    channel.sink.close(status.goingAway);
  }
  void toggle(){
    if (enable) {
      desacivate();
    } else {
      activate();
    }
  }
}