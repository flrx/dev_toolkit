import 'dart:io';
import 'dart:math';

import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:dio/dio.dart';
import 'package:example/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// One simple action: Increment
class IncrementAction {}

var rand = Random();
late Dio dio;

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
AppState counterReducer(AppState state, dynamic action) {
  if (action is IncrementAction) {
    var id = state.counter + 1;
    dio.get('https://jsonplaceholder.typicode.com/todos/$id');

    return AppState(
      id,
      rand.nextBool() ? state.randomState1 : rand.nextInt(50),
      rand.nextBool() ? state.randomState2 : rand.nextInt(100),
    );
  }

  return state;
}

void main() async {
  // Create your store as a final variable in the main function or inside a
  // State object. This works better with Hot Reload than creating it directly
  // in the `build` function.

  await DevToolkit.init();
  HttpOverrides.global = NetworkToolkitHttpOverrides();
  dio = Dio();
  final store = Store<AppState>(
    counterReducer,
    initialState: AppState(0, 0, 0),
    middleware: [
      DevToolKitMiddleware(),
    ],
  );

  runApp(FlutterReduxApp(
    title: 'Flutter Redux Demo',
    store: store,
  ));
}

class FlutterReduxApp extends StatelessWidget {
  final Store<AppState> store;
  final String title;

  FlutterReduxApp({
    Key? key,
    required this.store,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return StoreProvider<AppState>(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      store: store,
      child: MaterialApp(
        theme: ThemeData(),
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Connect the Store to a Text Widget that renders the current
                // count.
                //
                // We'll wrap the Text Widget in a `StoreConnector` Widget. The
                // `StoreConnector` will find the `Store` from the nearest
                // `StoreProvider` ancestor, convert it into a String of the
                // latest count, and pass that String  to the `builder` function
                // as the `count`.
                //
                // Every time the button is tapped, an action is dispatched and
                // run through the reducer. After the reducer updates the state,
                // the Widget will be automatically rebuilt with the latest
                // count. No need to manually manage subscriptions or Streams!
                StoreConnector<AppState, String>(
                  converter: (store) => store.state.counter.toString(),
                  builder: (context, count) {
                    return Text(
                      'The button has been pushed this many times: $count',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                )
              ],
            ),
          ),
          // Connect the Store to a FloatingActionButton. In this case, we'll
          // use the Store to build a callback that will dispatch an Increment
          // Action.
          //
          // Then, we'll pass this callback to the button's `onPressed` handler.
          floatingActionButton: StoreConnector<AppState, VoidCallback>(
            converter: (store) {
              // Return a `VoidCallback`, which is a fancy name for a function
              // with no parameters and no return value.
              // It only dispatches an Increment action.
              return () => store.dispatch(IncrementAction());
            },
            builder: (context, callback) {
              return FloatingActionButton(
                // Attach the `callback` to the `onPressed` attribute
                onPressed: callback,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}
