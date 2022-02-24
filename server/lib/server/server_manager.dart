import 'dart:io';

import 'package:server/server/advertise_server.dart';
import 'package:server/server/response_manager.dart';

class ServerManager {
  static ResponseManager responseManger = ResponseManager();

  static Future<void> init() async {
    var port = 3858;
    var server = await HttpServer.bind(InternetAddress.anyIPv6, port);

    print(
      "Server is running on 'http://${server.address.address}:$port/'",
    );

    var message = '_dev-toolkit._tcp';
    var title = "DevToolkit";

    AdvertiseService(
      targetIP: "224.0.0.1",
      targetPort: port,
      title: title,
      multicastMessage: message,
      onPeerFound: (targetIp, targetHost) {
        print("Peer Found: $targetIp:$targetHost");
      },
    ).advertise().then((_) {

    });

    server.transform(WebSocketTransformer()).listen(responseManger.onRequest);
  }
}
