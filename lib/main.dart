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

    // '%20' encoding vaparvathi '+' vado issue aavshe nahi ane clean space aavshe
    String encodeQueryComponent(String string) =>
        Uri.encodeQueryComponent(string).replaceAll('+', '%20');

    final Uri mailtoUri = Uri.parse(
      'mailto:$recipient?subject=${encodeQueryComponent(subject)}&body=${encodeQueryComponent(body)}',
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
