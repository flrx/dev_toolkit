import 'dart:io';

import 'package:dev_toolkit/src/toolkits/network/network_toolkit_client.dart';

class NetworkToolkitHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    return NetworkToolkitClient(client);
  }
}
