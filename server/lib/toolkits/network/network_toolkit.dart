import 'package:flutter/material.dart';
import 'package:server/plugins/network_plugin.dart';
import 'package:server/toolkits/network/network_log_viewer.dart';
import 'package:server/toolkits/network/request_info.dart';

class NetworkToolkit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, RequestInfo>>(
      stream: NetworkPlugin.logsStream,
      initialData: NetworkPlugin.requestLogs,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.requireData.length,
          itemBuilder: (context, index) {
            var log =
                snapshot.requireData.entries.toList().reversed.elementAt(index);
            var uri = Uri.parse(log.value.uri);
            return buildLogCard(log, uri, context);
          },
        );
      },
    );
  }

  Card buildLogCard(
    MapEntry<String, RequestInfo> log,
    Uri uri,
    BuildContext context,
  ) {
    return Card(
      key: Key(log.key),
      child: ListTile(
        leading: Text(log.value.method),
        title: Text(uri.path),
        subtitle: Row(
          children: [
            Expanded(child: Text(uri.host)),
            Text(
              DateTime.now()
                      .difference(log.value.timeStamp)
                      .inMinutes
                      .toString() +
                  ' Minutes ago',
            )
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NetworkLogViewer(requestId: log.key);
          }));
        },
      ),
    );
  }
}
