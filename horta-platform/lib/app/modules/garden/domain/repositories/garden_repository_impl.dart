import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/garden_datasource.dart';
import '../entities/user_profile.dart';
import 'garden_repository.dart';

class GardenRepositoryImpl implements GardenRepository {
  const GardenRepositoryImpl(this._datasource);

  final GardenDatasource _datasource;

  @override
  Future<Either<Failure, UserProfile>> fetchMyProfile() async {
    try {
      final data = await _datasource.fetchMyProfile();
      return Right(UserProfile.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
