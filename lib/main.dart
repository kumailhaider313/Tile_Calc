import 'package:flutter/material.dart';
import 'screens/tile_calculator_screen.dart';

void main() {
  runApp(const TileCalcApp());
}

class TileCalcApp extends StatefulWidget {
  const TileCalcApp({super.key});

  @override
  State<TileCalcApp> createState() => _TileCalcAppState();
}

class _TileCalcAppState extends State<TileCalcApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryEmerald = Color(0xFF16A34A);
    const emeraldAccent = Color(0xFF22C55E);

    return MaterialApp(
      title: 'TileCalc Pro - Smart Tile & Box Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryEmerald,
          brightness: Brightness.light,
          primary: primaryEmerald,
          secondary: emeraldAccent,
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryEmerald,
          brightness: Brightness.dark,
          primary: emeraldAccent,
          secondary: primaryEmerald,
          surface: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF020617),
        cardTheme: CardThemeData(
          color: const Color(0xFF0F172A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
        ),
      ),
      home: TileCalculatorScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
