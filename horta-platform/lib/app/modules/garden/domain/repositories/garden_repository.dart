import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_profile.dart';

abstract interface class GardenRepository {
  Future<Either<Failure, UserProfile>> fetchMyProfile();
}
