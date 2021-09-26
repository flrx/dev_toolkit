import 'dart:async';

import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:server/plugins/plugin.dart';

class ReduxInspectorPlugin extends Plugin {
  static List<ReduxLog> logs = [];
  static StreamController<List<ReduxLog>> _controller =
      StreamController.broadcast();
  static Stream<List<ReduxLog>> logsStream = _controller.stream;

  @override
  String get name => 'redux-inspector';

  @override
  Future<Map<String, dynamic>> handleBody(
    Map<String, dynamic> requestBody,
  ) async {
    var details = requestBody['details'];
    var log = ReduxLog(
      timeOfAction: DateTime.parse(details['timeOfAction']),
      action: ActionDetails(
        payload: details['action']['payload'],
        type: details['action']['type'],
        meta: details['action']['meta'],
        error: details['action']['error'],
      ),
      oldState: details['oldState'],
      newState: details['newState'],
    );
    logs.insert(0, log);
    _controller.add(logs);
    return {'status': 'Success'};
  }
}
