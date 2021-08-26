import 'dart:convert';

import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:dev_toolkit/src/toolkits/redux/redux_log.dart';
import 'package:redux/redux.dart';

class DevToolKitMiddleware extends MiddlewareClass {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');

  @override
  call(Store<dynamic> store, action, NextDispatcher next) {
    var oldState = store.state;

    next(action);

    var newState = store.state;

    DevToolkit.sendInfo('redux-inspector', {
      "timeOfAction": DateTime.now().toIso8601String(),
      "action": convertAction(action),
      "oldState": oldState,
      "newState": newState,
    });
  }

  ActionDetails convertAction(action) {
    try {
      return ActionDetails(
        type: action.runtimeType.toString(),
        payload: action.toJson(),
      );
    } catch (e) {
      return ActionDetails(
        type: action.runtimeType.toString(),
        payload: {'asString': action.toString()},
      );
    }
  }
}
