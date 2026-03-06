import 'package:flutter/material.dart';
import '../widgets/cv_form.dart';
import '../widgets/family_cv_form.dart';

/// Main background color.
const Color _kScaffoldGreen = Color(0xFF4CBB17);

/// Slate: light panel (off-white / very light gray).
const Color _kFormContainerCream = Color(0xFFF5F8F6);

/// Dark text for contrast – tab text, footer, body text.
const Color _kLogoBackgroundDark = Color(0xFF2D3129);

/// Dark text for section headings.
const Color _kHeadingPurple = Color(0xFF2D3129);

/// Slate: Medium Vibrant Green – primary buttons.
const Color _kAccentGreen = Color(0xFF4DBE55);

/// Shows the welcome / user agreement dialog (app color scheme).
void _showWelcomeDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: _kFormContainerCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _kHeadingPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This application is for official use only in accordance with applicable policies. '
              'By continuing, you acknowledge that you are authorized to use this system and that any information you submit is only for offiicial purposes. '
              'Please ensure that all data you provide is accurate and complete.',
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: _kLogoBackgroundDark,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: _kAccentGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Home screen with two tabs: Student CV and Spouse CV.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showWelcomeDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: _kScaffoldGreen,
        appBar: AppBar(
          backgroundColor: _kScaffoldGreen,
          elevation: 0,
          toolbarHeight: 116,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Image.asset(
                'assets/images/IMET.png',
                height: 88,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 64),
              ),
            ),
          ),
          bottom: TabBar(
            labelColor: _kLogoBackgroundDark,
            unselectedLabelColor: _kLogoBackgroundDark.withValues(alpha: 0.85),
            indicatorColor: _kLogoBackgroundDark,
            tabs: const [
              Tab(text: 'Student CV'),
              Tab(text: 'Spouse CV'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  color: _kFormContainerCream,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: TabBarView(children: [CvForm(), FamilyCvForm()]),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '© Created by Guga Baratashvili',
                        style: const TextStyle(
                          fontSize: 10,
                          color: _kLogoBackgroundDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Contact MILGP Tbilisi for technical issues.',
                        style: TextStyle(
                          fontSize: 10,
                          color: _kLogoBackgroundDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
