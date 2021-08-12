class AppState {
  final int randomState1;
  final int counter;
  final int randomState2;

  AppState(this.counter, this.randomState1, this.randomState2);

  Map<String, dynamic> toJson() {
    return {
      'counter': counter,
      'random': {
        'random_1': randomState1,
        'random_2': randomState2,
      }
    };
  }
}
