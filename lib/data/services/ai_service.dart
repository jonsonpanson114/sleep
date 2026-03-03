import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/constants.dart';
import '../../domain/entities/daily_log.dart';

class AIInsightResult {
  final String title;
  final String message;
  final String category; // 'sleep_quality', 'pattern', 'recommendation'
  final double confidence; // 0.0 - 1.0

  AIInsightResult({
    required this.title,
    required this.message,
    required this.category,
    this.confidence = 0.8,
  });
}

class AIService {
  final http.Client _client = http.Client();

  /// Generate sleep insights using Gemini API
  Future<List<AIInsightResult>> generateSleepInsights({
    required List<DailyLog> logs,
  }) async {
    if (!GeminiAPIConfig.isConfigured) {
      debugPrint('Gemini API not configured. Using fallback insights.');
      return _generateFallbackInsights(logs);
    }

    try {
      // Prepare data for analysis
      final logData = _prepareLogData(logs);
      final prompt = _buildPrompt(logData);

      // Call Gemini API
      final response = await _callGeminiAPI(prompt);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final insights = _parseGeminiResponse(data);
        return insights;
      } else {
        debugPrint('Gemini API error: ${response.statusCode}');
        return _generateFallbackInsights(logs);
      }
    } catch (e) {
      debugPrint('Error calling Gemini API: $e');
      return _generateFallbackInsights(logs);
    }
  }

  /// Generate weekly summary using Gemini
  Future<String> generateWeeklySummary({
    required List<DailyLog> logs,
  }) async {
    if (!GeminiAPIConfig.isConfigured || logs.isEmpty) {
      return _generateFallbackSummary(logs);
    }

    try {
      final logData = _prepareLogData(logs);
      final prompt = _buildWeeklyPrompt(logData);

      final response = await _callGeminiAPI(prompt);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseSummaryResponse(data);
      } else {
        return _generateFallbackSummary(logs);
      }
    } catch (e) {
      debugPrint('Error generating weekly summary: $e');
      return _generateFallbackSummary(logs);
    }
  }

  /// Prepare log data for API call
  Map<String, dynamic> _prepareLogData(List<DailyLog> logs) {
    return {
      'totalDays': logs.length,
      'completedRoutines': logs.where((l) => l.eveningCompleted || l.morningCompleted).length,
      'avgSleepDuration': _calculateAvgSleepDuration(logs),
      'recentLogs': logs.take(7).map((l) => {
        'date': l.date.toIso8601String(),
        'eveningCompleted': l.eveningCompleted,
        'morningCompleted': l.morningCompleted,
        'daytimeSleepiness': l.daytimeSleepiness,
        'feltIrritable': l.feltIrritable,
        'sleepDuration': l.sleepDurationMinutes,
      }).toList(),
    };
  }

  double? _calculateAvgSleepDuration(List<DailyLog> logs) {
    final durations = logs
        .map((l) => l.sleepDurationMinutes)
        .whereType<int>()
        .toList();

    if (durations.isEmpty) return null;
    return durations.reduce((a, b) => a + b) / durations.length;
  }

  /// Build prompt for sleep insights
  String _buildPrompt(Map<String, dynamic> data) {
    return '''
あなたは睡眠分析の専門家です。以下の睡眠データに基づいて、3つの重要なインサイトを生成してください。

データ:
- 総記録日数: ${data['totalDays']}
- ルーティン完了率: ${((data['completedRoutines'] / (data['totalDays'] > 0 ? data['totalDays'] : 1)) * 100).toStringAsFixed(1)}%
- 平均睡眠時間: ${data['avgSleepDuration'] != null ? '${(data['avgSleepDuration']! / 60).toStringAsFixed(1)}' : '不明'}時間
- 最近7日間の傾向: ${data['recentLogs']?.length ?? 0}日間の記録

出力フォーマット（JSON配列）:
[
  {
    "title": "簡潔なタイトル（20文字以内）",
    "message": "詳細なメッセージ（100文字以内）",
    "category": "sleep_quality" | "pattern" | "recommendation"
  }
]

重要: JSONのみを出力してください。他のテキストを含めないでください。
''';
  }

  /// Build prompt for weekly summary
  String _buildWeeklyPrompt(Map<String, dynamic> data) {
    return '''
あなたはコーチの「斎藤さん」です。先週の睡眠習慣について、温かく励ます週間総括を作成してください。

データ:
- 総記録日数: ${data['totalDays']}
- ルーティン完了率: ${((data['completedRoutines'] / (data['totalDays'] > 0 ? data['totalDays'] : 1)) * 100).toStringAsFixed(1)}%
- 平均睡眠時間: ${data['avgSleepDuration'] != null ? (data['avgSleepDuration'] / 60).toStringAsFixed(1) : '不明'}時間

トーン: 温かい、励ます、具体的

出力フォーマット:
「〇〇さん、先週は○日間記録できましたね...」（100〜150文字程度）

重要: 日本語で出力してください。
''';
  }

  /// Call Gemini API
  Future<http.Response> _callGeminiAPI(String prompt) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 1024,
      }
    });

    final url = Uri.parse('${GeminiAPIConfig.baseUrl}?key=${GeminiAPIConfig.apiKeyValue}');

    return await _client.post(
      url,
      headers: headers,
      body: body,
    );
  }

  /// Parse Gemini API response for insights
  List<AIInsightResult> _parseGeminiResponse(dynamic data) {
    try {
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
      if (text == null) return [];

      // Extract JSON from response
      final jsonStart = text.indexOf('[');
      final jsonEnd = text.lastIndexOf(']') + 1;

      if (jsonStart == -1 || jsonEnd == 0) return [];

      final jsonStr = text.substring(jsonStart, jsonEnd);
      final List<dynamic> jsonList = jsonDecode(jsonStr);

      return jsonList.map((item) {
        return AIInsightResult(
          title: item['title'] as String? ?? '',
          message: item['message'] as String? ?? '',
          category: item['category'] as String? ?? 'recommendation',
        );
      }).toList();
    } catch (e) {
      debugPrint('Error parsing Gemini response: $e');
      return [];
    }
  }

  /// Parse Gemini API response for summary
  String _parseSummaryResponse(dynamic data) {
    try {
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String? ?? '';
    } catch (e) {
      debugPrint('Error parsing summary response: $e');
      return '';
    }
  }

  /// Fallback insights when API is not available
  List<AIInsightResult> _generateFallbackInsights(List<DailyLog> logs) {
    final insights = <AIInsightResult>[];

    if (logs.isEmpty) {
      return insights;
    }

    // Analyze recent patterns
    final recentLogs = logs.take(7).toList();

    // Check routine consistency
    final completedCount = recentLogs.where((l) => l.eveningCompleted || l.morningCompleted).length;
    if (completedCount >= 5) {
      insights.add(AIInsightResult(
        title: 'ルーティン定着',
        message: '最近7日間で${completedCount}日、ルーティンを達成しています。',
        category: 'pattern',
        confidence: 0.9,
      ));
    }

    // Check sleep quality indicators
    final sleepyDays = recentLogs.where((l) => l.daytimeSleepiness == true).length;
    if (sleepyDays >= 3) {
      insights.add(AIInsightResult(
        title: '日中の眠気',
        message: '最近、日中の眠気が多い傾向があります。',
        category: 'sleep_quality',
        confidence: 0.85,
      ));
    }

    // Check irritability
    final irritableDays = recentLogs.where((l) => l.feltIrritable == true).length;
    if (irritableDays >= 2) {
      insights.add(AIInsightResult(
        title: 'イライラ感覚',
        message: 'イライラすることが多くなっています。睡眠不足の可能性があります。',
        category: 'sleep_quality',
        confidence: 0.8,
      ));
    }

    // General recommendation
    insights.add(AIInsightResult(
      title: '改善のヒント',
      message: '就寝2時間前から画面を見ないようにしてみましょう。',
      category: 'recommendation',
      confidence: 0.7,
    ));

    return insights.take(3).toList();
  }

  /// Fallback weekly summary
  String _generateFallbackSummary(List<DailyLog> logs) {
    if (logs.isEmpty) {
      return 'まだデータがありません。毎日記録を続けましょう！';
    }

    final recent7 = logs.take(7).toList();
    final completed = recent7.where((l) => l.eveningCompleted || l.morningCompleted).length;
    final rate = ((completed / 7) * 100).round();

    if (rate >= 80) {
      return '先週は$rate%の達成率！素晴らしいペースで習慣化が進んでいます。';
    } else if (rate >= 50) {
      return '先週は$rate%の達成率。着実に積み上げていますね。';
    } else {
      return '先週は$rate%の達成率。少しずつ続けていきましょう。';
    }
  }
}
