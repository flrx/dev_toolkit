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
  final Map<String, dynamic> payload;

  ActionDetails({required this.type, required this.payload});
}
