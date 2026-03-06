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

/// Shows the welcome / user agreement dialog (theme-aware).
void _showWelcomeDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final surface = theme.colorScheme.surface;
      final onSurface = theme.colorScheme.onSurface;
      final primary = theme.colorScheme.primary;
      final onPrimary = theme.colorScheme.onPrimary;
      return Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This application is for official use only in accordance with applicable policies. '
                'By continuing, you acknowledge that you are authorized to use this system and that any information you submit is only for offiicial purposes. '
                'Please ensure that all data you provide is accurate and complete.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
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
      );
    },
  );
}

/// Home screen with two tabs: Student CV and Spouse CV.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;

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
    final theme = Theme.of(context);
    final scaffoldBg = theme.brightness == Brightness.dark
        ? theme.scaffoldBackgroundColor
        : _kScaffoldGreen;
    final formContainerColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surface
        : _kFormContainerCream;
    final tabColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.onSurface
        : _kLogoBackgroundDark;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: scaffoldBg,
          elevation: 0,
          toolbarHeight: 116,
          leading: IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: tabColor,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: widget.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
          ),
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
            labelColor: tabColor,
            unselectedLabelColor: tabColor.withValues(alpha: 0.85),
            indicatorColor: tabColor,
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
                  color: formContainerColor,
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
                          color: tabColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Contact MILGP Tbilisi for technical issues.',
                        style: TextStyle(
                          fontSize: 10,
                          color: tabColor,
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
