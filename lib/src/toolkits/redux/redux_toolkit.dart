import 'package:dev_toolkit/src/middleware.dart';
import 'package:dev_toolkit/src/toolkits/redux/redux_log_viewer.dart';
import 'package:flutter/material.dart';

class ReduxToolkit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: DevToolKitMiddleware.logs.length,
        itemBuilder: (context, index) {
          var log = DevToolKitMiddleware.logs[index];
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
      ),
    );
  }
}
