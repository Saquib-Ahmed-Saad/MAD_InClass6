import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rocket Launch Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  static const int _minValue = 0;
  static const int _maxValue = 100;

  int _counter = 0;
  bool _liftoffDialogShown = false;

  Color _statusColor() {
    if (_counter == 0) return Colors.red;
    if (_counter <= 50) return Colors.orange;
    return Colors.green;
  }

  void _setCounter(int value) {
    final int clamped = value.clamp(_minValue, _maxValue);
    final bool reachedLiftoffNow = _counter < _maxValue && clamped == _maxValue;

    setState(() {
      _counter = clamped;
      if (_counter < _maxValue) {
        _liftoffDialogShown = false;
      }
    });

    if (reachedLiftoffNow && !_liftoffDialogShown) {
      _showLiftoffDialog();
    }
  }

  void _showLiftoffDialog() {
    _liftoffDialogShown = true;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('🚀 Launch Successful!'),
          content: const Text('LIFTOFF achieved at fuel level 100.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLiftoff = _counter == _maxValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              color: Colors.blue.shade50,
              child: Text(
                isLiftoff ? 'LIFTOFF!' : '$_counter',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: isLiftoff ? Colors.green : _statusColor(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Slider(
              min: _minValue.toDouble(),
              max: _maxValue.toDouble(),
              value: _counter.toDouble(),
              onChanged: (double value) => _setCounter(value.toInt()),
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setCounter(_counter + 1),
                    child: const Text('Ignite'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setCounter(_counter - 1),
                    child: const Text('Decrement'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _setCounter(0),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}