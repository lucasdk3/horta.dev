import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/nursery_datasource.dart';
import '../entities/survey.dart';
import 'nursery_repository.dart';

class NurseryRepositoryImpl implements NurseryRepository {
  const NurseryRepositoryImpl(this._datasource);

  final NurseryDatasource _datasource;

  @override
  Future<Either<Failure, List<Survey>>> fetchSurveys() async {
    try {
      final data = await _datasource.fetchSurveys();
      return Right(data.map(Survey.fromJson).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Survey>> fetchSurveyById(String id) async {
    try {
      final data = await _datasource.fetchSurveyById(id);
      return Right(Survey.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitResponse(
      Map<String, dynamic> payload) async {
    try {
      await _datasource.submitResponse(payload);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createSurveyRequest(
      Map<String, dynamic> payload) async {
    try {
      await _datasource.createSurveyRequest(payload);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
