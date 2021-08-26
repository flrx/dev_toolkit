import 'package:flutter/material.dart';
import 'package:server/app.dart';
import 'package:server/server/server_manager.dart';

void main() async {
  await ServerManager.init();
  runApp(ServerApp());
}
