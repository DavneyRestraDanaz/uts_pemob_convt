import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayText = '';
  String _operator = '';
  double _firstOperand = 0;
  double _secondOperand = 0;
  String _lastInput = '';
  final List<String> _history = [];

  void _input(String input) {
    setState(() {
      if (input == '+' || input == '-' || input == '*' || input == '/') {
        if (_firstOperand == 0 && _displayText.isNotEmpty) {
          _firstOperand = double.tryParse(_displayText) ?? 0;
          _operator = input;
          _displayText = '';
        } else if (_firstOperand != 0 && _displayText.isNotEmpty) {
          _secondOperand = double.tryParse(_displayText) ?? 0;
          _calculateResult();
          _operator = input;
        }
      } else if (input == '=') {
        _secondOperand = double.tryParse(_displayText) ?? 0;
        _calculateResult();
      } else if (input == 'C') {
        _clear();
      } else {
        _displayText += input;
      }

      _lastInput = input;
    });
  }
  
  void _calculateResult() {
    setState(() {
      double result = 0;
      switch (_operator) {
        case '+':
          result = _firstOperand + _secondOperand;
          break;
        case '-':
          result = _firstOperand - _secondOperand;
          break;
        case '*':
          result = _firstOperand * _secondOperand;
          break;
        case '/':
          if (_secondOperand != 0) {
            result = _firstOperand / _secondOperand;
          } else {
            _displayText = 'Error';
            return;
          }
          break;
      }

      if (result == result.toInt()) {
        _displayText = result.toInt().toString();
      } else {
        _displayText = result.toStringAsFixed(2);
      }

      String historyEntry = '$_firstOperand $_operator $_secondOperand = ${result == result.toInt() ? result.toInt().toString() : result.toStringAsFixed(2)}';
      _history.add(historyEntry);

      _firstOperand = 0;
      _secondOperand = 0;
      _operator = '';
    });
  }

  void _clear() {
    setState(() {
      _displayText = '';
      _firstOperand = 0;
      _secondOperand = 0;
      _operator = '';
      _lastInput = '';
    });
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Riwayat Perhitungan'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_history[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _displayText,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Text(
                    _lastInput,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.orange[50],
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('*'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('C'), _buildButton('0'), _buildButton('='), _buildButton('+'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _input(text),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          height: 70,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
