import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'cv_form.dart' show smtpUsername, smtpPassword, targetEmail;
import '../netlify_submit.dart';

/// Family member type for dropdown (Spouse CV).
const List<String> _spouseFamilyMemberTypes = ['Mother', 'Father', 'Siblings', 'Spouse'];

/// One subsection of "Spouse family members" on the Spouse CV tab.
class _SpouseFamilyMemberEntry {
  String? familyMemberType = 'Mother';
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController maidenName = TextEditingController();
  final TextEditingController formerLastName = TextEditingController();
  final TextEditingController fatherName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController placeOfBirth = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController citizenIdNumber = TextEditingController();

  void dispose() {
    firstName.dispose();
    lastName.dispose();
    maidenName.dispose();
    formerLastName.dispose();
    fatherName.dispose();
    dob.dispose();
    placeOfBirth.dispose();
    phoneNumber.dispose();
    email.dispose();
    citizenIdNumber.dispose();
  }
}

/// One subsection for a child under "Accompanied Spouse and Children".
class _ChildEntry {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController placeOfBirth = TextEditingController();
  final TextEditingController citizenIdNumber = TextEditingController();

  void dispose() {
    firstName.dispose();
    lastName.dispose();
    dob.dispose();
    placeOfBirth.dispose();
    citizenIdNumber.dispose();
  }
}

/// Form for the "Spouse CV" tab.
///
/// All fields are optional and loosely based on a typical
/// accompanying family member CV template.
class FamilyCvForm extends StatefulWidget {
  const FamilyCvForm({super.key});

  @override
  State<FamilyCvForm> createState() => _FamilyCvFormState();
}

class _FamilyCvFormState extends State<FamilyCvForm> {
  final _formKey = GlobalKey<FormState>();

  // Student information (first/last name) and spouse details.
  final _studentFirstNameController = TextEditingController();
  final _studentLastNameController = TextEditingController();
  final _familyMemberFirstNameController = TextEditingController();
  final _familyMemberLastNameController = TextEditingController();
  final _formerLastNameController = TextEditingController();
  final _maidenNameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _citizenIdController = TextEditingController();
  final _homePhoneController = TextEditingController();
  final _cellPhoneController = TextEditingController();
  final _personalEmailController = TextEditingController();
  final _homeAddressController = TextEditingController();

  /// Children subsections (repeatable). Empty until user clicks "Add child".
  final List<_ChildEntry> _childEntries = [];

  /// Spouse family members subsections (repeatable).
  final List<_SpouseFamilyMemberEntry> _familyMemberEntries = [_SpouseFamilyMemberEntry()];

  bool _submitting = false;

  @override
  void dispose() {
    _studentFirstNameController.dispose();
    _studentLastNameController.dispose();
    _familyMemberFirstNameController.dispose();
    _familyMemberLastNameController.dispose();
    _formerLastNameController.dispose();
    _maidenNameController.dispose();
    _placeOfBirthController.dispose();
    _dateOfBirthController.dispose();
    _citizenIdController.dispose();
    _homePhoneController.dispose();
    _cellPhoneController.dispose();
    _personalEmailController.dispose();
    _homeAddressController.dispose();
    for (final c in _childEntries) {
      c.dispose();
    }
    for (final e in _familyMemberEntries) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _submitting = true;
    });

    final studentLastName = _studentLastNameController.text.trim();
    final subject = 'CV of $studentLastName spouse';

    try {
      final pdfBytes = await _buildPdf();
      await _sendEmailWithAttachment(
        subject: subject,
        pdfBytes: pdfBytes,
        fileName: 'family_cv.pdf',
      );

      if (!mounted) return;
      submitNetlifyCvForm('spouse');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Family CV PDF sent successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send Family CV: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  /// Builds a simple A4 PDF for the family member CV.
  Future<List<int>> _buildPdf() async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Accompanying Family Member CV',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Student Information',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          _pdfField('First name', _studentFirstNameController.text),
          _pdfField('Last name', _studentLastNameController.text),
          pw.SizedBox(height: 16),
          pw.Text(
            'Accompanied Spouse and Children',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          _pdfField('First name', _familyMemberFirstNameController.text),
          _pdfField('Last name', _familyMemberLastNameController.text),
          _pdfField('Former last name', _formerLastNameController.text),
          _pdfField('Maiden Name', _maidenNameController.text),
          _pdfField('Place of Birth', _placeOfBirthController.text),
          _pdfField('Date of birth', _dateOfBirthController.text),
          _pdfField('Citizen ID number', _citizenIdController.text),
          _pdfField('Home Phone', _homePhoneController.text),
          _pdfField('Cell phone', _cellPhoneController.text),
          _pdfField('Personal email', _personalEmailController.text),
          _pdfField('Home address', _homeAddressController.text),
          ..._pdfChildrenSection(),
          ..._pdfFamilyMemberSection(),
        ],
      ),
    );

    return doc.save();
  }

  /// PDF widgets for "Children" subsection.
  List<pw.Widget> _pdfChildrenSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Children',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _childEntries.length; i++) {
      final c = _childEntries[i];
      final hasAny = c.firstName.text.trim().isNotEmpty ||
          c.lastName.text.trim().isNotEmpty ||
          c.dob.text.trim().isNotEmpty ||
          c.placeOfBirth.text.trim().isNotEmpty ||
          c.citizenIdNumber.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(pw.Text(
        'Child ${i + 1}',
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ));
      list.add(pw.SizedBox(height: 4));
      list.add(_pdfField('First Name', c.firstName.text));
      list.add(_pdfField('Last Name', c.lastName.text));
      list.add(_pdfField('Date of birth', c.dob.text));
      list.add(_pdfField('Place of birth', c.placeOfBirth.text));
      list.add(_pdfField('Citizen ID number', c.citizenIdNumber.text));
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  /// PDF widgets for "Spouse family members" section.
  List<pw.Widget> _pdfFamilyMemberSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Spouse family members',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _familyMemberEntries.length; i++) {
      final f = _familyMemberEntries[i];
      final hasAny = f.familyMemberType != null ||
          f.firstName.text.trim().isNotEmpty ||
          f.lastName.text.trim().isNotEmpty ||
          f.maidenName.text.trim().isNotEmpty ||
          f.formerLastName.text.trim().isNotEmpty ||
          f.fatherName.text.trim().isNotEmpty ||
          f.dob.text.trim().isNotEmpty ||
          f.placeOfBirth.text.trim().isNotEmpty ||
          f.phoneNumber.text.trim().isNotEmpty ||
          f.email.text.trim().isNotEmpty ||
          f.citizenIdNumber.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(pw.Text(
        'Family member ${i + 1}',
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ));
      list.add(pw.SizedBox(height: 4));
      if (f.familyMemberType != null && f.familyMemberType!.isNotEmpty) {
        list.add(_pdfField('Family member', f.familyMemberType!));
      }
      list.add(_pdfField('First name', f.firstName.text));
      list.add(_pdfField('Last name', f.lastName.text));
      list.add(_pdfField('Maiden Name', f.maidenName.text));
      list.add(_pdfField('Former last name', f.formerLastName.text));
      list.add(_pdfField('Father name', f.fatherName.text));
      list.add(_pdfField('Date of Birth', f.dob.text));
      list.add(_pdfField('Place of Birth', f.placeOfBirth.text));
      list.add(_pdfField('Phone number', f.phoneNumber.text));
      list.add(_pdfField('Email', f.email.text));
      list.add(_pdfField('Citizen ID Number', f.citizenIdNumber.text));
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  pw.Widget _pdfField(String label, String value) {
    if (value.trim().isEmpty) {
      return pw.SizedBox.shrink();
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  Future<void> _sendEmailWithAttachment({
    required String subject,
    required List<int> pdfBytes,
    required String fileName,
  }) async {
    if (smtpUsername == 'your-smtp-username@example.com' ||
        smtpPassword == 'your-smtp-password-or-app-password') {
      throw Exception(
        'Please configure smtpUsername and smtpPassword in cv_form.dart before sending emails.',
      );
    }

    final smtpServer = gmail(smtpUsername, smtpPassword);

    final message = Message()
      ..from = Address(smtpUsername, 'CV App')
      ..recipients.add(targetEmail)
      ..subject = subject
      ..attachments = [
        StreamAttachment(
          Stream<List<int>>.fromIterable(<List<int>>[pdfBytes]),
          'application/pdf',
          fileName: fileName,
        ),
      ];

    await send(message, smtpServer);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.family_restroom),
                ),
                const SizedBox(width: 12),
                Text(
                  'Spouse CV',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3949AB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Student Information'),
            const SizedBox(height: 8),
            _buildTextField('First name', _studentFirstNameController),
            const SizedBox(height: 12),
            _buildTextField('Last name', _studentLastNameController),
            const SizedBox(height: 24),
            _buildSectionTitle('Accompanied Spouse and Children'),
            const SizedBox(height: 8),
            _buildTextField('First name', _familyMemberFirstNameController),
            const SizedBox(height: 12),
            _buildTextField('Last name', _familyMemberLastNameController),
            const SizedBox(height: 12),
            _buildTextField('Former last name', _formerLastNameController),
            const SizedBox(height: 12),
            _buildTextField('Maiden Name', _maidenNameController),
            const SizedBox(height: 12),
            _buildTextField('Place of Birth', _placeOfBirthController),
            const SizedBox(height: 12),
            _buildDobField(context),
            const SizedBox(height: 12),
            _buildTextField('Citizen ID number', _citizenIdController),
            const SizedBox(height: 12),
            _buildTextField('Home Phone', _homePhoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildTextField('Cell phone', _cellPhoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildTextField('Personal email', _personalEmailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _buildTextField('Home address', _homeAddressController, maxLines: 3),
            const SizedBox(height: 24),
            _buildSectionTitle('Children'),
            const SizedBox(height: 8),
            ...List.generate(_childEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildChildSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _childEntries.add(_ChildEntry()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add child'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _childEntries.isNotEmpty
                        ? () {
                            setState(() {
                              final last = _childEntries.removeLast();
                              last.dispose();
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                    label: const Text('Remove'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Spouse family members'),
            const SizedBox(height: 8),
            ...List.generate(_familyMemberEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildFamilyMemberSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _familyMemberEntries.add(_SpouseFamilyMemberEntry()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Family member'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _familyMemberEntries.length > 1
                        ? () {
                            setState(() {
                              final last = _familyMemberEntries.removeLast();
                              last.dispose();
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                    label: const Text('Remove'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitting ? null : _handleSubmit,
                icon: _submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(_submitting ? 'Sending...' : 'Submit & Send PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3949AB), // Dark purple / indigo section labels
      ),
    );
  }

  static String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: validator ?? _requiredValidator,
    );
  }

  /// Reusable date-of-birth field (DD/Mon/YYYY) with date picker for family member entries.
  Widget _buildDobStyleDateField(
    BuildContext context, {
    required TextEditingController controller,
    String label = 'Date of Birth',
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: (v) => controller.text.trim().isEmpty ? 'This field is required' : null,
      onTap: () async {
        final now = DateTime.now();
        final initialDate = DateTime(now.year - 18, now.month, now.day);
        final firstDate = DateTime(1900);
        final lastDate = now;

        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (picked != null) {
          final day = picked.day.toString().padLeft(2, '0');
          final monthName = _monthNames[picked.month - 1];
          final year = picked.year.toString();
          controller.text = '$day/$monthName/$year';
        }
      },
    );
  }

  Widget _buildFamilyMemberSubsection(BuildContext context, int index) {
    final f = _familyMemberEntries[index];
    final needsMaidenName = f.familyMemberType == 'Mother' || f.familyMemberType == 'Spouse';
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family member ${index + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: f.familyMemberType,
              decoration: const InputDecoration(
                labelText: 'Family member',
              ),
              items: _spouseFamilyMemberTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              validator: (v) => (v == null || v.isEmpty) ? 'This field is required' : null,
              onChanged: (v) {
                setState(() => f.familyMemberType = v);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('First name', f.firstName)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Last name', f.lastName)),
              ],
            ),
            const SizedBox(height: 12),
            if (needsMaidenName) ...[
              _buildTextField('Maiden Name', f.maidenName),
              const SizedBox(height: 12),
            ],
            _buildTextField('Former last name', f.formerLastName),
            const SizedBox(height: 12),
            _buildTextField('Father name', f.fatherName),
            const SizedBox(height: 12),
            _buildDobStyleDateField(context, controller: f.dob, label: 'Date of Birth'),
            const SizedBox(height: 12),
            _buildTextField('Place of Birth', f.placeOfBirth),
            const SizedBox(height: 12),
            _buildTextField(
              'Phone number',
              f.phoneNumber,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Email',
              f.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField('Citizen ID Number', f.citizenIdNumber),
          ],
        ),
      ),
    );
  }

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  Widget _buildDobField(BuildContext context) {
    return TextFormField(
      controller: _dateOfBirthController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Date of birth',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (v) => _dateOfBirthController.text.trim().isEmpty ? 'This field is required' : null,
      onTap: () async {
        final now = DateTime.now();
        final initialDate = DateTime(now.year - 18, now.month, now.day);
        final firstDate = DateTime(1900);
        final lastDate = now;

        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (picked != null) {
          final day = picked.day.toString().padLeft(2, '0');
          final monthName = _monthNames[picked.month - 1];
          final year = picked.year.toString();
          _dateOfBirthController.text = '$day/$monthName/$year';
        }
      },
    );
  }

  Widget _buildChildSubsection(BuildContext context, int index) {
    final c = _childEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Child ${index + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('First Name', c.firstName)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Last Name', c.lastName)),
              ],
            ),
            const SizedBox(height: 12),
            _buildDobStyleDateField(context, controller: c.dob, label: 'Date of birth'),
            const SizedBox(height: 12),
            _buildTextField('Place of birth', c.placeOfBirth),
            const SizedBox(height: 12),
            _buildTextField('Citizen ID number', c.citizenIdNumber),
          ],
        ),
      ),
    );
  }
}
