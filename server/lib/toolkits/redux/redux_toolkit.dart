import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:server/plugins/redux_inspector_plugin.dart';
import 'package:server/toolkits/redux/redux_log_viewer.dart';

class ReduxToolkit extends StatefulWidget {
  @override
  State<ReduxToolkit> createState() => _ReduxToolkitState();
}

class _ReduxToolkitState extends State<ReduxToolkit> {
  ReduxLog? selectedLog;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: TitleBar(
        title: Text(selectedLog?.action.type ?? 'Redux Inspector'),
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return StreamBuilder<List<ReduxLog>>(
                stream: ReduxInspectorPlugin.logsStream,
                initialData: ReduxInspectorPlugin.logs,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.requireData.length,
                    itemBuilder: (context, index) {
                      ReduxLog log = snapshot.requireData[index];
                      return Card(
                        child: ListTile(
                          title: Text(log.action.type),
                          subtitle: Text(log.timeOfAction.toIso8601String()),
                          onTap: () => setState(() => selectedLog = log),
                        ),
                      );
                    },
                  );
                });
          },
        ),
        if (selectedLog != null)
          ResizablePane(
            resizableSide: ResizableSide.left,
            builder: (context, scrollController) {
              if (selectedLog == null) return Container();
              return ReduxLogViewer(log: selectedLog!);
            },
            isResizable: true,
            maxWidth: 800,
            startWidth: 400,
            minWidth: 400,
          )
      ],
    );
  }
}
