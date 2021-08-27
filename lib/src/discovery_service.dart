import 'package:multicast_dns/multicast_dns.dart';

class DiscoveryService {
  final MDnsClient _mdnsClient = MDnsClient();
  final String serviceName;
  final ServiceFoundCallback onServiceFound;

  DiscoveryService({required this.serviceName, required this.onServiceFound}) {
    _mdnsClient.start();
  }

  void performLookup() async {
    var ptrQuery = ResourceRecordQuery.serverPointer(serviceName);
    var ptrRecordStream = _mdnsClient.lookup<PtrResourceRecord>(ptrQuery);
    await ptrRecordStream.forEach(onPtrFound);
  }

  Future<void> onPtrFound(PtrResourceRecord ptr) async {
    var srvQuery = ResourceRecordQuery.service(ptr.domainName);
    var serviceRecordStream = _mdnsClient.lookup<SrvResourceRecord>(srvQuery);
    await serviceRecordStream.forEach(onSrvFound);
  }

  Future<void> onSrvFound(SrvResourceRecord srv) async {
    var ipv4Query = ResourceRecordQuery.addressIPv4(srv.target);
    var ipv4RecordStream =
        _mdnsClient.lookup<IPAddressResourceRecord>(ipv4Query);
    await ipv4RecordStream.forEach((ip) => onIpFound(srv, ip));

    var ipv6Query = ResourceRecordQuery.addressIPv6(srv.target);
    var ipv6RecordStream =
        _mdnsClient.lookup<IPAddressResourceRecord>(ipv6Query);
    await ipv6RecordStream.forEach((ip) async => await onIpFound(srv, ip));
  }

  Future<void> onIpFound(
    SrvResourceRecord srv,
    IPAddressResourceRecord ipRecord,
  ) async {
    var ip = ipRecord.address;
    print(
      'Service instance found at ${srv.target}:${srv.port} with $ip.',
    );

    onServiceFound(ip.address, srv.port);
  }

  void cancel() => _mdnsClient.stop();
}

typedef ServiceFoundCallback = void Function(String ipAddress, int port);
