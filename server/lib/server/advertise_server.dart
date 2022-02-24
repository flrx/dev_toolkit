import 'dart:async' show Timer;
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

class AdvertiseService {
  // this service writes on a MultiCast Address
  String targetIP;
  int targetPort;
  String multicastMessage;
  FoundPeerCallBack onPeerFound;
  late RawDatagramSocket rawDatagramSocket;
  late Timer timer;

  String title;

  Process? process;

  AdvertiseService({
    required this.targetIP,
    required this.targetPort,
    required this.multicastMessage,
    required this.onPeerFound,
    required this.title,
  });

  Future<void> advertise() async {
    /// Maybe?
    if (kIsWeb) {
      return advertiseUsingRawDatagram();
    }

    if (Platform.isMacOS) {
      return advertiseUsingProcess();
    }

    return advertiseUsingRawDatagram();
  }

  void advertiseUsingProcess() async {
    process = await Process.start('dns-sd', [
      '-R',
      title,
      multicastMessage,
      'local',
      targetPort.toString(),
    ]);
    process!.stdout.listen((stdin) {
      print(String.fromCharCodes(stdin));
    });
  }

  Future<void> advertiseUsingRawDatagram() async {
    var socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    rawDatagramSocket = socket;
    socket.readEventsEnabled = true;
    socket.writeEventsEnabled = true;
    socket.broadcastEnabled = true;
    socket.listen(onSocketEvent);

    timer = Timer.periodic(
      Duration(seconds: 1),
      onTimerEvent,
    );
    Future.delayed(Duration(minutes: 1)).then((value) => stopService());
  }

  void onSocketEvent(RawSocketEvent event) {
    if (event != RawSocketEvent.read) {
      return;
    }

    Datagram? datagram = rawDatagramSocket.receive();

    if (datagram == null) {
      return;
    }

    onPeerFound(datagram.address.address, datagram.port);
  }

  stopService() async {
    timer.cancel();
    rawDatagramSocket.close();
    process?.kill();
  }

  void onTimerEvent(Timer timer) {
    if (!timer.isActive) {
      return;
    }

    var address = InternetAddress(targetIP);

    /// sends data to multicast address
    rawDatagramSocket.send(multicastMessage.codeUnits, address, targetPort);
  }
}

typedef FoundPeerCallBack = Function(String host, int port);
