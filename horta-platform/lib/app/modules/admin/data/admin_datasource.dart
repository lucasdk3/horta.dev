abstract interface class AdminDatasource {
  Future<List<Map<String, dynamic>>> fetchSurveyRequests();
  Future<void> approveSurveyRequest(String id);
  Future<void> rejectSurveyRequest(String id);
  Future<void> deleteSurveyRequest(String id);
}
