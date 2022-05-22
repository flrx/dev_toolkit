import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:server/plugins/network_plugin.dart';
import 'package:server/toolkits/network/network_log_viewer.dart';
import 'package:server/toolkits/network/request_info.dart';

class NetworkToolkit extends StatefulWidget {
  @override
  State<NetworkToolkit> createState() => _NetworkToolkitState();
}

class _NetworkToolkitState extends State<NetworkToolkit> {
  MapEntry<String, RequestInfo>? selectedLog;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(builder: (context, scrollController) {
          return StreamBuilder<Map<String, RequestInfo>>(
            stream: NetworkPlugin.logsStream,
            initialData: NetworkPlugin.requestLogs,
            builder: (context, snapshot) {
              return Material(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (context, index) {
                    var log = snapshot.requireData.entries
                        .toList()
                        .reversed
                        .elementAt(index);
                    var uri = Uri.parse(log.value.uri);

                    return buildLogCard(log, uri, context);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 1),
                ),
              );
            },
          );
        }),
        if (selectedLog != null)
          ResizablePane(
            resizableSide: ResizableSide.left,
            builder: (context, scrollController) {
              if (selectedLog == null) return Container();
              return NetworkLogViewer(requestId: selectedLog!.key);
            },
            isResizable: true,
            maxWidth: 800,
            startWidth: 400,
            minWidth: 400,
          )
      ],
    );
  }

  Widget buildLogCard(
    MapEntry<String, RequestInfo> log,
    Uri uri,
    BuildContext context,
  ) {
    return ListTile(
      key: Key(log.key),
      leading: Text(log.value.method),
      title: Text(uri.path),
      trailing: Text(
        DateTime.now().difference(log.value.timeStamp).inMinutes.toString() +
            ' Minutes ago',
      ),
      subtitle: Text(uri.host),
      onTap: () => setState(() => selectedLog = log),
    );
  }
}
