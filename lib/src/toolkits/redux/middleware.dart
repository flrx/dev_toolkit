import 'dart:convert';

import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:dev_toolkit/src/toolkits/redux/redux_log.dart';
import 'package:redux/redux.dart';

class DevToolKitMiddleware extends MiddlewareClass {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');

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
      Map<String, dynamic> actionDetails = action.toJson();
      String type = action.runtimeType.toString();

      if (actionDetails.containsKey('type')) {
        type = actionDetails['type'];
      }

      return ActionDetails(
        type: type,
        payload: attemptJsonConversion(actionDetails['payload']),
        meta: attemptJsonConversion(actionDetails['meta']),
        error: attemptJsonConversion(actionDetails['error']),
      );
    } catch (e) {
      return ActionDetails(
        type: action.runtimeType.toString(),
        payload: {'asString': action.toString()},
        meta: null,
        error: null,
      );
    }
  }

  dynamic attemptJsonConversion(entity) {
    try {
      if (entity == null) {
        return Map<String, dynamic>();
      }

      if (entity is Iterable) {
        return entity.map((e) => attemptJsonConversion(e));
      }

      return jsonDecode(jsonEncode(entity));
    } catch (e) {
      return {
        'data': entity.toString(),
      };
    }
  }
}
