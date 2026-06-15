import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/admin_datasource.dart';
import '../entities/survey_request.dart';
import 'admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl(this._datasource);

  final AdminDatasource _datasource;

  @override
  Future<Either<Failure, List<SurveyRequest>>> fetchSurveyRequests() async {
    try {
      final data = await _datasource.fetchSurveyRequests();
      final requests = data.map(SurveyRequest.fromJson).toList()
        ..sort((a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approve(String id) async {
    try {
      await _datasource.approveSurveyRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reject(String id) async {
    try {
      await _datasource.rejectSurveyRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _datasource.deleteSurveyRequest(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
