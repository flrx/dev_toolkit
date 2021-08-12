import 'package:dev_toolkit/src/toolkits/network/network_log.dart';
import 'package:dev_toolkit/src/toolkits/network/network_log_viewer.dart';
import 'package:flutter/material.dart';

class NetworkToolkit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Toolkit')),
      body: ListView.builder(
        itemCount: NetworkLogger.instance.requestLogs.length,
        itemBuilder: (context, index) {
          var log = NetworkLogger.instance.requestLogs.entries
              .toList()
              .reversed
              .elementAt(index);
          var uri = Uri.parse(log.value.uri);
          return Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Text(log.value.method),
              title: Text(uri.path),
              subtitle: Row(
                children: [
                  Expanded(child: Text(uri.host)),
                  Text(DateTime.now()
                          .difference(log.value.timeStamp)
                          .inMinutes
                          .toString() +
                      ' Minutes ago')
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NetworkLogViewer(requestId: log.key);
                }));
              },
            ),
          );
        },
      ),
    );
  }
}
