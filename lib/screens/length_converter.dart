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
      home: const LengthConverterScreen(),
    );
  }
}

class LengthConverterScreen extends StatefulWidget {
  const LengthConverterScreen({super.key});

  @override
  _LengthConverterScreenState createState() => _LengthConverterScreenState();
}

class _LengthConverterScreenState extends State<LengthConverterScreen> {
  final TextEditingController _lengthController = TextEditingController();
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  String _result = '';
  bool _isLoading = false;

  void _convertLength() {
    final int length = int.tryParse(_lengthController.text) ?? 0;

    if (length > 0) {
      setState(() {
        _isLoading = true;
      });

      double resultLength = length.toDouble();
      String resultUnit = '';

      if (_fromUnit == 'Meter') {
        if (_toUnit == 'Kilometer') {
          resultLength = length / 1000;
          resultUnit = 'km';
        } else if (_toUnit == 'Centimeter') {
          resultLength = length * 100;
          resultUnit = 'cm';
        } else if (_toUnit == 'Millimeter') {
          resultLength = length * 1000;
          resultUnit = 'mm';
        } else if (_toUnit == 'Inch') {
          resultLength = length * 39.3701;
          resultUnit = 'in';
        } else if (_toUnit == 'Foot') {
          resultLength = length * 3.28084;
          resultUnit = 'ft';
        } else if (_toUnit == 'Yard') {
          resultLength = length * 1.09361;
          resultUnit = 'yd';
        } else if (_toUnit == 'Mile') {
          resultLength = length / 1609.34;
          resultUnit = 'mi';
        } else if (_toUnit == 'Nautical Mile') {
          resultLength = length / 1852;
          resultUnit = 'nmi';
        } else if (_toUnit == 'Mil') {
          resultLength = length * 39370.1;
          resultUnit = 'mil';
        }
      } else if (_fromUnit == 'Kilometer') {
        if (_toUnit == 'Meter') {
          resultLength = length * 1000;
          resultUnit = 'm';
        } else if (_toUnit == 'Centimeter') {
          resultLength = length * 100000;
          resultUnit = 'cm';
        } else if (_toUnit == 'Millimeter') {
          resultLength = length * 1000000;
          resultUnit = 'mm';
        } else if (_toUnit == 'Inch') {
          resultLength = length * 39370.1;
          resultUnit = 'in';
        } else if (_toUnit == 'Foot') {
          resultLength = length * 3280.84;
          resultUnit = 'ft';
        } else if (_toUnit == 'Yard') {
          resultLength = length * 1093.61;
          resultUnit = 'yd';
        } else if (_toUnit == 'Mile') {
          resultLength = length / 1.60934;
          resultUnit = 'mi';
        } else if (_toUnit == 'Nautical Mile') {
          resultLength = length / 1.852;
          resultUnit = 'nmi';
        } else if (_toUnit == 'Mil') {
          resultLength = length * 393701;
          resultUnit = 'mil';
        }
      }

      setState(() {
        if (resultLength == resultLength.toInt()) {
          _result = '${resultLength.toInt()} $resultUnit';
        } else {
          _result = '${resultLength.toStringAsFixed(3)} $resultUnit';
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _result = 'Invalid input';
      });
    }
  }

  void _updateLength(String value) {
    setState(() {
      _lengthController.text = _lengthController.text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ukur Panjang'),
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
                'Hasil Konversi Panjang: $_result',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLengthDropdown(_fromUnit, (newValue) {
                    setState(() {
                      _fromUnit = newValue!;
                    });
                  }),
                  const Icon(Icons.arrow_forward, color: Colors.black),
                  _buildLengthDropdown(_toUnit, (newValue) {
                    setState(() {
                      _toUnit = newValue!;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _lengthController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Length',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 22),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertLength,
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

  Widget _buildLengthDropdown(String currentValue, ValueChanged<String?> onChanged) {
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
        items: ['Meter', 'Kilometer', 'Centimeter', 'Millimeter', 'Inch', 'Foot', 'Yard', 'Mile', 'Nautical Mile', 'Mil']
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
              _lengthController.clear();
            });
          } else {
            _updateLength(text);
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