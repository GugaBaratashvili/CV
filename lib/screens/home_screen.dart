import 'package:flutter/material.dart';
import '../widgets/cv_form.dart';
import '../widgets/family_cv_form.dart';

/// Bright lime green background (matches reference UI).
const Color _kScaffoldGreen = Color(0xFF8BC34A);

/// Light cream / pale yellow form container.
const Color _kFormContainerCream = Color(0xFFFFFDE7);

/// Dark color similar to logo background (for tab text).
const Color _kLogoBackgroundDark = Color(0xFF212121);

/// Dark purple / indigo for headings (matches form section labels).
const Color _kHeadingPurple = Color(0xFF3949AB);

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
                  backgroundColor: _kScaffoldGreen,
                  foregroundColor: _kLogoBackgroundDark,
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
            unselectedLabelColor: _kLogoBackgroundDark.withValues(alpha: 0.7),
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
                        style: TextStyle(
                          fontSize: 10,
                          color: _kLogoBackgroundDark.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Contact MILGP Tbilisi for technical issues.',
                        style: TextStyle(
                          fontSize: 10,
                          color: _kLogoBackgroundDark.withValues(alpha: 0.85),
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
