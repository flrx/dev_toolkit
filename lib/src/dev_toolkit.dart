import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dev_toolkit/src/discovery_service.dart';

class DevToolkit {
  static WebSocket? _client;
  static const _defaultPingInterval = Duration(seconds: 5);
  static late DiscoveryService _discoveryService;
  static late Timer timer;

  static Future<void> init({
    String? ipAddress,
    Duration pingInterval = _defaultPingInterval,
  }) async {
    if (ipAddress != null) {
      await createClient(ipAddress);
    }

    startToolkitDiscovery(pingInterval);
  }

  static Future<void> createClient(String _ipAddress) async {
    try {
      print('Connecting to $_ipAddress');
      _client = await WebSocket.connect('ws://$_ipAddress:3858');
      _client?.handleError((error) {
        print(error);
      });
    } catch (e) {
      // Do Nothing
      print(e);
    }
  }

  static Future<void> startToolkitDiscovery(Duration pingInterval) async {
    var serviceName = '_dev-toolkit._tcp';
    _discoveryService = DiscoveryService(
      serviceName: serviceName,
      onServiceFound: (String ipAddress, int port) {
        var ip = InternetAddress(ipAddress);
        if (ip.type == InternetAddressType.IPv6) {
          print(
            'IPV6 Cannot connect to websocket right now, Skipping ${ip.address}',
          );
          return;
        }

        createClient(ipAddress);
      },
    );

    timer = Timer.periodic(pingInterval, (timer) async {
      if (!timer.isActive) {
        return;
      }

      _discoveryService.performLookup();
    });
  }

  static void sendInfo(String pluginId, Map<String, dynamic> info) async {
    var infoToSend = {
      'path': '/plugins/$pluginId',
      'details': info,
    };

    if (_client == null) {
      return;
    }

    _client?.add(jsonEncode(infoToSend));
  }

  static void stop() {
    timer.cancel();
    _client?.close();
    _discoveryService.cancel();
  }
}
