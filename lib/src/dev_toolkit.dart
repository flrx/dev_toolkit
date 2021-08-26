import 'dart:convert';
import 'dart:io';

class DevToolkit {
  static late String _ipAddress;
  static WebSocket? _client;

  static Future<void> init(String ipAddress) async {
    DevToolkit._ipAddress = ipAddress;
    await createClient();
  }

  static Future<void> createClient() async {
    try {
      _client = await WebSocket.connect('ws://$_ipAddress:3858');
      _client?.handleError((error) {
        print(error);
      });
    } catch (e) {
      // Do Nothing
    }
  }

  static void sendInfo(String pluginId, Map<String, dynamic> info) async {
    var infoToSend = {
      'path': '/plugins/$pluginId',
      'details': info,
    };

    if (_client == null) {
      await createClient();
    }

    _client?.add(jsonEncode(infoToSend));
  }
}
