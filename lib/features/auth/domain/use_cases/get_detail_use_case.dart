import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobsit_mobile/core/error/failures.dart';
import 'package:jobsit_mobile/features/auth/data/models/candidate_model.dart';
import 'package:jobsit_mobile/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class GetDetailUseCase {
  final AuthRepository repo;
  GetDetailUseCase(this.repo);

  Future<Either<Failure, CandidateModel>> call({required int candidateId}) {
    return repo.getDetail(candidateId: candidateId);
  }
}