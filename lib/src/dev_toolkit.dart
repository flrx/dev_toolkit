import 'dart:convert';
import 'dart:io';
import 'package:multicast_dns/multicast_dns.dart';

class DevToolkit {
  static WebSocket? _client;
  static final MDnsClient _mdnsClient = MDnsClient();

  static Future<void> init() async {
    const String name = '_dev-toolkit._tcp';

    // Start the client with default options.
    await DevToolkit._mdnsClient.start();
    var ptrQuery = ResourceRecordQuery.serverPointer(name);
    var ptrRecordStream =
        DevToolkit._mdnsClient.lookup<PtrResourceRecord>(ptrQuery);
    await ptrRecordStream.forEach(DevToolkit.onPtrFound);
    DevToolkit._mdnsClient.stop();
  }

  static Future<void> createClient(String _ipAddress) async {
    try {
      print('Connecting to $_ipAddress');
      _client = await WebSocket.connect('ws://$_ipAddress:3858');
      _client?.handleError((error) {
        print(error);
      });
    } catch (e) {
      print(e);
      // Do Nothing
    }
  }

  static Future<void> onPtrFound(PtrResourceRecord ptr) async {
    var srvQuery = ResourceRecordQuery.service(ptr.domainName);
    var serviceRecordStream = _mdnsClient.lookup<SrvResourceRecord>(srvQuery);
    await serviceRecordStream.forEach(onSrvFound);
  }

  static Future<void> onSrvFound(SrvResourceRecord srv) async {
    var ipv4Query = ResourceRecordQuery.addressIPv4(srv.target);
    var ipv4RecordStream =
        _mdnsClient.lookup<IPAddressResourceRecord>(ipv4Query);
    await ipv4RecordStream.forEach((ip) => onIpFound(srv, ip));

    var ipv6Query = ResourceRecordQuery.addressIPv6(srv.target);
    var ipv6RecordStream =
        _mdnsClient.lookup<IPAddressResourceRecord>(ipv6Query);
    await ipv6RecordStream.forEach((ip) async => await onIpFound(srv, ip));
  }

  static Future<void> onIpFound(
    SrvResourceRecord srv,
    IPAddressResourceRecord ipRecord,
  ) async {
    var ip = ipRecord.address;
    print(
      'Service instance found at ${srv.target}:${srv.port} with $ip.',
    );

    if (ip.type == InternetAddressType.IPv6) {
      print(
          'IPV6 Cannot connect to websocket right now, Skipping ${ip.address}');
      return;
    }
    if (_client == null) {
      await createClient(ip.address);
    }
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
}
