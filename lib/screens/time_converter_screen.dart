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
      home: const TimeConverterScreen(),
    );
  }
}

class TimeConverterScreen extends StatefulWidget {
  const TimeConverterScreen({super.key});

  @override
  _TimeConverterScreenState createState() => _TimeConverterScreenState();
}

class _TimeConverterScreenState extends State<TimeConverterScreen> {
  final TextEditingController _timeController = TextEditingController();
  String _fromUnit = 'Seconds';
  String _toUnit = 'Minutes';
  String _result = '';
  bool _isLoading = false;

  void _convertTime() {
    final double time = double.tryParse(_timeController.text) ?? 0;

    if (time != 0) {
      setState(() {
        _isLoading = true;
      });

      double resultTime = time;
      String resultUnit = '';

      if (_fromUnit == 'Seconds') {
        if (_toUnit == 'Minutes') {
          resultTime = time / 60;
          resultUnit = 'minutes';
        } else if (_toUnit == 'Hours') {
          resultTime = time / 3600;
          resultUnit = 'hours';
        }
      } else if (_fromUnit == 'Minutes') {
        if (_toUnit == 'Seconds') {
          resultTime = time * 60;
          resultUnit = 'seconds';
        } else if (_toUnit == 'Hours') {
          resultTime = time / 60;
          resultUnit = 'hours';
        }
      } else if (_fromUnit == 'Hours') {
        if (_toUnit == 'Seconds') {
          resultTime = time * 3600;
          resultUnit = 'seconds';
        } else if (_toUnit == 'Minutes') {
          resultTime = time * 60;
          resultUnit = 'minutes';
        }
      }

      setState(() {
        if (resultTime == resultTime.toInt()) {
          _result = '${resultTime.toInt()} $resultUnit';
        } else {
          _result = '${resultTime.toStringAsFixed(3)} $resultUnit';
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _result = 'Invalid input';
      });
    }
  }

  void _updateTime(String value) {
    setState(() {
      _timeController.text = _timeController.text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ukur Waktu'),
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
                'Hasil Konversi Waktu: $_result',
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
                controller: _timeController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Time',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 22),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _convertTime,
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
        items: ['Seconds', 'Minutes', 'Hours']
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
              _timeController.clear();
            });
          } else {
            _updateTime(text);
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
