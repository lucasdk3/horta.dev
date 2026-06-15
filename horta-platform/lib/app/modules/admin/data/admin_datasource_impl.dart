import '../../../core/network/api_service.dart';
import 'admin_datasource.dart';

class AdminDatasourceImpl implements AdminDatasource {
  const AdminDatasourceImpl(this._api);

  final ApiService _api;

  @override
  Future<List<Map<String, dynamic>>> fetchSurveyRequests() async {
    final res = await _api.client.get('/api/v1/survey-requests');
    final List<dynamic> data =
        res.data is List ? res.data : res.data['requests'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> approveSurveyRequest(String id) async {
    await _api.client.patch('/api/v1/survey-requests/$id/approve');
  }

  @override
  Future<void> rejectSurveyRequest(String id) async {
    await _api.client.patch('/api/v1/survey-requests/$id/reject');
  }

  @override
  Future<void> deleteSurveyRequest(String id) async {
    await _api.client.delete('/api/v1/survey-requests/$id');
  }
}
