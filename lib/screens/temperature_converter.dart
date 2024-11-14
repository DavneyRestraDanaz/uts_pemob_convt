import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  _TemperatureConverterScreenState createState() => _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  final TextEditingController _tempController = TextEditingController();
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';
  String _result = '';
  bool _isLoading = false;

  void _convertTemperature() {
    final double temperature = double.tryParse(_tempController.text) ?? 0;

    if (temperature != 0) {
      setState(() {
        _isLoading = true;
      });

      double resultTemp = temperature;
      String resultUnit = '';

      if (_fromUnit == 'Celsius') {
        if (_toUnit == 'Fahrenheit') {
          resultTemp = (temperature * 9 / 5) + 32;
          resultUnit = '°F';
        } else if (_toUnit == 'Kelvin') {
          resultTemp = temperature + 273.15;
          resultUnit = 'K';
        }
      } else if (_fromUnit == 'Fahrenheit') {
        if (_toUnit == 'Celsius') {
          resultTemp = (temperature - 32) * 5 / 9;
          resultUnit = '°C';
        } else if (_toUnit == 'Kelvin') {
          resultTemp = (temperature - 32) * 5 / 9 + 273.15;
          resultUnit = 'K';
        }
      } else if (_fromUnit == 'Kelvin') {
        if (_toUnit == 'Celsius') {
          resultTemp = temperature - 273.15;
          resultUnit = '°C';
        } else if (_toUnit == 'Fahrenheit') {
          resultTemp = (temperature - 273.15) * 9 / 5 + 32;
          resultUnit = '°F';
        }
      }

      setState(() {
        if (resultTemp == resultTemp.toInt()) {
          _result = '${resultTemp.toInt()} $resultUnit';
        } else {
          _result = '${resultTemp.toStringAsFixed(3)} $resultUnit';
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _result = 'Invalid input';
      });
    }
  }

  void _updateTemp(String value) {
    setState(() {
      _tempController.text = _tempController.text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suhu Temperatur'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hasil Konversi Temperatur: $_result',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUnitDropdown(_fromUnit, (newValue) {
                    setState(() {
                      _fromUnit = newValue!;
                    });
                  }),
                  const Icon(Icons.arrow_forward, color: Colors.black),
                  _buildUnitDropdown(_toUnit, (newValue) {
                    setState(() {
                      _toUnit = newValue!;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _tempController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Temperature',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 22),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _convertTemperature,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Convert',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),

              _buildNumberPad(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(String currentValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white70,
      ),
      child: DropdownButton<String>(
        value: currentValue,
        onChanged: onChanged,
        dropdownColor: Colors.orange[200],
        style: const TextStyle(color: Colors.black, fontSize: 18),
        items: ['Celsius', 'Fahrenheit', 'Kelvin']
            .map((unit) => DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildNumberPad() {
    final List<String> buttonValues = [
      '7', '8', '9', 'C',
      '4', '5', '6', '.',
      '1', '2', '3', '0'
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.68,
      ),
      itemCount: buttonValues.length,
      itemBuilder: (context, index) {
        final buttonValue = buttonValues[index];
        return _buildButton(buttonValue);
      },
    );
  }

  Widget _buildButton(String text, {bool isWide = false}) {
    return Container(
      width: isWide ? double.infinity : 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (text == 'C') {
            setState(() {
              _tempController.clear();
            });
          } else {
            _updateTemp(text);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.all(0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
