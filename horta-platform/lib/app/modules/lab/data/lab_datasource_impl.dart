import '../../../core/network/api_service.dart';
import 'lab_datasource.dart';

class LabDatasourceImpl implements LabDatasource {
  const LabDatasourceImpl(this._api);

  final ApiService _api;

  @override
  Future<List<Map<String, dynamic>>> fetchSurveys() async {
    final res = await _api.client.get('/api/v1/surveys');
    final List<dynamic> data =
        res.data is List ? res.data : res.data['surveys'] ?? [];
    return data.cast<Map<String, dynamic>>();
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
  Future<String> chatGlobal({
    required List<Map<String, dynamic>> surveysMetadata,
    required List<Map<String, dynamic>> history,
    required String message,
    required String lang,
  }) async {
    final res = await _api.client.post('/api/v1/ai/chat', data: {
      'surveys': surveysMetadata,
      'history': history,
      'message': message,
      'lang': lang,
    });
    return res.data['reply'] ?? '';
  }
}
