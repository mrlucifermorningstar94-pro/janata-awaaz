import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const JanataAwaazApp());
}

class JanataAwaazApp extends StatefulWidget {
  const JanataAwaazApp({super.key});

  @override
  State<JanataAwaazApp> createState() => _JanataAwaazAppState();
}

class _JanataAwaazAppState extends State<JanataAwaazApp> {
  String _currentLang = 'gu';

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
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
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
      'disclaimer': 'Independent citizen accountability portal. Voice against non-responsive administration & public representatives.',
      'btn_report': 'Report Local Issue & Evidence',
      'btn_petition': 'Public Accountability Petitions & Voting',
      'lang_label': 'Language',
      'select_lang': 'Select Your Language',
      'anonymous_title': 'Keep Identity Completely Anonymous',
      'anonymous_sub': 'Your identity remains 100% confidential and safe.',
      'issue_title': 'Issue Title',
      'issue_desc': 'Detailed Description of the Issue',
      'location_hint': 'Location / Address',
      'before_evidence': 'Live Evidence (Before)',
      'after_evidence': 'Gallery (After)',
      'attach_files': 'Attach Audio / PDF Documents',
      'remove': 'Remove',
      'submit_btn': 'Submit Official Report',
      'success_msg': 'Report recorded successfully in the system!',
    },
    'gu': {
      'app_title': 'જનતા અવાજ',
      'disclaimer': 'નાગરિક અધિકાર અને જવાબદેહી મંચ. બેદરકાર તંત્ર, અધિકારી કે નેતાઓ સામે લોકઅવાજ ઉઠાવવાનું સ્વતંત્ર માધ્યમ.',
      'btn_report': 'સ્થાનિક સમસ્યા / પુરાવા નોંધો',
      'btn_petition': 'જન જવાબદેહી પિટિશન અને વોટિંગ',
      'lang_label': 'ભાષા',
      'select_lang': 'તમારી ભાષા પસંદ કરો',
      'anonymous_title': 'ઓળખ સંપૂર્ણ ગુપ્ત રાખો (Anonymous)',
      'anonymous_sub': 'તમારું નામ કે નંબર કોઈને ક્યારેય દેખાશે નહીં.',
      'issue_title': 'સમસ્યાનું શીર્ષક',
      'issue_desc': 'સમસ્યાની સંપૂર્ણ વિગતવાર માહિતી',
      'location_hint': 'ઘટના સ્થળ / સરનામું',
      'before_evidence': 'લાઈવ પુરાવા (Before)',
      'after_evidence': 'ગેલેરી (After)',
      'attach_files': 'ઓડિયો પુરાવા / દસ્તાવેજ ઉમેરો',
      'remove': 'કાઢી નાખો',
      'submit_btn': 'ફરિયાદ સબમિટ કરો',
      'success_msg': 'ફરિયાદ સિસ્ટમમાં સફળતાપૂર્વક નોંધાઈ ગઈ છે!',
    },
    'hi': {
      'app_title': 'जनता आवाज़',
      'disclaimer': 'नागरिक अधिकार और जवाबदेही मंच। लापरवाह प्रशासन, अधिकारी या जनप्रतिनिधियों के खिलाफ स्वतंत्र जनमंच।',
      'btn_report': 'स्थानीय समस्या और साक्ष्य दर्ज करें',
      'btn_petition': 'जन जवाबदेही याचिका और मतदान',
      'lang_label': 'भाषा',
      'select_lang': 'अपनी भाषा चुनें',
      'anonymous_title': 'पहचान पूरी तरह गोपनीय रखें (Anonymous)',
      'anonymous_sub': 'आपकी पहचान हमेशा सुरक्षित और गुप्त रहेगी।',
      'issue_title': 'समस्या का शीर्षक',
      'issue_desc': 'समस्या का पूरा विवरण',
      'location_hint': 'स्थान / पता',
      'before_evidence': 'लाइव साक्ष्य (Before)',
      'after_evidence': 'गैलरी (After)',
      'attach_files': 'ऑडियो / दस्तावेज संलग्न करें',
      'remove': 'हटाएं',
      'submit_btn': 'शिकायत दर्ज करें',
      'success_msg': 'शिकायत सफलतापूर्वक दर्ज कर ली गई है!',
    },
  };

  static String get(String key, String lang) {
    return _values[lang]?[key] ?? _values['gu']?[key] ?? key;
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
          {'code': 'gu', 'name': 'ગુજરાતી (Gujarati)'},
          {'code': 'hi', 'name': 'हिन्दी (Hindi)'},
          {'code': 'en', 'name': 'English'},
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
              ListView.builder(
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
            const Icon(Icons.campaign, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(AppStrings.get('app_title', currentLang),
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF138808),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white, size: 26),
            onPressed: () => _openLanguagePicker(context),
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
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9933),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.edit_location_alt, color: Colors.white, size: 24),
              label: Text(AppStrings.get('btn_report', currentLang),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => IssueFormScreen(currentLang: currentLang)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF138808),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.how_to_vote, color: Colors.white, size: 24),
              label: Text(AppStrings.get('btn_petition', currentLang),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

// ----------------- MAP PICKER -----------------
class MapPickerScreen extends StatefulWidget {
  final LatLng initialLocation;
  const MapPickerScreen({super.key, required this.initialLocation});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('નકશા પર પિન મૂકો (Pin Drop)', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF138808),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context, _selectedLocation),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _selectedLocation,
          initialZoom: 15.0,
          onTap: (tapPosition, point) {
            setState(() {
              _selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.janata.awaaz',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedLocation,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_on,
                  size: 45,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9933),
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          label: const Text('આ લોકેશન કન્ફર્મ કરો', style: TextStyle(color: Colors.white, fontSize: 16)),
          onPressed: () => Navigator.pop(context, _selectedLocation),
        ),
      ),
    );
  }
}

// ----------------- ISSUE REPORT FORM -----------------
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
        if (isBefore) {
          _beforeMedia = File(file.path);
        } else {
          _afterMedia = File(file.path);
        }
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (res != null) {
      setState(() => _files.addAll(res.files));
    }
  }

  Future<void> _openMapOrGPS() async {
    setState(() => _isLocating = true);

    LatLng targetLocation = const LatLng(23.0225, 72.5714);

    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
        Position p = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 4),
        );
        targetLocation = LatLng(p.latitude, p.longitude);
      }
    } catch (_) {}

    setState(() => _isLocating = false);

    if (!mounted) return;

    final LatLng? picked = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => MapPickerScreen(initialLocation: targetLocation),
      ),
    );

    if (picked != null) {
      setState(() {
        _loc.text = "${picked.latitude.toStringAsFixed(6)}, ${picked.longitude.toStringAsFixed(6)}";
      });
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
                  title: Text(AppStrings.get('anonymous_title', lang),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(AppStrings.get('anonymous_sub', lang)),
                  value: _isAnonymous,
                  onChanged: (v) => setState(() => _isAnonymous = v),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _title,
                decoration: InputDecoration(
                    labelText: AppStrings.get('issue_title', lang), border: const OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "જરૂરી છે" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: AppStrings.get('issue_desc', lang), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _loc,
                      decoration: InputDecoration(
                        labelText: AppStrings.get('location_hint', lang),
                        hintText: "સરનામું લખો અથવા મેપ પરથી પિન કરો",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isLocating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.map, color: Color(0xFF138808), size: 30),
                    onPressed: _openMapOrGPS,
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
                          label: Text(AppStrings.get('before_evidence', lang),
                              style: const TextStyle(color: Colors.white, fontSize: 11)),
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
                          label: Text(AppStrings.get('after_evidence', lang),
                              style: const TextStyle(color: Colors.white, fontSize: 11)),
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
                children: _files
                    .map((f) => Chip(
                          label: Text(f.name, style: const TextStyle(fontSize: 11)),
                          onDeleted: () => setState(() => _files.remove(f)),
                        ))
                    .toList(),
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
                  child: Text(AppStrings.get('submit_btn', lang),
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- CITIZEN ACCOUNTABILITY PETITION MODEL -----------------
class PetitionItem {
  final String title;
  final String category;
  final String primaryOfficer;
  final String inChargeOfficer;
  final String superiorOfficer;
  final String departmentPost;
  final String officialEmails;
  final String officialContacts;
  final String allegationReason;
  final String dateTimeString;
  int votes;
  bool isVoted;

  PetitionItem({
    required this.title,
    required this.category,
    required this.primaryOfficer,
    this.inChargeOfficer = '',
    required this.superiorOfficer,
    required this.departmentPost,
    required this.officialEmails,
    required this.officialContacts,
    required this.allegationReason,
    required this.dateTimeString,
    required this.votes,
    this.isVoted = false,
  });
}

// ----------------- PETITION SCREEN -----------------
class PetitionVotingScreen extends StatefulWidget {
  final String currentLang;
  const PetitionVotingScreen({super.key, required this.currentLang});

  @override
  State<PetitionVotingScreen> createState() => _PetitionVotingScreenState();
}

class _PetitionVotingScreenState extends State<PetitionVotingScreen> {
  final List<PetitionItem> _petitions = [
    PetitionItem(
      title: "સેવા સદન સંપૂર્ણ બંધ: કર્મચારીઓ સામૂહિક હડતાળ પર જતાં સેંકડો અરજદારો હેરાન",
      category: "કચેરી બંધ / સામૂહિક હડતાળ (Office Strike)",
      primaryOfficer: "નિવાસી અધિક કલેક્ટર (RAC) / સેવા સદન ઇન્ચાર્જ",
      inChargeOfficer: "નાયબ મામલતદાર (જનસેવા કેન્દ્ર)",
      superiorOfficer: "જિલ્લા કલેક્ટરશ્રી / અગ્ર સચિવ (મહેસૂલ વિભાગ)",
      departmentPost: "જિલ્લા સેવા સદન / મહેસૂલ શાખા",
      officialEmails: "collector-office@gujarat.gov.in, rac-office@gujarat.gov.in, rev-sec@gujarat.gov.in",
      officialContacts: "079-23250000, 1800-233-5500",
      allegationReason:
          "કોઈપણ પૂર્વ સૂચના કે વૈકલ્પિક વ્યવસ્થા વિના આખી કચેરી અચાનક બંધ કરી દેવામાં આવી. દૂર-દૂરના ગામડાઓમાંથી ભાડાં ખર્ચીને આવેલા દાખલા, રેશનકાર્ડ અને જમીનના કામના અરજદારો ભારે હેરાન થયા છે. જાહેર સેવા અધિનિયમ મુજબ તાત્કાલિક ઇમરજન્સી કાઉન્ટર ઊભું કરવામાં આવે.",
      dateTimeString: "07/10/2026, 11:15 AM",
      votes: 18450,
    ),
    PetitionItem(
      title: "વારંવાર રજૂઆત છતાં બિસ્માર રસ્તાઓ અને ગટરનું કામ ન થવા બાબત",
      category: "રસ્તા / ગટર / ખાડા",
      primaryOfficer: "કાર્યપાલક ઇજનેર / વોર્ડ કોર્પોરેટર",
      inChargeOfficer: "નાયબ કાર્યપાલક ઇજનેર (ચાર્જ ઓફિસર)",
      superiorOfficer: "મ્યુનિસિપલ કમિશનરશ્રી / જિલ્લા કલેક્ટર",
      departmentPost: "મ્યુનિસિપલ કોર્પોરેશન - PWD શાખા",
      officialEmails: "commissioner-office@gujarat.gov.in, pwd-eng@nic.in",
      officialContacts: "079-27550000, 1800-233-1000",
      allegationReason:
          "છેલ્લા ૬ મહિનાથી ૫૦૦ પરિવારો દ્વારા લેખિત રજૂઆત છતાં એકબીજા પર ઢોળી કામ અટકાવી રાખ્યું છે અને ખોટા ધક્કા ખવડાવે છે.",
      dateTimeString: "05/10/2026, 11:30 AM",
      votes: 142381,
    ),
  ];

  Future<void> _sendOfficialEmail(PetitionItem p) async {
    final String recipient = p.officialEmails.split(',').first.trim();
    final String subject = "તાત્કાલિક સત્તાવાર રજૂઆત: ${p.title}";
    final String body =
        "પ્રતિશ્રી,\n${p.superiorOfficer},\n${p.primaryOfficer},\n\n"
        "વિષય: ${p.title}\n\n"
        "ઘટના સ્થળ અને વિભાગ: ${p.departmentPost}\n"
        "તારીખ અને સમય: ${p.dateTimeString}\n"
        "કુલ અસરગ્રસ્ત નાગરિકો/વોટ: ${p.votes}\n\n"
        "વિગતવાર ફરિયાદ / બેદરકારી:\n${p.allegationReason}\n\n"
        "આ ફરિયાદ જનતા અવાજ નાગરિક મંચ દ્વારા સત્તાવાર પુરાવા સાથે દાખલ કરવામાં આવેલ છે. "
        "જાહેર સેવા હક અધિનિયમ મુજબ તાત્કાલિક યોગ્ય તપાસ અને વૈકલ્પિક વ્યવસ્થા ગોઠવવા નમ્ર વિનંતી.\n\n"
        "- જનતા અવાજ નાગરિક એકતા";

    await Clipboard.setData(ClipboardData(text: "પ્રતિ: $recipient\nવિષય: $subject\n\n$body"));

    // Space mate '%20' use thase jethi '+' vado symbol nahi aave
    String cleanEncode(String str) =>
        Uri.encodeQueryComponent(str).replaceAll('+', '%20');

    final Uri mailtoUri = Uri.parse(
      'mailto:$recipient?subject=${cleanEncode(subject)}&body=${cleanEncode(body)}',
    );

    try {
      final bool launched = await launchUrl(
        mailtoUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );

      if (!launched) {
        await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("ઈમેલ અને અરજી લખાણ કોપી થઈ ગયું છે!"),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showNoticeSentDialog(PetitionItem p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.verified, color: Color(0xFF138808), size: 28),
            SizedBox(width: 8),
            Text("સત્તાવાર ડિસ્પેચ પુરાવો", style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "આ ફરિયાદની સંપૂર્ણ વિગત નીચેના સત્તાવાર સરકારી ઈમેલ અને સંપર્ક નંબર પર મોકલી આપવા માટે રેકોર્ડ થઈ છે:",
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFF9933)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📧 સત્તાવાર ઈમેલ: ${p.officialEmails}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 6),
                  Text("📞 સંપર્ક નંબર: ${p.officialContacts}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text("🏛️ વરિષ્ઠ સુપરવાઇઝર: ${p.superiorOfficer}",
                      style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  if (p.inChargeOfficer.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text("🔄 ચાર્જ ઓફિસર: ${p.inChargeOfficer}",
                        style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF138808)),
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                label: const Text("સીધો ઈમેલ મોકલો (Send Notice)",
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(ctx);
                  _sendOfficialEmail(p);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("બંધ કરો", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showCreatePetitionDialog() {
    final titleCtrl = TextEditingController();
    final primaryOfficerCtrl = TextEditingController();
    final inChargeCtrl = TextEditingController();
    final superiorCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    final customCategoryCtrl = TextEditingController();
    final customDeptCtrl = TextEditingController();

    bool hasInCharge = false;

    String selectedCategory = "કચેરી બંધ / સામૂહિક હડતાળ (Office Strike)";
    String selectedDept = "જિલ્લા સેવા સદન / કલેક્ટર કચેરી";

    final categories = [
      "કચેરી બંધ / સામૂહિક હડતાળ (Office Strike)",
      "પાણી પુરવઠો (Water Supply)",
      "રસ્તા / ગટર / ખાડા (Roads & Drainage)",
      "વીજળી / લાઈટ (Electricity/GEB)",
      "આરોગ્ય / હોસ્પિટલ (Health/Hospital)",
      "શિક્ષણ / શાળા / કોલેજ (Education/Schools)",
      "પોલીસ / કાયદો-વ્યવસ્થા (Police/Safety)",
      "જમીન / મહેસૂલ / પંચાયત (Revenue/Land)",
      "લાંચ / ભ્રષ્ટાચાર / ગેરરીતિ (Corruption)",
      "અન્ય સમસ્યા (Other Issue)",
    ];

    final departments = [
      "જિલ્લા સેવા સદન / કલેક્ટર કચેરી",
      "મ્યુનિસિપલ કોર્પોરેશન / નગરપાલિકા",
      "ગ્રામ પંચાયત / તાલુકા પંચાયત",
      "વીજળી બોર્ડ (GEB / Discom)",
      "પોલીસ તંત્ર (Police Department)",
      "પી.ડબલ્યુ.ડી. (PWD - માર્ગ-મકાન)",
      "જિલ્લા આરોગ્ય વિભાગ / સિવિલ",
      "શિક્ષણ વિભાગ / DEO કચેરી",
      "અન્ય કચેરી / વિભાગ (Other Department)",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shield, color: Color(0xFF138808), size: 26),
                        SizedBox(width: 8),
                        Text(
                          "સત્તાવાર જન પિટિશન નોંધાવો",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Text(
                      "હડતાળ, કચેરી બંધ કે ધક્કાબાજી સામે ત્રણેય સ્તરના વડાઓને સાથે ટેગ કરો:",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 14),

                    // ૧. મુખ્ય વિષય
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: "મુખ્ય વિષય / મુદ્દો",
                        hintText: "દા.ત. સેવા સદન બંધ રહેતાં અરજદારો હેરાન",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ૨. સમસ્યાનો પ્રકાર
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "૧. સમસ્યાનો પ્રકાર પસંદ કરો",
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 14)));
                      }).toList(),
                      onChanged: (val) {
                        setModalState(() {
                          selectedCategory = val!;
                          if (selectedCategory.contains("Office Strike")) {
                            primaryOfficerCtrl.text = "નિવાસી અધિક કલેક્ટર (RAC)";
                            superiorCtrl.text = "જિલ્લા કલેક્ટરશ્રી / મહેસૂલ સચિવ";
                            emailCtrl.text = "collector-office@gujarat.gov.in, rev-sec@gujarat.gov.in";
                            phoneCtrl.text = "079-23250000";
                          }
                        });
                      },
                    ),
                    if (selectedCategory == "અન્ય સમસ્યા (Other Issue)") ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: customCategoryCtrl,
                        decoration: const InputDecoration(
                          labelText: "અન્ય સમસ્યાનું નામ લખો",
                          hintText: "તમારી વિશિષ્ટ સમસ્યા લખો...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // ૩. કચેરી / વિભાગ
                    DropdownButtonFormField<String>(
                      value: selectedDept,
                      decoration: const InputDecoration(
                        labelText: "૨. સંબંધિત સરકારી કચેરી / ખાતું",
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: departments.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept, style: const TextStyle(fontSize: 14)));
                      }).toList(),
                      onChanged: (val) {
                        setModalState(() {
                          selectedDept = val!;
                        });
                      },
                    ),
                    if (selectedDept == "અન્ય કચેરી / વિભાગ (Other Department)") ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: customDeptCtrl,
                        decoration: const InputDecoration(
                          labelText: "અન્ય કચેરી / વિભાગનું નામ લખો",
                          hintText: "દા.ત. પ્રદૂષણ નિયંત્રણ બોર્ડ (GPCB)...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // ૪. મૂળ અધિકારી/નેતાનું પદ
                    TextField(
                      controller: primaryOfficerCtrl,
                      decoration: const InputDecoration(
                        labelText: "૩. મૂળ જવાબદાર અધિકારી / નેતા",
                        hintText: "દા.ત. નિવાસી અધિક કલેક્ટર (RAC) / મામલતદાર",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ચાર્જ ઓફિસર સ્વિચ
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: const Color(0xFF138808),
                      title: const Text("અધિકારી રજા પર છે / ચાર્જ બીજા પાસે છે?",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      value: hasInCharge,
                      onChanged: (v) => setModalState(() => hasInCharge = v),
                    ),
                    if (hasInCharge) ...[
                      TextField(
                        controller: inChargeCtrl,
                        decoration: const InputDecoration(
                          labelText: "ચાર્જ અધિકારી / લિંક ઓફિસરનું પદ/નામ",
                          hintText: "દા.ત. નાયબ ઇજનેર / નાયબ મામલતદાર",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // ૫. ઉપરી વરિષ્ઠ અધિકારી
                    TextField(
                      controller: superiorCtrl,
                      decoration: const InputDecoration(
                        labelText: "૪. ઉપરી વરિષ્ઠ અધિકારી (સુપરવાઇઝર / બોસ)",
                        hintText: "દા.ત. જિલ્લા કલેક્ટરશ્રી / મ્યુનિસિપલ કમિશનર",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ૬. સત્તાવાર ઈમેલ
                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        labelText: "૫. કચેરી/અધિકારીના સત્તાવાર ઈમેલ (Email IDs)",
                        hintText: "દા.ત. collector-office@gujarat.gov.in",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ૭. ફોન નંબર / હેલ્પલાઇન
                    TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(
                        labelText: "૬. સત્તાવાર ફોન નંબર / હેલ્પલાઇન",
                        hintText: "દા.ત. 079-xxxxxxx, 1800-xxx-xxxx",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ૮. શું વાંક છે?
                    TextField(
                      controller: reasonCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "૭. શું વાંક છે? (હડતાળ / ધક્કાબાજીની વિગત)",
                        hintText: "કચેરી કેમ બંધ છે અથવા શું મુશ્કેલી પડી રહી છે તે સ્પષ્ટ લખો...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9933),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.send_and_archive, color: Colors.white),
                        label: const Text("સત્તાવાર નોટિસ સાથે લાઈવ કરો",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (titleCtrl.text.isNotEmpty && primaryOfficerCtrl.text.isNotEmpty) {
                            final now = DateTime.now();
                            final formattedDate =
                                "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

                            final finalCategory = selectedCategory.contains("Other")
                                ? (customCategoryCtrl.text.isNotEmpty ? customCategoryCtrl.text : "અન્ય મુદ્દો")
                                : selectedCategory;

                            final finalDept = selectedDept.contains("Other")
                                ? (customDeptCtrl.text.isNotEmpty ? customDeptCtrl.text : "અન્ય વિભાગ")
                                : selectedDept;

                            setState(() {
                              _petitions.insert(
                                0,
                                PetitionItem(
                                  title: titleCtrl.text,
                                  category: finalCategory,
                                  primaryOfficer: primaryOfficerCtrl.text,
                                  inChargeOfficer: hasInCharge ? inChargeCtrl.text : '',
                                  superiorOfficer: superiorCtrl.text.isNotEmpty ? superiorCtrl.text : "જિલ્લા કલેક્ટર કચેરી",
                                  departmentPost: finalDept,
                                  officialEmails: emailCtrl.text.isNotEmpty ? emailCtrl.text : "collector-office@gujarat.gov.in",
                                  officialContacts: phoneCtrl.text.isNotEmpty ? phoneCtrl.text : "1800-233-5500",
                                  allegationReason: reasonCtrl.text.isNotEmpty
                                      ? reasonCtrl.text
                                      : "કચેરી બંધ રહેવાથી અરજદારો હેરાન અને વૈકલ્પિક વ્યવસ્થાનો અભાવ.",
                                  dateTimeString: formattedDate,
                                  votes: 1,
                                  isVoted: true,
                                ),
                              );
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("પિટિશન અને સત્તાવાર નોટિસ રેકોર્ડ થઈ ગઈ છે!")),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('જન જવાબદેહી પિટિશન અને વોટિંગ', style: TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: const Color(0xFF138808),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFF9933),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("નવી પિટિશન", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: _showCreatePetitionDialog,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
        itemCount: _petitions.length,
        itemBuilder: (context, index) {
          final p = _petitions[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEEDB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.category,
                          style: const TextStyle(color: Color(0xFFD35400), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            p.dateTimeString,
                            style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Divider(height: 18),

                  // ૧. મૂળ અધિકારી
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person_pin, size: 18, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            children: [
                              const TextSpan(text: "૧. મૂળ જવાબદાર: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "${p.primaryOfficer} (${p.departmentPost})"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ૨. ચાર્જ અધિકારી
                  if (p.inChargeOfficer.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.swap_horiz, size: 18, color: Colors.orange),
                        const SizedBox(width: 6),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                              children: [
                                const TextSpan(text: "૨. હાલનો ચાર્જ: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "${p.inChargeOfficer} (ચાર્જ સંભાળનાર)"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ૩. ઉપરી બોસ
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.account_balance, size: 18, color: Color(0xFF138808)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            children: [
                              const TextSpan(text: "૩. વરિષ્ઠ સુપરવાઇઝર: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: p.superiorOfficer),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // શું વાંક છે?
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.report_problem, size: 18, color: Color(0xFFFF9933)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            children: [
                              const TextSpan(
                                  text: "સમસ્યા / બેદરકારી: ",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                              TextSpan(text: p.allegationReason),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // સત્તાવાર ડિસ્પેચ બટન
                  InkWell(
                    onTap: () => _showNoticeSentDialog(p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF138808)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.mark_email_read, size: 16, color: Color(0xFF138808)),
                          SizedBox(width: 6),
                          Text("સત્તાવાર નોટિસ મોકલો / પુરાવો જુઓ (Send Notice)",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF138808))),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 22),

                  // વોટિંગ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("કુલ નાગરિક સમર્થન:", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            "${p.votes} વોટ",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF138808), fontSize: 18),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.isVoted ? Colors.grey : const Color(0xFFFF9933),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: p.isVoted
                            ? null
                            : () {
                                setState(() {
                                  p.votes++;
                                  p.isVoted = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("તમારો વિરોધ/સમર્થન વોટ નોંધાઈ ગયો છે!")),
                                );
                              },
                        icon: Icon(p.isVoted ? Icons.check : Icons.thumb_up, color: Colors.white, size: 18),
                        label: Text(
                          p.isVoted ? "વોટ આપેલ છે" : "સમર્થન આપો (Vote)",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
