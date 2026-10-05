import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const JanataAwaazApp());
}

class JanataAwaazApp extends StatefulWidget {
  const JanataAwaazApp({super.key});

  @override
  State<JanataAwaazApp> createState() => _JanataAwaazAppState();
}

class _JanataAwaazAppState extends State<JanataAwaazApp> {
  String _currentLang = 'en';

  void _changeLanguage(String langCode) {
    setState(() {
      _currentLang = langCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Janata Awaaz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF9933),
        scaffoldBackgroundColor: const Color(0xFFF9FBF9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9933),
          secondary: const Color(0xFF138808),
        ),
        fontFamily: 'sans-serif',
      ),
      home: HomeScreen(
        currentLang: _currentLang,
        onLangChanged: _changeLanguage,
      ),
    );
  }
}

class AppStrings {
  static final Map<String, Map<String, String>> _values = {
    'en': {
      'app_title': 'Janata Awaaz',
      'disclaimer': 'Disclaimer: Independent citizen platform. Official contacts sourced from open government portals (india.gov.in). Not an official government entity.',
      'btn_report': 'Report Local Issue & Evidence',
      'btn_petition': 'National Citizen Petitions & Voting',
      'lang_label': 'Language',
      'select_lang': 'Select Your Language',
      'anonymous_title': 'Keep Identity Completely Anonymous',
      'anonymous_sub': 'Your name and contact will never be shared publicly or with authorities.',
      'issue_title': 'Issue Title',
      'issue_desc': 'Detailed Description of the Issue',
      'location_hint': 'Location / Address',
      'before_evidence': 'Live Evidence (Before)',
      'after_evidence': 'Gallery (After)',
      'attach_files': 'Attach Audio / PDF Documents',
      'remove': 'Remove',
      'submit_btn': 'Submit Official Report',
      'success_msg': 'Report recorded successfully in the system!',
      'petition_badge': 'National Citizen Petition',
      'petition_title': 'Demand Timely and Transparent Inquiries in Serious Cases',
      'total_votes': 'Total Citizen Support:',
      'vote_btn': 'Support this Petition (Vote)',
      'voted_msg': 'Support recorded successfully!',
    },
    'gu': {
      'app_title': 'જનતા અવાજ',
      'disclaimer': 'અસ્વીકરણ: આ એપ સ્વતંત્ર નાગરિક મંચ છે. સરકારી સંપર્કો india.gov.in પરથી મેળવેલા છે. કોઈ કાનૂની સરકારી સંસ્થાનું પ્રતિનિધિત્વ કરતું નથી.',
      'btn_report': 'સ્થાનિક સમસ્યા / પુરાવા નોંધો',
      'btn_petition': 'રાષ્ટ્રીય જન પિટિશન અને વોટિંગ',
      'lang_label': 'ભાષા',
      'select_lang': 'તમારી ભાષા પસંદ કરો',
      'anonymous_title': 'ઓળખ સંપૂર્ણ ગુપ્ત રાખો (Anonymous)',
      'anonymous_sub': 'તમારો નંબર કે નામ સરકાર કે પબ્લિકને ક્યારેય દેખાશે નહીં.',
      'issue_title': 'સમસ્યાનું શીર્ષક',
      'issue_desc': 'સમસ્યાની સંપૂર્ણ વિગતવાર માહિતી',
      'location_hint': 'ઘટના સ્થળ / સરનામું',
      'before_evidence': 'લાઈવ પુરાવા (Before)',
      'after_evidence': 'ગેલેરી (After)',
      'attach_files': 'ઓડિયો પુરાવા / દસ્તાવેજ ઉમેરો',
      'remove': 'કાઢી નાખો',
      'submit_btn': 'ફરિયાદ સબમિટ કરો',
      'success_msg': 'ફરિયાદ સિસ્ટમમાં સફળતાપૂર્વક નોંધાઈ ગઈ છે!',
      'petition_badge': 'રાષ્ટ્રીય માંગણી / પિટિશન',
      'petition_title': 'ગંભીર ગુનાઓમાં ત્વરિત અને પારદર્શક તપાસ સુનિશ્ચિત કરવા બાબત',
      'total_votes': 'કુલ નાગરિક સમર્થન:',
      'vote_btn': 'આ પિટિશનને સમર્થન આપો (Vote)',
      'voted_msg': 'તમારો જનમત સફળતાપૂર્વક નોંધાઈ ગયો છે!',
    },
    'hi': {
      'app_title': 'जनता आवाज़',
      'disclaimer': 'अस्वीकरण: स्वतंत्र नागरिक मंच। सरकारी संपर्क आधिकारिक पोर्टल (india.gov.in) से लिए गए हैं। किसी सरकारी संस्था का प्रतिनिधित्व नहीं करता।',
      'btn_report': 'स्थानीय समस्या और साक्ष्य दर्ज करें',
      'btn_petition': 'राष्ट्रीय नागरिक याचिका और मतदान',
      'lang_label': 'भाषा',
      'select_lang': 'अपनी भाषा चुनें',
      'anonymous_title': 'पहचान पूरी तरह गोपनीय रखें (Anonymous)',
      'anonymous_sub': 'आपका नाम या नंबर सरकार या जनता को कभी नहीं दिखेगा।',
      'issue_title': 'समस्या का शीर्षक',
      'issue_desc': 'समस्या का पूरा विवरण',
      'location_hint': 'स्थान / पता',
      'before_evidence': 'लाइव साक्ष्य (Before)',
      'after_evidence': 'गैलरी (After)',
      'attach_files': 'ऑडियो / दस्तावेज संलग्न करें',
      'remove': 'हटाएं',
      'submit_btn': 'शिकायत दर्ज करें',
      'success_msg': 'शिकायत सफलतापूर्वक दर्ज कर ली गई है!',
      'petition_badge': 'राष्ट्रीय नागरिक याचिका',
      'petition_title': 'गंभीर मामलों में त्वरित और निष्पक्ष जांच की मांग',
      'total_votes': 'कुल नागरिक समर्थन:',
      'vote_btn': 'इस याचिका का समर्थन करें (Vote)',
      'voted_msg': 'आपका समर्थन सफलतापूर्वक दर्ज हो गया है!',
    },
  };

  static String get(String key, String lang) {
    return _values[lang]?[key] ?? _values['en']?[key] ?? key;
  }
}

class HomeScreen extends StatelessWidget {
  final String currentLang;
  final Function(String) onLangChanged;

  const HomeScreen({
    super.key,
    required this.currentLang,
    required this.onLangChanged,
  });

  void _openLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final languages = [
          {'code': 'en', 'name': 'English'},
          {'code': 'gu', 'name': 'ગુજરાતી (Gujarati)'},
          {'code': 'hi', 'name': 'हिन्दी (Hindi)'},
          {'code': 'mr', 'name': 'मराठी (Marathi)'},
          {'code': 'bn', 'name': 'বাংলা (Bengali)'},
          {'code': 'ta', 'name': 'தமிழ் (Tamil)'},
          {'code': 'te', 'name': 'తెలుగు (Telugu)'},
          {'code': 'kn', 'name': 'ಕನ್ನಡ (Kannada)'},
          {'code': 'ml', 'name': 'മലയാളം (Malayalam)'},
          {'code': 'pa', 'name': 'ਪੰਜਾਬੀ (Punjabi)'},
        ];

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.get('select_lang', currentLang),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final item = languages[index];
                    return ListTile(
                      title: Text(item['name']!, style: const TextStyle(fontSize: 16)),
                      trailing: currentLang == item['code']
                          ? const Icon(Icons.check_circle, color: Color(0xFF138808))
                          : null,
                      onTap: () {
                        onLangChanged(item['code']!);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.balance, color: Colors.white),
            const SizedBox(width: 8),
            Text(AppStrings.get('app_title', currentLang), style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFF138808),
        actions: [
          InkWell(
            onTap: () => _openLanguagePicker(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.language, size: 26, color: Colors.white),
                  Text(
                    AppStrings.get('lang_label', currentLang),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xFFFFF3E0),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  AppStrings.get('disclaimer', currentLang),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9933),
                minimumSize: const Size(double.infinity, 55),
              ),
              icon: const Icon(Icons.edit_note, color: Colors.white, size: 24),
              label: Text(AppStrings.get('btn_report', currentLang), style: const TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => IssueFormScreen(currentLang: currentLang)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF138808),
                minimumSize: const Size(double.infinity, 55),
              ),
              icon: const Icon(Icons.how_to_vote, color: Colors.white, size: 24),
              label: Text(AppStrings.get('btn_petition', currentLang), style: const TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => PetitionVotingScreen(currentLang: currentLang)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IssueFormScreen extends StatefulWidget {
  final String currentLang;
  const IssueFormScreen({super.key, required this.currentLang});

  @override
  State<IssueFormScreen> createState() => _IssueFormScreenState();
}

class _IssueFormScreenState extends State<IssueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _loc = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _beforeMedia;
  File? _afterMedia;
  List<PlatformFile> _files = [];
  bool _isAnonymous = true;
  bool _isLocating = false;

  Future<void> _pickImage(bool isBefore, ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source, imageQuality: 100);
    if (file != null) {
      setState(() {
        if (isBefore) _beforeMedia = File(file.path);
        else _afterMedia = File(file.path);
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (res != null) {
      setState(() => _files.addAll(res.files));
    }
  }

  Future<void> _getGPS() async {
    setState(() => _isLocating = true);
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
      Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _loc.text = "${p.latitude}, ${p.longitude}";
        _isLocating = false;
      });
    } else {
      setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.currentLang;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('btn_report', lang), style: const TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: const Color(0xFF138808),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: SwitchListTile(
                  activeColor: const Color(0xFF138808),
                  title: Text(AppStrings.get('anonymous_title', lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(AppStrings.get('anonymous_sub', lang)),
                  value: _isAnonymous,
                  onChanged: (v) => setState(() => _isAnonymous = v),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _title,
                decoration: InputDecoration(labelText: AppStrings.get('issue_title', lang), border: const OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                maxLines: 3,
                decoration: InputDecoration(labelText: AppStrings.get('issue_desc', lang), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _loc,
                      decoration: InputDecoration(labelText: AppStrings.get('location_hint', lang), border: const OutlineInputBorder()),
                    ),
                  ),
                  IconButton(
                    icon: _isLocating ? const CircularProgressIndicator() : const Icon(Icons.my_location, color: Color(0xFF138808)),
                    onPressed: _getGPS,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9933)),
                          onPressed: () => _pickImage(true, ImageSource.camera),
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          label: Text(AppStrings.get('before_evidence', lang), style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                        if (_beforeMedia != null)
                          TextButton(
                            onPressed: () => setState(() => _beforeMedia = null),
                            child: Text(AppStrings.get('remove', lang), style: const TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF138808)),
                          onPressed: () => _pickImage(false, ImageSource.gallery),
                          icon: const Icon(Icons.photo_library, color: Colors.white, size: 18),
                          label: Text(AppStrings.get('after_evidence', lang), style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                        if (_afterMedia != null)
                          TextButton(
                            onPressed: () => setState(() => _afterMedia = null),
                            child: Text(AppStrings.get('remove', lang), style: const TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickFiles,
                icon: const Icon(Icons.attach_file),
                label: Text(AppStrings.get('attach_files', lang)),
              ),
              Wrap(
                children: _files.map((f) => Chip(
                  label: Text(f.name, style: const TextStyle(fontSize: 11)),
                  onDeleted: () => setState(() => _files.remove(f)),
                )).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9933)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.get('success_msg', lang))),
                      );
                    }
                  },
                  child: Text(AppStrings.get('submit_btn', lang), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PetitionVotingScreen extends StatefulWidget {
  final String currentLang;
  const PetitionVotingScreen({super.key, required this.currentLang});

  @override
  State<PetitionVotingScreen> createState() => _PetitionVotingScreenState();
}

class _PetitionVotingScreenState extends State<PetitionVotingScreen> {
  int voteCount = 142380;
  bool hasVoted = false;

  @override
  Widget build(BuildContext context) {
    final lang = widget.currentLang;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('btn_petition', lang), style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF138808),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(AppStrings.get('petition_badge', lang), style: const TextStyle(color: Colors.white, fontSize: 11)),
                  backgroundColor: const Color(0xFFFF9933),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.get('petition_title', lang),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.get('total_votes', lang), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("$voteCount", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF138808), fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: hasVoted ? Colors.grey : const Color(0xFFFF9933)),
                    onPressed: hasVoted ? null : () {
                      setState(() {
                        voteCount++;
                        hasVoted = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.get('voted_msg', lang))),
                      );
                    },
                    icon: const Icon(Icons.thumb_up, color: Colors.white),
                    label: Text(AppStrings.get('vote_btn', lang), style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
