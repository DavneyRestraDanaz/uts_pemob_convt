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
      home: const VolumeConverterScreen(),
    );
  }
}

class VolumeConverterScreen extends StatefulWidget {
  const VolumeConverterScreen({super.key});

  @override
  _VolumeConverterScreenState createState() => _VolumeConverterScreenState();
}

class _VolumeConverterScreenState extends State<VolumeConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromUnit = 'Liter';
  String _toUnit = 'Milliliter';
  String _result = '';
  bool _isLoading = false;

  double _convertVolume(double amount, String fromUnit, String toUnit) {
    final Map<String, double> conversionFactors = {
      'Liter': 1.0,
      'Milliliter': 1000.0,
      'Galon AS': 0.264172,
      'Galon Inggris': 0.219969,
      'Sentimeter Kubik': 1000.0,
      'Meter Kubik': 0.001,
      'Inci Kubik': 61.0237,
      'Kaki Kubik': 0.0353147,
    };

    double inLiter = amount / conversionFactors[fromUnit]!;
    return inLiter * conversionFactors[toUnit]!;
  }

  void _convertVolumeAmount() {
    final double amount = double.tryParse(_amountController.text) ?? 0;

    if (amount > 0) {
      setState(() {
        _isLoading = true;
      });

      final double convertedAmount =
          _convertVolume(amount, _fromUnit, _toUnit);

      setState(() {
        _result = convertedAmount.toStringAsFixed(2);
        _isLoading = false;
      });
    } else {
      setState(() {
        _result = 'Input tidak valid';
      });
    }
  }

  void _appendNumber(String number) {
    setState(() {
      _amountController.text += number;
    });
  }

  void _clearText() {
    setState(() {
      _amountController.clear();
    });
  }

  void _backspace() {
    setState(() {
      _amountController.text = _amountController.text.isNotEmpty
          ? _amountController.text.substring(0, _amountController.text.length - 1)
          : '';
    });
  }

  Widget _buildVolumeButton(String buttonValue) {
    return ElevatedButton(
      onPressed: () {
        if (buttonValue == 'C') {
          _clearText();
        } else if (buttonValue == '.') {
          _appendNumber('.');
        } else {
          _appendNumber(buttonValue);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        buttonValue,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  Widget _buildUnitDropdown(String currentValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white70,
      ),
      child: DropdownButton<String>(
        value: currentValue,
        onChanged: onChanged,
        dropdownColor: Colors.orange[200],
        style: const TextStyle(color: Colors.black, fontSize: 18),
        items: [
          'Liter', 'Milliliter', 'Galon AS', 'Galon Inggris', 
          'Sentimeter Kubik', 'Meter Kubik', 'Inci Kubik', 'Kaki Kubik'
        ]
            .map((unit) => DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ukur Volume'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Hasil Konversi: $_result $_toUnit',
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
                  controller: _amountController,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Volume',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _convertVolumeAmount,
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
                          'Konversi',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final buttonValues = [
                      '7', '8', '9', 'C',
                      '4', '5', '6', '.',
                      '1', '2', '3', '0'
                    ];
                    return _buildVolumeButton(buttonValues[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
