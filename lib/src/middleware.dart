import 'dart:convert';

import 'package:dev_toolkit/src/redux_log.dart';
import 'package:redux/redux.dart';

class DevToolKitMiddleware extends MiddlewareClass {
  static List<ReduxLog> logs = [];
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');

  @override
  call(Store<dynamic> store, action, NextDispatcher next) {
    var oldState = encoder.convert(store.state);

    next(action);

    var newState = encoder.convert(store.state);

    var reduxLog = ReduxLog(
      timeOfAction: DateTime.now(),
      action: convertAction(action),
      oldState: oldState,
      newState: newState,
    );
    logs.insert(0, reduxLog);
  }

  ActionDetails convertAction(action) {
    try {
      return ActionDetails(
        type: action.runtimeType.toString(),
        payload: action.toJson(),
      );
    } catch (e) {
      return ActionDetails(
        type: action.toString(),
        payload: {},
      );
    }
  }
}
