import 'screens/bmi_calculator.dart';
import 'screens/calculator_screen.dart';
import 'screens/currency_converter.dart';
import 'screens/length_converter.dart';
import 'screens/profile_screen.dart';
import 'screens/time_converter_screen.dart';
import 'screens/temperature_converter.dart';
import 'screens/volume_converter.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Multi-Fitur',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/menu': (context) => const MenuScreen(),
        '/calculator': (context) => const CalculatorScreen(),
        '/currency_conversion': (context) => const CurrencyConverterScreen(),
        '/length_conversion': (context) => const LengthConverterScreen(),
        '/temperature_conversion': (context) => const TemperatureConverterScreen(),
        '/time_conversion': (context) => const TimeConverterScreen(),
        '/bmi_calculator': (context) => const BmiCalculatorScreen(),
        '/volume_conversion': (context) => const VolumeConverterScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;

  const PlaceholderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title akan segera hadir!', style: const TextStyle(fontSize: 18))),
    );
  }
}
