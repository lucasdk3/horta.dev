import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/survey.dart';

abstract interface class NurseryRepository {
  Future<Either<Failure, List<Survey>>> fetchSurveys();
  Future<Either<Failure, Survey>> fetchSurveyById(String id);
  Future<Either<Failure, void>> submitResponse(Map<String, dynamic> payload);
  Future<Either<Failure, void>> createSurveyRequest(Map<String, dynamic> payload);
}
