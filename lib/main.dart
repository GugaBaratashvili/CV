import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Entry point of the CV app.
void main() {
  runApp(const CvApp());
}

/// Root widget that sets up theming and the home screen.
class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student CV',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4DBE55)),
        scaffoldBackgroundColor: const Color(0xFF4CBB17),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2D3129)),
          bodyMedium: TextStyle(color: Color(0xFF2D3129)),
          bodySmall: TextStyle(color: Color(0xFF2D3129)),
          titleLarge: TextStyle(color: Color(0xFF2D3129)),
          titleMedium: TextStyle(color: Color(0xFF2D3129)),
          titleSmall: TextStyle(color: Color(0xFF2D3129)),
          labelLarge: TextStyle(color: Color(0xFF2D3129)),
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
          labelStyle: const TextStyle(color: Color(0xFF4A5F6F)),
          hintStyle: const TextStyle(color: Color(0xFF4A5F6F)),
          floatingLabelStyle: const TextStyle(color: Color(0xFF2D3129)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

