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
  const IssueFormScreen({super.
