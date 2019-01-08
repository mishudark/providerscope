import 'package:flutter/material.dart';
import 'package:providerscope/providerscope.dart';

void main() => runApp(MyApp());

// Note: It must extend from Model.
class CounterModel extends Model {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    // First, increment the counter
    _counter++;

    // Then notify all the listeners.
    notifyListeners();
  }
}

// Register the CounterModel into the provider.
// If no [scope] is passed in, the default one will be used.
const ProviderScope scope1 = ProviderScope('scope1');
Providers providers = Providers()..provideValue(CounterModel(), scope: scope1);

// Create our App, which will provide the `CounterModel` to
// all children that require it!
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // ProviderNode will provide all the children the `CounterModel`
      home: ProviderNode(
        providers: providers,
        child: CounterApp(),
      ),
    );
  }
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // First, create a `ScopedModel` widget. This will provide
    // the `model` to the children that request it.
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times:'),
            // Create a Provide. This widget will get the
            // CounterModel from the nearest ProviderScope<CounterModel>.
            // It will hand that model to our builder method, and rebuild
            // any time the CounterModel changes (i.e. after we
            // `notifyListeners` in the Model).
            Provide<CounterModel>(
              scope: scope1,
              builder:
                  (BuildContext context, Widget child, CounterModel model) {
                return Text(
                  '${model.counter}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
      // Use the ScopedModelDescendant again in order to use the increment
      // method from the CounterModel
      floatingActionButton: Provide<CounterModel>(
        scope: scope1,
        builder: (BuildContext context, Widget child, CounterModel model) {
          return FloatingActionButton(
            onPressed: model.increment,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
