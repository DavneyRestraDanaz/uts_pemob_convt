import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan untuk TextInputFormatter

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
      home: const BmiCalculatorScreen(),
    );
  }
}

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  _BmiCalculatorScreenState createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  String _bmiResult = '';
  String _category = '';
  String _advice = '';
  String _foodAdvice = '';
  String _selectedGender = 'Laki-laki';
  bool _isLoading = false;

  void _calculateBMI() async {
    setState(() {
      _isLoading = true;
    });

    final double weight = double.tryParse(_weightController.text.replaceAll(RegExp('[^0-9.]'), '')) ?? 0;
    final double heightCm = double.tryParse(_heightController.text) ?? 0;

    if (weight <= 0 || heightCm <= 0) {
      _showErrorDialog('Silakan isi kolom berat badan dan tinggi badan terlebih dahulu.');
      setState(() {
        _isLoading = false;
      });
    } else {
      final double height = heightCm / 100;
      final double bmi = weight / (height * height);

      String category = '';
      String advice = '';
      String foodAdvice = '';

      if (bmi < 18.5) {
        category = 'Kurus';
        advice = 'Cobalah untuk menambah berat badan dengan pola makan sehat.';
        foodAdvice = 'Konsumsi makanan tinggi kalori seperti alpukat, kacang-kacangan, daging tanpa lemak, dan produk susu tinggi lemak.';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        category = 'Normal';
        advice = 'Anda memiliki berat badan yang sehat. Pertahankan pola hidup sehat.';
        foodAdvice = 'Pastikan pola makan seimbang dengan banyak sayur, buah, protein tanpa lemak, dan karbohidrat kompleks.';
      } else if (bmi >= 25 && bmi < 29.9) {
        category = 'Kelebihan Berat Badan';
        advice = 'Pertimbangkan untuk mengurangi berat badan dengan diet dan olahraga.';
        foodAdvice = 'Kurangi konsumsi makanan tinggi kalori, lemak jenuh, dan gula. Fokus pada makanan rendah kalori seperti sayuran, buah-buahan, dan protein tanpa lemak.';
      } else {
        category = 'Obesitas';
        advice = 'Disarankan untuk berkonsultasi dengan dokter untuk merencanakan program penurunan berat badan.';
        foodAdvice = 'Cobalah untuk mengurangi porsi makan dan pilih makanan rendah kalori. Hindari makanan olahan dan perbanyak konsumsi serat dari sayuran dan buah.';
      }

      setState(() {
        _bmiResult = bmi.toStringAsFixed(2);
        _category = category;
        _advice = advice;
        _foodAdvice = foodAdvice;
        _isLoading = false;
      });

      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hasil BMI'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  children: const [
                    TableRow(
                      children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('BMI Range', style: TextStyle(fontWeight: FontWeight.bold)))),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Underweight'))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('< 18.5'))),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Normal'))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('18.5 - 24.9'))),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Overweight'))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('25 - 29.9'))),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Obese'))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('≥ 30'))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Jenis Kelamin: $_selectedGender', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Hasil BMI: $_bmiResult', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Kategori: $_category', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Saran: $_advice', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Saran Makanan: $_foodAdvice', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  void _appendNumber(String number) {
    if (_weightFocusNode.hasFocus) {
      setState(() {
        _weightController.text += number;
      });
    } else if (_heightFocusNode.hasFocus) {
      setState(() {
        _heightController.text += number;
      });
    }
  }

  void _clearText() {
    if (_weightFocusNode.hasFocus) {
      setState(() {
        _weightController.clear();
      });
    } else if (_heightFocusNode.hasFocus) {
      setState(() {
        _heightController.clear();
      });
    }
  }

  void _backspace() {
    if (_weightFocusNode.hasFocus) {
      setState(() {
        _weightController.text = _weightController.text.isNotEmpty
            ? _weightController.text.substring(0, _weightController.text.length - 1)
            : '';
      });
    } else if (_heightFocusNode.hasFocus) {
      setState(() {
        _heightController.text = _heightController.text.isNotEmpty
            ? _heightController.text.substring(0, _heightController.text.length - 1)
            : '';
      });
    }
  }

  Widget _buildButton(String buttonValue) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BMI'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jenis Kelamin:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Laki-laki',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                        const Text('Laki-laki'),
                        Radio<String>(
                          value: 'Perempuan',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                        const Text('Perempuan'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _weightController,
                      readOnly: true,
                      focusNode: _weightFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Berat Badan (kg)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      style: const TextStyle(fontSize: 22),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _heightController,
                      readOnly: true,
                      focusNode: _heightFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Tinggi Badan (cm)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      style: const TextStyle(fontSize: 22),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculateBMI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Hitung BMI',
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
                        return _buildButton(buttonValues[index]);
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
