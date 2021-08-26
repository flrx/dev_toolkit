import 'dart:io';

import 'package:server/server/response_manager.dart';

class ServerManager {
  static ResponseManager responseManger = ResponseManager();

  static Future<void> init() async {
    var port = 3858;
    var server = await HttpServer.bind(InternetAddress.anyIPv6, port);

    print(
      "Server is running on 'http://${server.address.address}:$port/'",
    );

    server.transform(WebSocketTransformer()).listen(responseManger.onRequest);
  }
}
