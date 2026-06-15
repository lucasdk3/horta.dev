import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/survey_request.dart';

abstract interface class AdminRepository {
  Future<Either<Failure, List<SurveyRequest>>> fetchSurveyRequests();
  Future<Either<Failure, void>> approve(String id);
  Future<Either<Failure, void>> reject(String id);
  Future<Either<Failure, void>> delete(String id);
}
