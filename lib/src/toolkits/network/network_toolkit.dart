import 'package:dev_toolkit/src/toolkits/network/network_log.dart';
import 'package:dev_toolkit/src/toolkits/network/network_log_viewer.dart';
import 'package:flutter/material.dart';

class NetworkToolkit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: NetworkLogger.instance.requestLogs.length,
        itemBuilder: (context, index) {
          var log = NetworkLogger.instance.requestLogs.entries.elementAt(index);
          return ListTile(
            leading: Text(log.value.method),
            title: Text(log.value.uri),
            subtitle: Text(log.value.timeStamp.toIso8601String()),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NetworkLogViewer(requestId: log.key);
              }));
            },
          );
        },
      ),
    );
  }
}
