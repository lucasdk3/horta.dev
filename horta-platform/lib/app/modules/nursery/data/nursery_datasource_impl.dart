import '../../../core/network/api_service.dart';
import 'nursery_datasource.dart';

class NurseryDatasourceImpl implements NurseryDatasource {
  const NurseryDatasourceImpl(this._api);

  final ApiService _api;

  @override
  Future<List<Map<String, dynamic>>> fetchSurveys() async {
    final res = await _api.client.get('/api/v1/surveys');
    final List<dynamic> data =
        res.data is List ? res.data : res.data['surveys'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> fetchSurveyById(String id) async {
    final res = await _api.client.get('/api/v1/surveys/$id');
    return res.data as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchSurveyResponses(
      String surveyId) async {
    final res = await _api.client.get('/api/v1/surveys/$surveyId/responses');
    final List<dynamic> data =
        res.data is List ? res.data : res.data['responses'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> submitResponse(Map<String, dynamic> payload) async {
    await _api.client.post('/api/v1/responses', data: payload);
  }

  @override
  Future<void> createSurveyRequest(Map<String, dynamic> payload) async {
    await _api.client.post('/api/v1/survey-requests', data: payload);
  }

  @override
  Future<String> fetchSurveySummary({
    required String surveyId,
    required String lang,
    String countryFilter = 'Global',
  }) async {
    final res = await _api.client.get(
      '/api/v1/ai/surveys/$surveyId/summary',
      queryParameters: {'lang': lang, 'country': countryFilter},
    );
    return res.data['summary'] ?? '';
  }

  @override
  Future<String> chatWithSurvey({
    required String surveyId,
    required List<Map<String, dynamic>> history,
    required String message,
    required String lang,
  }) async {
    final res =
        await _api.client.post('/api/v1/ai/surveys/$surveyId/chat', data: {
      'history': history,
      'message': message,
      'lang': lang,
    });
    return res.data['reply'] ?? '';
  }
}
