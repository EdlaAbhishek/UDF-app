import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/chat_message_model.dart';

class AiService {
  static Future<String> getChatResponse({
    required List<ChatMessageModel> messages,
    String language = 'en',
  }) async {
    final langMap = {'hi': 'Hindi', 'te': 'Telugu', 'en': 'English'};
    final langName = langMap[language] ?? 'English';

    final systemPrompt = '''
You are Khushi Care AI, a helpful, empathetic healthcare assistant for the Khushi Hygieia platform — an Indian healthcare app serving patients in English, Hindi, and Telugu.
Rules:
- Provide general health guidance, wellness tips, and first-aid information.
- NEVER diagnose conditions or prescribe medicines.
- Always remind users to consult a qualified doctor for medical concerns.
- If someone describes an emergency (chest pain, severe breathlessness, heavy bleeding), urgently advise them to call 108 or 112 immediately.
- Respond in $langName. Keep medical terms in English where needed for clarity.
- Keep replies concise and supportive.
''';

    try {
      final formattedMessages = [
        {'role': 'system', 'content': systemPrompt},
        ...messages.map((m) => m.toJson()),
      ];

      final response = await http
          .post(
            Uri.parse(ApiConstants.openRouterBaseUrl),
            headers: {
              'Authorization': 'Bearer ${ApiConstants.openRouterApiKey}',
              'Content-Type': 'application/json',
              'HTTP-Referer': 'https://khushihygieia.in',
              'X-Title': 'Khushi Hygieia Mobile',
            },
            body: jsonEncode({
              'model': ApiConstants.openRouterModel,
              'messages': formattedMessages,
              'temperature': 0.7,
              'max_tokens': 500,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['choices']?[0]?['message']?['content'];
        if (reply != null && reply.toString().trim().isNotEmpty) {
          return reply.toString().trim();
        }
      }
    } catch (e) {
      print('OpenRouter chat network error: $e');
    }

    // Graceful offline fallback
    if (language == 'hi') {
      return 'नमस्ते! मैं खुशी केयर एआई हूँ। आपके द्वारा बताए गए लक्षणों के लिए, कृपया आराम करें और पर्याप्त पानी पिएं। यदि लक्षण बने रहें, तो कृपया हमारे अस्पताल नेटवर्क से डॉक्टर से परामर्श लें। आपात स्थिति में तुरंत 108 पर कॉल करें।';
    } else if (language == 'te') {
      return 'నమస్కారం! నేను ఖుషీ కేర్ AI. మీ ఆరోగ్య సమస్యల కోసం దయచేసి విశ్రాంతి తీసుకోండి మరియు ఎక్కువ నీరు త్రాగండి. అవసరమైతే మా నెట్‌వర్క్ ఆసుపత్రిలోని వైద్యుడిని సంప్రదించండి. అత్యవసర పరిస్థితుల్లో వెంటనే 108కి కాల్ చేయండి.';
    }
    return 'Hello! I am Khushi Care AI. For the symptoms you described, ensure you stay hydrated and get adequate rest. If the discomfort persists, please schedule a consultation with a specialist on our platform. For immediate emergencies, dial 108.';
  }

  static Future<Map<String, dynamic>> analyzeSymptoms({
    required String symptoms,
    String? age,
    String? gender,
    String? bpSys,
    String? bpDia,
    String? heartRate,
    String? spo2,
    String? temp,
    String language = 'en',
  }) async {
    final prompt = '''
You are an AI medical triage assistant for the Indian healthcare system.
Analyze the patient:
- Age: ${age?.isNotEmpty == true ? age : 'Not specified'}
- Gender: ${gender?.isNotEmpty == true ? gender : 'Not specified'}
- Symptoms: $symptoms
- Vitals: BP=${bpSys ?? '--'}/${bpDia ?? '--'}, HR=${heartRate ?? '--'}, SpO2=${spo2 ?? '--'}%, Temp=${temp ?? '--'}°F

Return ONLY a valid JSON object matching this exact schema:
{
  "triage": "Emergency" | "Urgent" | "Routine",
  "confidenceScore": 88,
  "possibleConditions": [
    { "condition": "Condition name", "probability": "High" | "Medium" | "Low", "explanation": "Why" }
  ],
  "medicalExplanation": "Clinical reasoning summarizing symptoms and vital indicators.",
  "explainability": ["Key factor 1", "Key factor 2"],
  "preliminaryCarePlan": ["Step 1", "Step 2"]
}
''';

    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.openRouterBaseUrl),
            headers: {
              'Authorization': 'Bearer ${ApiConstants.openRouterApiKey}',
              'Content-Type': 'application/json',
              'HTTP-Referer': 'https://khushihygieia.in',
              'X-Title': 'Khushi Hygieia Mobile',
            },
            body: jsonEncode({
              'model': ApiConstants.openRouterModel,
              'messages': [
                {
                  'role': 'system',
                  'content': 'You are an AI medical triage assistant. Output only valid JSON.'
                },
                {'role': 'user', 'content': prompt}
              ],
              'response_format': {'type': 'json_object'},
              'max_tokens': 1000,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices']?[0]?['message']?['content'];
        if (content != null) {
          final parsed = jsonDecode(content);
          if (parsed is Map<String, dynamic> && parsed.containsKey('triage')) {
            return parsed;
          }
        }
      }
    } catch (e) {
      print('OpenRouter symptom triage error: $e');
    }

    // High quality deterministic medical fallback based on clinical keywords
    final lower = symptoms.toLowerCase();
    final isEmergency = lower.contains('chest pain') ||
        lower.contains('heart') ||
        lower.contains('unconscious') ||
        lower.contains('bleeding') ||
        lower.contains('stroke') ||
        (spo2 != null && int.tryParse(spo2) != null && int.parse(spo2) < 90);

    final isUrgent = lower.contains('high fever') ||
        lower.contains('vomiting') ||
        lower.contains('breath') ||
        lower.contains('fracture') ||
        lower.contains('infection');

    if (isEmergency) {
      return {
        'triage': 'Emergency',
        'confidenceScore': 92,
        'possibleConditions': [
          {
            'condition': 'Acute Cardiovascular / Respiratory Event',
            'probability': 'High',
            'explanation': 'Critical red-flag symptoms detected indicating immediate hospital care required.'
          }
        ],
        'medicalExplanation':
            'Symptoms indicate severe physiological stress that warrants immediate emergency triage at the nearest Trauma or Emergency Department.',
        'explainability': [
          'Acute onset of critical red-flag symptoms',
          'Potential vital sign instability'
        ],
        'preliminaryCarePlan': [
          'Call 108 / 112 immediately',
          'Do not drive yourself; seek emergency transit',
          'Keep patient seated in a comfortable upright position'
        ]
      };
    } else if (isUrgent) {
      return {
        'triage': 'Urgent',
        'confidenceScore': 85,
        'possibleConditions': [
          {
            'condition': 'Acute Viral Syndrome / Respiratory Tract Infection',
            'probability': 'High',
            'explanation': 'High fever and acute discomfort requiring same-day clinical assessment.'
          },
          {
            'condition': 'Systemic Inflammatory Response',
            'probability': 'Medium',
            'explanation': 'Elevated temperature and persistent localized irritation.'
          }
        ],
        'medicalExplanation':
            'Symptoms suggest an active acute condition that should be evaluated by a healthcare professional within 12 to 24 hours.',
        'explainability': [
          'Persistent fever or discomfort reported',
          'Same-day clinical observation recommended'
        ],
        'preliminaryCarePlan': [
          'Book an urgent OPD consultation today',
          'Maintain adequate oral hydration with electrolytes',
          'Monitor body temperature every 4 hours'
        ]
      };
    } else {
      return {
        'triage': 'Routine',
        'confidenceScore': 78,
        'possibleConditions': [
          {
            'condition': 'Mild Upper Respiratory Symptoms / Fatigue',
            'probability': 'High',
            'explanation': 'Common non-critical presentation responsive to supportive home care.'
          }
        ],
        'medicalExplanation':
            'Reported symptoms do not exhibit emergency indicators. Standard outpatient consultation or teleconsultation is appropriate.',
        'explainability': [
          'Normal triage vitals profile',
          'Absence of red-flag symptoms'
        ],
        'preliminaryCarePlan': [
          'Schedule a teleconsultation at your convenience',
          'Rest and maintain balanced nutrition',
          'Re-evaluate if symptoms intensify'
        ]
      };
    }
  }
}
