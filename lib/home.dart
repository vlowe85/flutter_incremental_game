import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_incremental/providers/counter.dart';

class HomePage extends StatelessWidget{
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo Home Page"),
      ),
      body: const Center(child: CounterLabel()),
      floatingActionButton: const IncrementCounterButton(),
    );
  }
}


class CounterLabel extends StatelessWidget {
  const CounterLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return AnimatedAlign(
      curve: Curves.easeInOut,
      alignment: counter.showClickerOptions ? Alignment.topCenter : Alignment.center,
      duration: Duration(seconds: 1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.count}',
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.display1,
            ),
            counter.showClickerOptions ? AdditionalClickerOptions() : Container(),
          ],
        ),
      ),
    );
  }
}


class AdditionalClickerOptions extends StatelessWidget {
  const AdditionalClickerOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AutoClicker(),
        AutoClickMultiplier(),
      ],
    );
  }
}


class AutoClicker extends StatelessWidget {
  const AutoClicker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: Text(counter.autoClickers.toString(), style: TextStyle(fontSize: 12),),
          ),
          label: Text('Auto clickers'),
        ),
        OutlineButton(
          onPressed: counter.canAffordAnAutoClicker ? () => counter.buyAutoClicker() : null,
          child: Text(
              'Buy for ${counter.autoClickerCost} clicks',
              style: TextStyle(fontSize: 20)
          ),
        ),
        OutlineButton(
          onPressed: counter.autoClickers > 0 ? () => counter.sellAutoClicker() : null,
          child: Text(
              'Sell',
              style: TextStyle(fontSize: 20)
          ),
        ),
      ],
    );
  }
}

class AutoClickMultiplier extends StatelessWidget {
  const AutoClickMultiplier({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: Text("${counter.autoClickMultiplier.toString()}x", style: TextStyle(fontSize: 12),),
          ),
          label: Text('Click multiplier'),
        ),
        OutlineButton(
          onPressed: counter.canAffordAnAutoClickMultiplier ? () => counter.buyAutoClickMultiplier() : null,
          child: Text(
              'Buy for ${counter.autoClickerMultiplierCost} clicks',
              style: TextStyle(fontSize: 20)
          ),
        ),
        OutlineButton(
          onPressed: counter.autoClickMultiplier > 1 ? () => counter.sellAutoClickMultiplier() : null,
          child: Text(
              'Sell',
              style: TextStyle(fontSize: 20)
          ),
        ),
      ],
    );
  }
}


class IncrementCounterButton extends StatelessWidget {
  const IncrementCounterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Provider.of<Counter>(context, listen: false).increment();
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}



