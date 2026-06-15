abstract interface class NurseryDatasource {
  Future<List<Map<String, dynamic>>> fetchSurveys();
  Future<Map<String, dynamic>> fetchSurveyById(String id);
  Future<List<Map<String, dynamic>>> fetchSurveyResponses(String surveyId);
  Future<void> submitResponse(Map<String, dynamic> payload);
  Future<void> createSurveyRequest(Map<String, dynamic> payload);
  Future<String> fetchSurveySummary({
    required String surveyId,
    required String lang,
    String countryFilter = 'Global',
  });
  Future<String> chatWithSurvey({
    required String surveyId,
    required List<Map<String, dynamic>> history,
    required String message,
    required String lang,
  });
}
