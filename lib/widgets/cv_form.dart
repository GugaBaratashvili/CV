import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../netlify_submit.dart';

/// Configure these with your real SMTP credentials before using submit.

const String smtpUsername = 'gugabaratashvili@gmail.com';
const String smtpPassword = 'ydvm jrdg wbxl yygi';

/// Email address that will receive generated CVs.
const String targetEmail = 'maia.bolkvadze.ln@mail.mil';

/// One subsection of "Military Service or Civilian experience".
class _ExperienceEntry {
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController startMonthYear = TextEditingController();
  final TextEditingController endMonthYear = TextEditingController();
  final TextEditingController rankAtStart = TextEditingController();
  final TextEditingController rankAtEnd = TextEditingController();

  void dispose() {
    description.dispose();
    location.dispose();
    startMonthYear.dispose();
    endMonthYear.dispose();
    rankAtStart.dispose();
    rankAtEnd.dispose();
  }
}

/// One subsection of "Joint Exercise" (Participated outside student's country).
class _JointExerciseEntry {
  final TextEditingController description = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController startMonthYear = TextEditingController();
  final TextEditingController endMonthYear = TextEditingController();

  void dispose() {
    description.dispose();
    country.dispose();
    city.dispose();
    startMonthYear.dispose();
    endMonthYear.dispose();
  }
}

/// One subsection of "Military Training" (past 10 years outside home country).
class _MilitaryTrainingEntry {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController degreeCertificate = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController startMonthYear = TextEditingController();
  final TextEditingController endMonthYear = TextEditingController();

  void dispose() {
    title.dispose();
    description.dispose();
    degreeCertificate.dispose();
    location.dispose();
    startMonthYear.dispose();
    endMonthYear.dispose();
  }
}

/// One subsection of "Military/Civilian Education".
class _MilitaryEducationEntry {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController degreeCertificateDiploma =
      TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController startMonthYear = TextEditingController();
  final TextEditingController endMonthYear = TextEditingController();

  void dispose() {
    title.dispose();
    description.dispose();
    degreeCertificateDiploma.dispose();
    location.dispose();
    startMonthYear.dispose();
    endMonthYear.dispose();
  }
}

/// One subsection of "English language training".
class _LanguageTrainingEntry {
  final TextEditingController location = TextEditingController();
  final TextEditingController startMonthYear = TextEditingController();
  final TextEditingController endMonthYear = TextEditingController();

  void dispose() {
    location.dispose();
    startMonthYear.dispose();
    endMonthYear.dispose();
  }
}

/// One accompanying person within a Personal travel subsection.
class _AccompanyingPersonEntry {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  void dispose() {
    firstName.dispose();
    lastName.dispose();
  }
}

/// One subsection of "Personal travel".
class _PersonalTravelEntry {
  final TextEditingController location = TextEditingController();
  final TextEditingController startMonthYear = TextEditingController();
  final TextEditingController endMonthYear = TextEditingController();
  final List<_AccompanyingPersonEntry> persons = [_AccompanyingPersonEntry()];

  void dispose() {
    location.dispose();
    startMonthYear.dispose();
    endMonthYear.dispose();
    for (final p in persons) {
      p.dispose();
    }
  }
}

/// Family member type for dropdown.
const List<String> _familyMemberTypes = [
  'Mother',
  'Father',
  'Siblings',
  'Spouse',
];

/// One subsection of "Family members".
class _FamilyMemberEntry {
  String? familyMemberType = 'Mother';
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController maidenName = TextEditingController();
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
    fatherName.dispose();
    dob.dispose();
    placeOfBirth.dispose();
    phoneNumber.dispose();
    email.dispose();
    citizenIdNumber.dispose();
  }
}

/// CV form for the main "CV" tab.
///
/// All fields are optional for now so you can iterate on the template.
class CvForm extends StatefulWidget {
  const CvForm({super.key});

  @override
  State<CvForm> createState() => _CvFormState();
}

class _CvFormState extends State<CvForm> {
  final _formKey = GlobalKey<FormState>();

  // Core personal info (from CV template – simplified).
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _citizenIdController = TextEditingController();
  final _militaryServiceIdController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _positionPersonalController = TextEditingController();
  final _rankController = TextEditingController();
  final _militaryServiceFromController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cellPhoneController = TextEditingController();

  /// Military Service or Civilian experience subsections (repeatable).
  final List<_ExperienceEntry> _experienceEntries = [_ExperienceEntry()];

  /// Joint Exercise subsections (repeatable).
  final List<_JointExerciseEntry> _jointExerciseEntries = [
    _JointExerciseEntry(),
  ];

  /// Military Training subsections (repeatable).
  final List<_MilitaryTrainingEntry> _militaryTrainingEntries = [
    _MilitaryTrainingEntry(),
  ];

  /// Military/Civilian Education subsections (repeatable).
  final List<_MilitaryEducationEntry> _militaryEducationEntries = [
    _MilitaryEducationEntry(),
  ];

  /// Language training subsections (repeatable).
  final List<_LanguageTrainingEntry> _languageTrainingEntries = [
    _LanguageTrainingEntry(),
  ];

  /// Personal travel subsections (repeatable); each can have multiple accompanying persons.
  final List<_PersonalTravelEntry> _personalTravelEntries = [
    _PersonalTravelEntry(),
  ];

  /// Family members subsections (repeatable).
  final List<_FamilyMemberEntry> _familyMemberEntries = [_FamilyMemberEntry()];

  bool _submitting = false;

  @override
  void dispose() {
    for (final e in _experienceEntries) {
      e.dispose();
    }
    for (final j in _jointExerciseEntries) {
      j.dispose();
    }
    for (final t in _militaryTrainingEntries) {
      t.dispose();
    }
    for (final e in _militaryEducationEntries) {
      e.dispose();
    }
    for (final l in _languageTrainingEntries) {
      l.dispose();
    }
    for (final t in _personalTravelEntries) {
      t.dispose();
    }
    for (final f in _familyMemberEntries) {
      f.dispose();
    }
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _citizenIdController.dispose();
    _militaryServiceIdController.dispose();
    _homeAddressController.dispose();
    _positionPersonalController.dispose();
    _rankController.dispose();
    _militaryServiceFromController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cellPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _submitting = true;
    });

    final lastName = _lastNameController.text.trim();
    final subject =
        'CV${lastName.isNotEmpty ? ' - $lastName' : ''}'; // CV + last name

    try {
      final pdfBytes = await _buildPdf();
      await _sendEmailWithAttachment(
        subject: subject,
        pdfBytes: pdfBytes,
        fileName: 'cv.pdf',
      );

      if (!mounted) return;
      submitNetlifyCvForm('student');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CV PDF sent successfully')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send CV: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  /// Creates a simple A4 CV PDF from the collected form data.
  Future<List<int>> _buildPdf() async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Curriculum Vitae',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Personal Information',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          _pdfField('First name', _firstNameController.text),
          _pdfField('Last name', _lastNameController.text),
          _pdfField('Date of birth', _dobController.text),
          _pdfField('City', _cityController.text),
          _pdfField('Country', _countryController.text),
          _pdfField('Citizen ID number', _citizenIdController.text),
          _pdfField(
            'Military Service ID number',
            _militaryServiceIdController.text,
          ),
          _pdfField('Personal email', _emailController.text),
          _pdfField('Home phone', _phoneController.text),
          _pdfField('Cell phone', _cellPhoneController.text),
          _pdfField('Home address', _homeAddressController.text),
          _pdfField('Position', _positionPersonalController.text),
          _pdfField('Rank', _rankController.text),
          _pdfField(
            'In Military Service from',
            _militaryServiceFromController.text,
          ),
          ..._pdfExperienceSection(),
          ..._pdfJointExerciseSection(),
          ..._pdfMilitaryTrainingSection(),
          ..._pdfMilitaryEducationSection(),
          ..._pdfLanguageTrainingSection(),
          ..._pdfPersonalTravelSection(),
          ..._pdfFamilyMemberSection(),
        ],
      ),
    );

    return doc.save();
  }

  /// Helper to render a label/value pair in the PDF, skipping empty values.
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

  /// PDF widgets for "Military Service or Civilian experience" section.
  List<pw.Widget> _pdfExperienceSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Military Service or Civilian experience',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _experienceEntries.length; i++) {
      final e = _experienceEntries[i];
      final hasAny =
          e.description.text.trim().isNotEmpty ||
          e.location.text.trim().isNotEmpty ||
          e.startMonthYear.text.trim().isNotEmpty ||
          e.endMonthYear.text.trim().isNotEmpty ||
          e.rankAtStart.text.trim().isNotEmpty ||
          e.rankAtEnd.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(
        pw.Text(
          'Experience ${i + 1}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
      list.add(pw.SizedBox(height: 4));
      list.add(
        _pdfField('Military or Civilian position title', e.description.text),
      );
      list.add(_pdfField('Location', e.location.text));
      final startStr = e.startMonthYear.text.trim();
      final endStr = e.endMonthYear.text.trim();
      if (startStr.isNotEmpty || endStr.isNotEmpty) {
        list.add(_pdfField('Years', '$startStr – $endStr'));
      }
      list.add(_pdfField('Rank at start', e.rankAtStart.text));
      list.add(_pdfField('Rank at end', e.rankAtEnd.text));
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  /// PDF widgets for "Joint Exercise" section.
  List<pw.Widget> _pdfJointExerciseSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Joint Exercise',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 2),
      pw.Text(
        'Participated outside student\'s country',
        style: pw.TextStyle(fontSize: 12),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _jointExerciseEntries.length; i++) {
      final j = _jointExerciseEntries[i];
      final hasAny =
          j.description.text.trim().isNotEmpty ||
          j.country.text.trim().isNotEmpty ||
          j.city.text.trim().isNotEmpty ||
          j.startMonthYear.text.trim().isNotEmpty ||
          j.endMonthYear.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(
        pw.Text(
          'Joint Exercise ${i + 1}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
      list.add(pw.SizedBox(height: 4));
      list.add(_pdfField('Joint exercise title', j.description.text));
      list.add(_pdfField('Country', j.country.text));
      list.add(_pdfField('City', j.city.text));
      final startStr = j.startMonthYear.text.trim();
      final endStr = j.endMonthYear.text.trim();
      if (startStr.isNotEmpty || endStr.isNotEmpty) {
        list.add(_pdfField('Years', '$startStr – $endStr'));
      }
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  /// PDF widgets for "Military Training" section.
  List<pw.Widget> _pdfMilitaryTrainingSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Military Training',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 2),
      pw.Text(
        'Participated in the past ten (10) years outside of student\'s home country',
        style: pw.TextStyle(fontSize: 12),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _militaryTrainingEntries.length; i++) {
      final t = _militaryTrainingEntries[i];
      final hasAny =
          t.title.text.trim().isNotEmpty ||
          t.degreeCertificate.text.trim().isNotEmpty ||
          t.location.text.trim().isNotEmpty ||
          t.startMonthYear.text.trim().isNotEmpty ||
          t.endMonthYear.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(
        pw.Text(
          'Training ${i + 1}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
      list.add(pw.SizedBox(height: 4));
      list.add(_pdfField('Title', t.title.text));
      list.add(_pdfField('Degree/Certificate', t.degreeCertificate.text));
      list.add(_pdfField('Location', t.location.text));
      final startStr = t.startMonthYear.text.trim();
      final endStr = t.endMonthYear.text.trim();
      if (startStr.isNotEmpty || endStr.isNotEmpty) {
        list.add(_pdfField('Years', '$startStr – $endStr'));
      }
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  /// PDF widgets for "Military/Civilian Education" section.
  List<pw.Widget> _pdfMilitaryEducationSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Military/Civilian Education',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _militaryEducationEntries.length; i++) {
      final e = _militaryEducationEntries[i];
      final hasAny =
          e.title.text.trim().isNotEmpty ||
          e.degreeCertificateDiploma.text.trim().isNotEmpty ||
          e.location.text.trim().isNotEmpty ||
          e.startMonthYear.text.trim().isNotEmpty ||
          e.endMonthYear.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(
        pw.Text(
          'Education ${i + 1}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
      list.add(pw.SizedBox(height: 4));
      list.add(_pdfField('Training title', e.title.text));
      list.add(
        _pdfField(
          'Degree/Certificate/Diploma',
          e.degreeCertificateDiploma.text,
        ),
      );
      list.add(_pdfField('Location', e.location.text));
      final startStr = e.startMonthYear.text.trim();
      final endStr = e.endMonthYear.text.trim();
      if (startStr.isNotEmpty || endStr.isNotEmpty) {
        list.add(_pdfField('Years', '$startStr – $endStr'));
      }
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  /// PDF widgets for "English language training" section.
  List<pw.Widget> _pdfLanguageTrainingSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'English language training',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _languageTrainingEntries.length; i++) {
      final l = _languageTrainingEntries[i];
      final hasAny =
          l.location.text.trim().isNotEmpty ||
          l.startMonthYear.text.trim().isNotEmpty ||
          l.endMonthYear.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(
        pw.Text(
          'English language training ${i + 1}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
      list.add(pw.SizedBox(height: 4));
      list.add(_pdfField('Location', l.location.text));
      final startStr = l.startMonthYear.text.trim();
      final endStr = l.endMonthYear.text.trim();
      if (startStr.isNotEmpty || endStr.isNotEmpty) {
        list.add(_pdfField('Years', '$startStr – $endStr'));
      }
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  /// PDF widgets for "Personal travel" section.
  List<pw.Widget> _pdfPersonalTravelSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Personal travel',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _personalTravelEntries.length; i++) {
      final t = _personalTravelEntries[i];
      final hasAny =
          t.location.text.trim().isNotEmpty ||
          t.startMonthYear.text.trim().isNotEmpty ||
          t.endMonthYear.text.trim().isNotEmpty ||
          t.persons.any(
            (p) =>
                p.firstName.text.trim().isNotEmpty ||
                p.lastName.text.trim().isNotEmpty,
          );
      if (!hasAny) continue;
      list.add(
        pw.Text(
          'Personal travel ${i + 1}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
      list.add(pw.SizedBox(height: 4));
      list.add(_pdfField('Location', t.location.text));
      final startStr = t.startMonthYear.text.trim();
      final endStr = t.endMonthYear.text.trim();
      if (startStr.isNotEmpty || endStr.isNotEmpty) {
        list.add(_pdfField('Years', '$startStr – $endStr'));
      }
      for (var j = 0; j < t.persons.length; j++) {
        final p = t.persons[j];
        if (p.firstName.text.trim().isEmpty && p.lastName.text.trim().isEmpty) {
          continue;
        }
        list.add(
          _pdfField(
            'Accompanying person ${j + 1}',
            '${p.firstName.text.trim()} ${p.lastName.text.trim()}'.trim(),
          ),
        );
      }
      list.add(pw.SizedBox(height: 8));
    }
    return list;
  }

  /// PDF widgets for "Family members" section.
  List<pw.Widget> _pdfFamilyMemberSection() {
    final list = <pw.Widget>[
      pw.SizedBox(height: 16),
      pw.Text(
        'Family members',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
    ];
    for (var i = 0; i < _familyMemberEntries.length; i++) {
      final f = _familyMemberEntries[i];
      final hasAny =
          f.familyMemberType != null ||
          f.firstName.text.trim().isNotEmpty ||
          f.lastName.text.trim().isNotEmpty ||
          f.maidenName.text.trim().isNotEmpty ||
          f.fatherName.text.trim().isNotEmpty ||
          f.dob.text.trim().isNotEmpty ||
          f.placeOfBirth.text.trim().isNotEmpty ||
          f.phoneNumber.text.trim().isNotEmpty ||
          f.email.text.trim().isNotEmpty ||
          f.citizenIdNumber.text.trim().isNotEmpty;
      if (!hasAny) continue;
      list.add(
        pw.Text(
          'Family member ${i + 1}',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
      list.add(pw.SizedBox(height: 4));
      if (f.familyMemberType != null && f.familyMemberType!.isNotEmpty) {
        list.add(_pdfField('Family member', f.familyMemberType!));
      }
      list.add(_pdfField('First name', f.firstName.text));
      list.add(_pdfField('Last name', f.lastName.text));
      list.add(_pdfField('Maiden Name', f.maidenName.text));
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

  /// Sends the generated PDF as an email attachment.
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
                const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Text(
                  'Student CV',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3129),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Personal information'),
            const SizedBox(height: 8),
            _buildTextField('First name', _firstNameController),
            const SizedBox(height: 12),
            _buildTextField('Last name', _lastNameController),
            const SizedBox(height: 12),
            _buildDateField(context),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('City', _cityController)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Country', _countryController)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField('Citizen ID number', _citizenIdController),
            const SizedBox(height: 12),
            _buildTextField(
              'Military Service ID number',
              _militaryServiceIdController,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Personal email',
              _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Home phone',
              _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Cell phone',
              _cellPhoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Home address',
              _homeAddressController,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Position',
                    _positionPersonalController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Rank', _rankController)),
              ],
            ),
            const SizedBox(height: 12),
            _buildMilitaryServiceFromField(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Military Service or Civilian experience'),
            const SizedBox(height: 8),
            ...List.generate(_experienceEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildExperienceSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () => _experienceEntries.add(_ExperienceEntry()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add experience'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _experienceEntries.length > 1
                        ? () {
                            setState(() {
                              final last = _experienceEntries.removeLast();
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
            _buildSectionTitle('Joint Exercise'),
            const SizedBox(height: 2),
            Text(
              'Participated outside student\'s country',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ...List.generate(_jointExerciseEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildJointExerciseSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () => _jointExerciseEntries.add(_JointExerciseEntry()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Joint Exercise'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _jointExerciseEntries.length > 1
                        ? () {
                            setState(() {
                              final last = _jointExerciseEntries.removeLast();
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
            _buildSectionTitle('Military Training'),
            const SizedBox(height: 2),
            Text(
              'Participated in the past ten (10) years outside of student\'s home country',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ...List.generate(_militaryTrainingEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMilitaryTrainingSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () => _militaryTrainingEntries.add(
                          _MilitaryTrainingEntry(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Training'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _militaryTrainingEntries.length > 1
                        ? () {
                            setState(() {
                              final last = _militaryTrainingEntries
                                  .removeLast();
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
            _buildSectionTitle('Military/Civilian Education'),
            const SizedBox(height: 8),
            ...List.generate(_militaryEducationEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMilitaryEducationSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () => _militaryEducationEntries.add(
                          _MilitaryEducationEntry(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Education'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _militaryEducationEntries.length > 1
                        ? () {
                            setState(() {
                              final last = _militaryEducationEntries
                                  .removeLast();
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
            _buildSectionTitle('English language training'),
            const SizedBox(height: 8),
            ...List.generate(_languageTrainingEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildLanguageTrainingSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () => _languageTrainingEntries.add(
                          _LanguageTrainingEntry(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Training'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _languageTrainingEntries.length > 1
                        ? () {
                            setState(() {
                              final last = _languageTrainingEntries
                                  .removeLast();
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
            _buildSectionTitle('Personal travel'),
            const SizedBox(height: 8),
            ...List.generate(_personalTravelEntries.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPersonalTravelSubsection(context, i),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () =>
                            _personalTravelEntries.add(_PersonalTravelEntry()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Personal travel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _personalTravelEntries.length > 1
                        ? () {
                            setState(() {
                              final last = _personalTravelEntries.removeLast();
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
            _buildSectionTitle('Family members'),
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
                      setState(
                        () => _familyMemberEntries.add(_FamilyMemberEntry()),
                      );
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
        color: Color(0xFF2D3129), // Dark text for contrast
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

  /// Builds a date-of-birth field that shows a date picker dialog.
  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Date of birth',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (v) =>
          _dobController.text.trim().isEmpty ? 'This field is required' : null,
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
          const monthNames = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];

          final day = picked.day.toString().padLeft(2, '0');
          final monthName = monthNames[picked.month - 1];
          final year = picked.year.toString();

          _dobController.text = '$day/$monthName/$year';
        }
      },
    );
  }

  /// Reusable date-of-birth style field (DD/Mon/YYYY) with date picker.
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
      validator: (v) =>
          controller.text.trim().isEmpty ? 'This field is required' : null,
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

  /// Month names for display (month/year only picker).
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Shows a month/year picker dialog; returns (month, year) or null.
  Future<({int month, int year})?> _showMonthYearPicker(
    BuildContext context, {
    required String title,
    String? existingText,
  }) {
    final now = DateTime.now();
    int selectedMonth = now.month;
    int selectedYear = now.year;
    if (existingText != null && existingText.trim().isNotEmpty) {
      final parts = existingText.trim().split(' ');
      if (parts.length == 2) {
        final mi = _monthNames.indexOf(parts[0]);
        if (mi >= 0) selectedMonth = mi + 1;
        final y = int.tryParse(parts[1]);
        if (y != null && y >= 1950 && y <= now.year) selectedYear = y;
      }
    }

    return showDialog<({int month, int year})>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedMonth,
                      decoration: const InputDecoration(labelText: 'Month'),
                      items: List.generate(12, (i) => i + 1).map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text(_monthNames[m - 1]),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedMonth = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedYear,
                      decoration: const InputDecoration(labelText: 'Year'),
                      items: List.generate(now.year - 1950 + 1, (i) {
                        final y = 1950 + i;
                        return DropdownMenuItem(value: y, child: Text('$y'));
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedYear = v);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(
                    ctx,
                  ).pop((month: selectedMonth, year: selectedYear)),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Read-only field that opens month/year picker and sets controller text.
  Widget _buildMonthYearField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Month and year',
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: (v) =>
          controller.text.trim().isEmpty ? 'This field is required' : null,
      onTap: () async {
        final result = await _showMonthYearPicker(
          context,
          title: label,
          existingText: controller.text,
        );
        if (result != null) {
          controller.text = '${_monthNames[result.month - 1]} ${result.year}';
        }
      },
    );
  }

  /// One subsection: Description, Location, Years (start/end), Ranks.
  Widget _buildExperienceSubsection(BuildContext context, int index) {
    final e = _experienceEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Experience ${index + 1}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Military or Civilian position title',
              e.description,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _buildTextField('Location', e.location),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: e.startMonthYear,
                    label: 'Start (month, year)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: e.endMonthYear,
                    label: 'End (month, year)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Rank at start', e.rankAtStart),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Rank at end', e.rankAtEnd)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// One Joint Exercise subsection: Description, Country, City, Years (start/end).
  Widget _buildJointExerciseSubsection(BuildContext context, int index) {
    final j = _jointExerciseEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Joint Exercise ${index + 1}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTextField('Joint exercise title', j.description, maxLines: 2),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('Country', j.country)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('City', j.city)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: j.startMonthYear,
                    label: 'Start (month, year)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: j.endMonthYear,
                    label: 'End (month, year)',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// One Military Training subsection: Title, Description, Degree/Certificate, Location, Years.
  Widget _buildMilitaryTrainingSubsection(BuildContext context, int index) {
    final t = _militaryTrainingEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training ${index + 1}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTextField('Title', t.title),
            const SizedBox(height: 12),
            _buildTextField('Degree/Certificate', t.degreeCertificate),
            const SizedBox(height: 12),
            _buildTextField('Location', t.location),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: t.startMonthYear,
                    label: 'Start (month, year)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: t.endMonthYear,
                    label: 'End (month, year)',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// One Military/Civilian Education subsection: Title, Description, Degree/Certificate/Diploma, Location, Years.
  Widget _buildMilitaryEducationSubsection(BuildContext context, int index) {
    final e = _militaryEducationEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Education ${index + 1}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTextField('Training title', e.title),
            const SizedBox(height: 12),
            _buildTextField(
              'Degree/Certificate/Diploma',
              e.degreeCertificateDiploma,
            ),
            const SizedBox(height: 12),
            _buildTextField('Location', e.location),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: e.startMonthYear,
                    label: 'Start (month, year)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: e.endMonthYear,
                    label: 'End (month, year)',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// One English language training subsection: Location, Years (start/end).
  Widget _buildLanguageTrainingSubsection(BuildContext context, int index) {
    final l = _languageTrainingEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'English language training ${index + 1}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTextField('Location', l.location),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: l.startMonthYear,
                    label: 'Start (month, year)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: l.endMonthYear,
                    label: 'End (month, year)',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// One Personal travel subsection: Location, Years, accompanying persons (repeatable).
  Widget _buildPersonalTravelSubsection(BuildContext context, int index) {
    final t = _personalTravelEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal travel ${index + 1}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildTextField('Location', t.location),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: t.startMonthYear,
                    label: 'Start (month, year)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMonthYearField(
                    context,
                    controller: t.endMonthYear,
                    label: 'End (month, year)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'First Name and Last Name of accompanying person',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...List.generate(t.persons.length, (i) {
              final p = t.persons[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(child: _buildTextField('First Name', p.firstName)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Last Name', p.lastName)),
                  ],
                ),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => t.persons.add(_AccompanyingPersonEntry()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add person'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: t.persons.length > 1
                        ? () {
                            setState(() {
                              final last = t.persons.removeLast();
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
          ],
        ),
      ),
    );
  }

  /// One Family member subsection: type dropdown, name fields, DOB, place, phone, email, citizen ID.
  Widget _buildFamilyMemberSubsection(BuildContext context, int index) {
    final f = _familyMemberEntries[index];
    final needsMaidenName =
        f.familyMemberType == 'Mother' || f.familyMemberType == 'Spouse';
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family member ${index + 1}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: f.familyMemberType,
              decoration: const InputDecoration(labelText: 'Family member'),
              items: _familyMemberTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'This field is required' : null,
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
            _buildTextField('Father name', f.fatherName),
            const SizedBox(height: 12),
            _buildDobStyleDateField(
              context,
              controller: f.dob,
              label: 'Date of Birth',
            ),
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

  /// Builds "In Military Service from" field: month and year only (no day).
  Widget _buildMilitaryServiceFromField(BuildContext context) {
    return TextFormField(
      controller: _militaryServiceFromController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'In Military Service from',
        hintText: 'Month and year',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (v) => _militaryServiceFromController.text.trim().isEmpty
          ? 'This field is required'
          : null,
      onTap: () async {
        final result = await _showMonthYearPicker(
          context,
          title: 'In Military Service from',
          existingText: _militaryServiceFromController.text,
        );
        if (result != null) {
          _militaryServiceFromController.text =
              '${_monthNames[result.month - 1]} ${result.year}';
        }
      },
    );
  }
}
