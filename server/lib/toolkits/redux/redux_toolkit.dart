import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:server/plugins/redux_inspector_plugin.dart';
import 'package:server/toolkits/redux/redux_log_viewer.dart';

class ReduxToolkit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReduxLog>>(
        stream: ReduxInspectorPlugin.logsStream,
        initialData: ReduxInspectorPlugin.logs,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.requireData.length,
            itemBuilder: (context, index) {
              var log = snapshot.requireData[index];
              return ListTile(
                title: Text(log.action.type),
                subtitle: Text(log.timeOfAction.toIso8601String()),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReduxLogViewer(log: log);
                  }));
                },
              );
            },
          );
        });
  }
}
