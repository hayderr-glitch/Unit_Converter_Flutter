import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Unit Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _units = [
    'Meters',
    'Kilometers',
    'Miles',
    'Yards',
    'Feet',
    'Inches',
  ];
  final Map<String, double> _conversionFactors = {
    'Meters': 1.0,
    'Kilometers': 1000.0,
    'Miles': 1609.34,
    'Yards': 0.9144,
    'Feet': 0.3048,
    'Inches': 0.0254,
  };

  double? _inputValue;
  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';
  String _outputValue = '';

  void _convert() {
    if (_inputValue == null) {
      setState(() {
        _outputValue = '';
      });
      return;
    }

    double valueInMeters = _inputValue! * _conversionFactors[_fromUnit]!;
    double result = valueInMeters / _conversionFactors[_toUnit]!;

    setState(() {
      _outputValue = result.toStringAsFixed(4);
    });
  }

  Widget _buildUnitDropdown(
    void Function(String?) onChanged,
    String currentValue,
  ) {
    return DropdownButton<String>(
      value: currentValue,
      items: _units.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  _inputValue = double.tryParse(value);
                  _convert();
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter value to convert',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildUnitDropdown((newUnit) {
                  setState(() {
                    _fromUnit = newUnit!;
                    _convert();
                  });
                }, _fromUnit),
                const Icon(Icons.swap_horiz, size: 40),
                _buildUnitDropdown((newUnit) {
                  setState(() {
                    _toUnit = newUnit!;
                    _convert();
                  });
                }, _toUnit),
              ],
            ),
            const SizedBox(height: 40.0),
            if (_outputValue.isNotEmpty)
              Center(
                child: Text(
                  '$_outputValue $_toUnit',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
