import '../../../core/network/api_service.dart';
import 'garden_datasource.dart';

class GardenDatasourceImpl implements GardenDatasource {
  const GardenDatasourceImpl(this._api);

  final ApiService _api;

  @override
  Future<Map<String, dynamic>> fetchMyProfile() async {
    final res = await _api.client.get('/api/v1/me');
    return res.data as Map<String, dynamic>;
  }
}
