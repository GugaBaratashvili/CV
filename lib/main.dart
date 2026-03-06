import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Near-black for maximum contrast (typed text, labels) – especially for mobile Safari.
const Color _kHighContrastText = Color(0xFF1A1C19);

/// Entry point of the CV app.
void main() {
  runApp(const CvApp());
}

/// Root widget that sets up theming and the home screen.
class CvApp extends StatefulWidget {
  const CvApp({super.key});

  @override
  State<CvApp> createState() => _CvAppState();
}

class _CvAppState extends State<CvApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student CV',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF4DBE55),
        onPrimary: Colors.white,
        surface: const Color(0xFFF5F8F6),
        onSurface: _kHighContrastText,
        surfaceContainerHighest: const Color(0xFFF5F8F6),
      ),
      scaffoldBackgroundColor: const Color(0xFF4CBB17),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: _kHighContrastText, fontSize: 16),
        bodyMedium: TextStyle(color: _kHighContrastText, fontSize: 16),
        bodySmall: TextStyle(color: _kHighContrastText, fontSize: 14),
        titleLarge: TextStyle(color: _kHighContrastText, fontSize: 22),
        titleMedium: TextStyle(color: _kHighContrastText, fontSize: 16),
        titleSmall: TextStyle(color: _kHighContrastText, fontSize: 14),
        labelLarge: TextStyle(color: _kHighContrastText, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFBEBEBE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4DBE55), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Color(0xFF3D4F5C), fontSize: 16),
        hintStyle: const TextStyle(color: Color(0xFF3D4F5C), fontSize: 16),
        floatingLabelStyle: TextStyle(color: _kHighContrastText, fontSize: 16),
        // Force dark typed text for mobile Safari contrast
        alignLabelWithHint: true,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    const Color darkSurface = Color(0xFF1E2320);
    const Color darkBg = Color(0xFF2D3329);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF6BC96B),
        onPrimary: const Color(0xFF1A1C19),
        surface: darkSurface,
        onSurface: const Color(0xFFE8EBE8),
        surfaceContainerHighest: const Color(0xFF2A2F2A),
      ),
      scaffoldBackgroundColor: darkBg,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFE8EBE8), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFFE8EBE8), fontSize: 16),
        bodySmall: TextStyle(color: Color(0xFFE8EBE8), fontSize: 14),
        titleLarge: TextStyle(color: Color(0xFFE8EBE8), fontSize: 22),
        titleMedium: TextStyle(color: Color(0xFFE8EBE8), fontSize: 16),
        titleSmall: TextStyle(color: Color(0xFFE8EBE8), fontSize: 14),
        labelLarge: TextStyle(color: Color(0xFFE8EBE8), fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2F2A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5A6158)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6BC96B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE57373)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Color(0xFFB0B8B0), fontSize: 16),
        hintStyle: const TextStyle(color: Color(0xFFB0B8B0), fontSize: 16),
        floatingLabelStyle: const TextStyle(color: Color(0xFFE8EBE8), fontSize: 16),
      ),
    );
  }
}

