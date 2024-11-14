import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      home: const CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'IDR';
  String _result = '';
  bool _isLoading = false;

  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'IDR': 15000.0,
    'EUR': 0.85,
    'JPY': 110.0,
  };

  final Map<String, String> currencySymbols = {
    'USD': '\$',
    'IDR': 'Rp',
    'EUR': '€',
    'JPY': '¥',
  };

  void _convertCurrency() {
    final double amount = double.tryParse(_amountController.text) ?? 0;

    if (amount > 0) {
      setState(() {
        _isLoading = true;
      });

      final double rateFrom = exchangeRates[_fromCurrency] ?? 1.0;
      final double rateTo = exchangeRates[_toCurrency] ?? 1.0;
      final double resultAmount = (amount / rateFrom) * rateTo;

      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: currencySymbols[_toCurrency],
        decimalDigits: 2,
      );

      setState(() {
        _result = formatter.format(resultAmount);
        _isLoading = false;
      });
    } else {
      setState(() {
        _result = 'Invalid input';
      });
    }
  }

  void _onButtonPressed(String value) {
    if (value == 'C') {
      _amountController.clear();
    } else {
      setState(() {
        _amountController.text += value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Mata Uang'),
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
                  'Hasil Konversi: $_result',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCurrencyDropdown(_fromCurrency, (newValue) {
                      setState(() {
                        _fromCurrency = newValue!;
                      });
                    }),
                    const Icon(Icons.arrow_forward, color: Colors.black),
                    _buildCurrencyDropdown(_toCurrency, (newValue) {
                      setState(() {
                        _toCurrency = newValue!;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _amountController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _convertCurrency,
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
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final buttonValues = [
                      '7', '8', '9', 'C',
                      '4', '5', '6', '.',
                      '1', '2', '3', '0'
                    ];
                    return _buildButton(buttonValues[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
          _onButtonPressed(text);
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

  Widget _buildCurrencyDropdown(String currentValue, ValueChanged<String?> onChanged) {
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
        items: ['USD', 'IDR', 'EUR', 'JPY']
            .map((currency) => DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                ))
            .toList(),
      ),
    );
  }
}
