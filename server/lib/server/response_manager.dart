import 'dart:convert';
import 'dart:io';

import 'package:server/plugins/network_plugin.dart';
import 'package:server/plugins/plugin.dart';
import 'package:server/plugins/redux_inspector_plugin.dart';

class ResponseManager {
  List<Plugin> plugins = [
    ReduxInspectorPlugin(),
    NetworkPlugin(),
  ];

  void onRequest(WebSocket socket) {
    socket.map((event) => jsonDecode(event)).listen((json) async {
      if (json['path'].toString().startsWith('/plugins')) {
        await sendRequestToPlugin(socket, json);
      }
    });
  }

  Future<void> sendRequestToPlugin(
    WebSocket socket,
    Map<String, dynamic> event,
  ) async {
    String path = event['path'];
    var pluginName = path.substring(path.lastIndexOf('/')).substring(1);

    var plugin = plugins.cast<Plugin?>().firstWhere(
          (element) => element?.name == pluginName,
          orElse: () => null,
        );

    if (plugin == null) {
      socket.addError("Plugin not found");
      return;
    }
    try {
      var response = await plugin.handleBody(event);
      socket.add(jsonEncode(response));
    } catch (e) {
      socket.addError(e.toString());
    }
  }
}
