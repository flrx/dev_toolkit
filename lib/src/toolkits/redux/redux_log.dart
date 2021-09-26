class ReduxLog {
  final DateTime timeOfAction;
  final ActionDetails action;
  final dynamic oldState;
  final dynamic newState;

  ReduxLog({
    required this.timeOfAction,
    required this.action,
    required this.oldState,
    required this.newState,
  });
}

class ActionDetails {
  final String type;
  final dynamic payload;
  final dynamic error;
  final dynamic meta;

  ActionDetails({
    required this.type,
    required this.payload,
    required this.error,
    required this.meta,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': payload,
        'meta': meta,
        'error': error,
      };
}
