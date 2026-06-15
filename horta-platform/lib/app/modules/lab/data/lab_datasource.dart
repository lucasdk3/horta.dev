abstract interface class LabDatasource {
  Future<List<Map<String, dynamic>>> fetchSurveys();
  Future<String> fetchSurveySummary({
    required String surveyId,
    required String lang,
    String countryFilter = 'Global',
  });
  Future<String> chatGlobal({
    required List<Map<String, dynamic>> surveysMetadata,
    required List<Map<String, dynamic>> history,
    required String message,
    required String lang,
  });
}
