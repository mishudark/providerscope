A replacement for scopedModel

A set of utilities that allow you to easily pass a data Model from a parent Widget down to it's descendants by a given `scope`.
If you know how to use scoped model, this library follows the same concept
solving the problem of `access to multiple models using the same provider`

This library was originally extracted from the Fuchsia codebase.

## Usage

```dart
void main() => runApp(MyApp());

// Start by creating a class that holds some view the app's state. In
// our example, we'll have a simple counter that starts at 0 can be
// incremented.
//
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
      // Use the Provide again in order to use the increment
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
```
